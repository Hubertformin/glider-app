import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glider/model/MyProductModel.dart';
import 'package:glider/model/booking/MyBooking.dart' as booking;
import 'package:glider/model/category/CategoryDetailModel.dart'
    as categoryDetail;
import 'package:glider/model/home/HomeModel.dart';
import 'package:glider/model/productdetail/ProductDetailModel.dart';
import 'package:glider/screen/AddPersonalDetailScreen.dart';
import 'package:glider/screen/ChangePasswordScreen.dart';
import 'package:glider/screen/ComplaintScreen.dart';
import 'package:glider/screen/CreateProductScreenWidget.dart';
import 'package:glider/screen/DrawerHomeWidget.dart';
import 'package:glider/screen/ForgotPasswordScreen.dart';
import 'package:glider/screen/InAppWebViewScreen.dart';
import 'package:glider/screen/LanguangeScreen.dart';
import 'package:glider/screen/NotificationScreen.dart';
import 'package:glider/screen/SearchScreen.dart';
import 'package:glider/screen/SettingScreen.dart';
import 'package:glider/screen/SignWithEmailWidget.dart';
import 'package:glider/screen/SignWithMobileWidget.dart';
import 'package:glider/screen/SignupScreen.dart';
import 'package:glider/screen/SubscriptionListScreen.dart';
import 'package:glider/screen/UserProfileScreen.dart';
import 'package:glider/screen/VerifyOTPWidget.dart';
import 'package:glider/screen/WishListScreen.dart';
import 'package:glider/screen/booking/BookProductScreen.dart';
import 'package:glider/screen/booking/BookingDetailScreen.dart';
import 'package:glider/screen/booking/BookingScreen.dart';
import 'package:glider/screen/booking/BuyerDetailScreen.dart';
import 'package:glider/screen/booking/MyBookingRequestScreen.dart';
import 'package:glider/screen/booking/ProductPreviewScreen.dart';
import 'package:glider/screen/cateogry/CategoryDetailsScreen.dart';
import 'package:glider/screen/cateogry/CategoryScreenWidget.dart';
import 'package:glider/screen/cateogry/SubcategoryDetailScreen.dart';
import 'package:glider/screen/chat/ChatScreen.dart';
import 'package:glider/screen/chat/ConversationScreen.dart';
import 'package:glider/screen/payment/PaymentScreen.dart';
import 'package:glider/screen/payment/SelectPaymentMethodScreen.dart';
import 'package:glider/screen/product/AllProductListScreen.dart';
import 'package:glider/screen/product/MyProductListingScreen.dart';
import 'package:glider/screen/product/ProductDetailWidget.dart';
import 'package:glider/screen/product/TopFeatureProductScreen.dart';
import 'package:glider/screen/splash/PagerViewWidget.dart';
import 'package:glider/screen/splash/SplashScreenWidget.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case '/splash':
        return CupertinoPageRoute(builder: (_) => SplashScreenWidget());
      case '/pager':
        return CupertinoPageRoute(builder: (_) => PagerViewWidget());
      case '/email':
        return CupertinoPageRoute(builder: (_) => SignWithEmailWidget());
      case '/forgot':
        return CupertinoPageRoute(builder: (_) => ForgotPasswordScreen());
      case '/signup':
        return CupertinoPageRoute(builder: (_) => SignupScreen());
      case '/otp':
        return CupertinoPageRoute(builder: (_) => SignWithMobileWidget());
      case '/verify':
        var map = args as Map;
        return CupertinoPageRoute(
            builder: (_) => VerifyOTPWidget(map["verificationId"],
                map["mobileNumber"], map["number"], map["code"]));
      case '/home':
        return CupertinoPageRoute(builder: (_) => DrawerHomeWidget());
      case '/myproduct':
        return CupertinoPageRoute(builder: (_) => MyProductListingScreen());
      case '/create_product':
        return CupertinoPageRoute(
            builder: (_) => CreateProductScreenWidget(args as MyProduct));
      case '/top_featured':
        return CupertinoPageRoute(
            builder: (_) =>
                TopFeatureProductScreen(args as List<FeaturedProductElement>));
      case '/personal_detail':
        Map map = args;
        return CupertinoPageRoute(
            builder: (_) => AddPersonalDetailScreen(map['new'], map['old']));
      case '/category':
        return CupertinoPageRoute(builder: (_) => CategoryScreenWidget());

      case '/conversation':
        return CupertinoPageRoute(builder: (_) => ConversationScreen());
      case '/chat':
        return CupertinoPageRoute(builder: (_) => ChatScreen(args as String));
      case '/product_details':
        Map map = args;
        return MaterialPageRoute(
            builder: (_) => ProductDetailsWidget(map["name"], map["id"]));
      case '/category_detail':
        return CupertinoPageRoute(
            builder: (_) => CategoryDetailsScreen(args as String));
      case '/booking':
        return CupertinoPageRoute(builder: (_) => BookingScreen());

      case '/booking_request':
        return CupertinoPageRoute(
            builder: (_) => MyBookingRequestScreen(args as String));

      case '/buyer_detail':
        return CupertinoPageRoute(
            builder: (_) => BuyerDetailScreen(args as booking.Datum));
      case '/settings':
        return CupertinoPageRoute(builder: (_) => SettingScreen());
      case '/wishlist':
        return CupertinoPageRoute(builder: (_) => WishListScreen());
      case '/profile':
        return CupertinoPageRoute(builder: (_) => UserProfileScreen());
      case '/complaint':
        return CupertinoPageRoute(builder: (_) => ComplaintScreen());
      case '/booking_details':
        return CupertinoPageRoute(
            builder: (_) => BookingDetailScreen(args as booking.Datum));
      case '/change_password':
        return CupertinoPageRoute(builder: (_) => ChangePasswordScreen());
      case '/search':
        return MaterialPageRoute(builder: (_) => SearchScreen());
      case '/allproduct':
        return CupertinoPageRoute(
            builder: (_) => AllProductListScreen(args as SubCategory));
      case '/book_product':
        return CupertinoPageRoute(
            builder: (_) => BookProductScreen(args as ProductDetailModel));
      case '/subscription':
        return CupertinoPageRoute(builder: (_) => SubScriptionListScreen());
      case '/preview':
        return CupertinoPageRoute(builder: (_) => ProductPreviewScreen(args));
      case '/notification':
        return CupertinoPageRoute(builder: (_) => NotificationScreen());
      case '/payment_method':
        Map map = args;
        var feature = map["feat"];
        var product = map["prod"];
        return CupertinoPageRoute(
            builder: (_) => SelectPaymentMethodScreen(
                  product,
                  feature: feature,
                ));
      case '/payment_checkout':
        Map map = args;
        var feature = map["feat"];
        var product = map["prod"];
        var type = map["t"];
        return CupertinoPageRoute(
            builder: (_) => PaymentScreen(product, feature, type));
      case '/subcategory_detail':
        return CupertinoPageRoute(
            builder: (_) =>
                SubcategoryDetailScreen(args as categoryDetail.SubCategory));
      case '/webview':
        Map map = args;
        return CupertinoPageRoute(
            builder: (_) => InAppWebViewScreen(map["title"], map["url"]));
      case '/lang':
        return CupertinoPageRoute(builder: (_) => LanguangeScreen());

//
    }
    return null;
  }
}
