import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flurry_event/flurry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:glider/config/app_config.dart' as config;
import 'package:glider/dynamic_theme/dynamic_theme.dart';
import 'package:glider/generated/l10n.dart';
import 'package:glider/repo/LoginRepo.dart';
import 'package:glider/route_generator.dart';
import 'package:glider/util/Settings.dart';
import 'package:glider/util/Utils.dart';
import 'package:rxdart/rxdart.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

class ReceivedNotification {
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}

final _kShouldTestAsyncErrorOnInit = false;

// Toggle this for testing Crashlytics in your app locally.
final _kTestingCrashlytics = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await GlobalConfiguration().loadFromAsset("configurations");
  mobileLanguage.value = await Utils.getLanguange();
  await Firebase.initializeApp();
  await _initializeFlutterFire();
  initNotification();
  getMessage();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarBrightness:
          Brightness.light // Dark == white status bar -- for IOS.
      ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runZonedGuarded(() {
      runApp(MyApp());
    }, (error, stackTrace) {
      print('runZonedGuarded: Caught error in my root zone.');
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    });
  });
}

Future<void> _initializeFlutterFire() async {
  // Wait for Firebase to initialize

  if (_kTestingCrashlytics) {
    // Force enable crashlytics collection enabled if we're testing it.
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  } else {
    // Else only enable it in non-debug builds.
    // You could additionally extend this to allow users to opt-in.
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(!kDebugMode);
  }

  // Pass all uncaught errors to Crashlytics.
  Function originalOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails errorDetails) async {
    await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    // Forward to original handler.
    originalOnError(errorDetails);
  };

  if (_kShouldTestAsyncErrorOnInit) {
    await _testAsyncErrorOnInit();
  }
}

Future<void> _testAsyncErrorOnInit() async {
  Future<void>.delayed(const Duration(seconds: 2), () {
    final List<int> list = <int>[];
    print(list[100]);
  });
}

void initNotification() async {
  // final NotificationAppLaunchDetails notificationAppLaunchDetails =
  //     await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher');

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          onDidReceiveLocalNotification:
              (int id, String title, String body, String payload) async {
            print("ios received notification");
          });

  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      selectNotificationSubject.add(payload);
    }
  });
}

Future myBackgroundMessageHandler(RemoteMessage message) {
  print("onBackgroundMessage");
  print(message);
  // var notification = message["notification"];
  // didReceiveLocalNotificationSubject.add(ReceivedNotification(
  //     id: DateTime.now().microsecondsSinceEpoch,
  //     title: notification["title"],
  //     body: notification["body"],
  //     payload: jsonEncode(message)));

  // Or do other work.
  return Future<void>.value();
}

void initFlurry() async {
  await FlurryEvent.initialize(
    androidKey: "PQ8DXR2KV544Y3TRNHRY",
    iosKey: "CX5ZJXJHMSJC8Z7RFP5G",
    enableLog: true,
  );
}

void getMessage() async {
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.onMessage.listen((event) {
    print("push");
    print(event);
    didReceiveLocalNotificationSubject.add(ReceivedNotification(
        id: DateTime.now().microsecondsSinceEpoch,
        title: event.notification.title,
        body: event.notification.body,
        payload: jsonEncode(event.data)));
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
    selectNotificationSubject.add(jsonEncode(message.data));
  });
}

class MyApp extends StatelessWidget {
  final navigatorKey = GlobalKey<NavigatorState>();

  void handleSessionExpired() async {
    sessionExpired.addListener(() async {
      if (sessionExpired.value) {
        print("Session Expired");
        Future.delayed(Duration(milliseconds: 100)).then((value) async {
          await Utils.clearall();

          navigatorKey.currentState
              .pushNamedAndRemoveUntil("/splash", (route) => false);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    handleSessionExpired();

    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) {
          if (brightness == Brightness.light) {
            return ThemeData(
              useTextSelectionTheme: true,
              backgroundColor: config.Colors().white,
              fontFamily: 'open',
              primarySwatch: config.Colors()
                  .generateMaterialColor(config.Colors().mainColor),
              primaryColor: config.Colors().mainColor,
              brightness: brightness,
              buttonTheme: ButtonThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                textTheme: ButtonTextTheme.normal,
                buttonColor: config.Colors().orangeColor,
              ),
              buttonColor: config.Colors().orangeColor,
              accentColor: config.Colors().orangeColor,
              focusColor: config.Colors().accentColor,
              hintColor: config.Colors().secondColor,
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: <TargetPlatform, PageTransitionsBuilder>{
                  TargetPlatform.android: ZoomPageTransitionsBuilder(),
                  TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
                },
              ),
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: config.Colors().orangeColor,
                selectionColor: config.Colors().orangeColor,
                selectionHandleColor: config.Colors().orangeColor,
              ),
              appBarTheme: AppBarTheme(
                elevation: 0,
                centerTitle: true,
              ),
              textTheme: TextTheme(
                headline5: TextStyle(
                    fontSize: 20.0, color: config.Colors().secondColor),
                headline4: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: config.Colors().secondColor),
                headline3: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: config.Colors().secondColor),
                headline2: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700,
                    color: config.Colors().secondColor),
                headline1: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w300,
                    color: config.Colors().secondColor),
                subtitle1: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: config.Colors().secondColor),
                headline6: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: config.Colors().secondColor),
                bodyText2: TextStyle(
                    fontSize: 12.0, color: config.Colors().secondColor),
                bodyText1: TextStyle(
                    fontSize: 14.0, color: config.Colors().secondColor),
                caption: TextStyle(
                    fontSize: 12.0, color: config.Colors().accentColor),
              ),
            );
          } else {
            return ThemeData(
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: <TargetPlatform, PageTransitionsBuilder>{
                  TargetPlatform.android: ZoomPageTransitionsBuilder(),
                  TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
                },
              ),
              useTextSelectionTheme: true,
              cursorColor: config.Colors().orangeColor,
              textSelectionColor: config.Colors().orangeColor,
              textSelectionHandleColor: config.Colors().orangeColor,
              fontFamily: 'open',
              primarySwatch: config.Colors()
                  .generateMaterialColor(config.Colors().mainDarkColor),
              buttonColor: config.Colors().mainColor,
              primaryColor: Color(0xFF252525),
              brightness: Brightness.dark,
              scaffoldBackgroundColor: Color(0xFF2C2C2C),
              buttonTheme: ButtonThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                buttonColor: config.Colors().orangeColor,
              ),
              accentColor: config.Colors().accentColor,
              hintColor: config.Colors().secondDarkColor,
              focusColor: config.Colors().accentDarkColor,
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: config.Colors().orangeColor,
                selectionColor: config.Colors().orangeColor,
                selectionHandleColor: config.Colors().orangeColor,
              ),
              appBarTheme: AppBarTheme(
                elevation: 0,
                centerTitle: true,
              ),
              textTheme: TextTheme(
                headline5: TextStyle(
                    fontSize: 20.0, color: config.Colors().secondDarkColor),
                headline4: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: config.Colors().secondDarkColor),
                headline3: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: config.Colors().secondDarkColor),
                headline2: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700,
                    color: config.Colors().mainDarkColor),
                headline1: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w300,
                    color: config.Colors().secondDarkColor),
                subtitle1: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: config.Colors().secondDarkColor),
                headline6: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: config.Colors().mainDarkColor),
                bodyText2: TextStyle(
                    fontSize: 12.0, color: config.Colors().secondDarkColor),
                bodyText1: TextStyle(
                    fontSize: 14.0, color: config.Colors().secondDarkColor),
                caption: TextStyle(
                    fontSize: 12.0, color: config.Colors().secondDarkColor),
              ),
            );
          }
        },
        themedWidgetBuilder: (context, theme) {
          return ValueListenableBuilder(
              valueListenable: mobileLanguage,
              builder: (context, Locale locale, _) {
                return MaterialApp(
                  title: "Glider",
                  navigatorKey: navigatorKey,
                  initialRoute: '/splash',
                  onGenerateRoute: RouteGenerator.generateRoute,
                  debugShowCheckedModeBanner: false,
                  locale: locale,
                  localizationsDelegates: [
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  supportedLocales: S.delegate.supportedLocales,
                  theme: theme,
                );
              });
        });
  }
}
