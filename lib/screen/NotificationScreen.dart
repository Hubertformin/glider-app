import 'package:date_format/date_format.dart' as dateformat;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/bloc/NotificationBloc.dart';
import 'package:glider/config/app_config.dart' as config;
import 'package:glider/core/InheritedStateContainer.dart';
import 'package:glider/core/glidertate.dart';
import 'package:glider/event/GetNotificationEvent.dart';
import 'package:glider/generated/l10n.dart';
import 'package:glider/model/NotificationModel.dart' as notificaton;
import 'package:glider/state/BaseState.dart';
import 'package:glider/state/NotificationListState.dart';
import 'package:glider/widget/ProgressIndicatorWidget.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NotificationScreenScreenState();
  }
}

class NotificationScreenScreenState extends glidertate<NotificationScreen> {
  NotificationBloc mBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mBloc = NotificationBloc();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      update();
    });
  }

  Widget cardView(notificaton.Notification item) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Card(
        elevation: 5,
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      item.title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        generateDateTime(item),
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  child: Text(
                    item.msg,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: config.Colors().color1C1E28,
      ),
      child: InheritedStateContainer(
          state: this,
          child: Scaffold(
              body: BlocProvider(
                  create: (BuildContext context) => NotificationBloc(),
                  child: BlocBuilder<NotificationBloc, BaseState>(
                      bloc: mBloc,
                      builder: (BuildContext context, BaseState state) {
                        if (state is NotificationListState) {
                          return ListView.builder(
                            itemBuilder: (context, index) {
                              return cardView(state.productModel.data[index]);
                            },
                            itemCount: state.productModel.data.length,
                          );
                        } else {
                          return ProgressIndicatorWidget();
                        }
                      })),
              appBar: AppBar(
                elevation: 0,
                iconTheme: IconThemeData(color: config.Colors().white),
                brightness: Brightness.dark,
                backgroundColor: config.Colors().color1C1E28,
                title: Text(
                  S.of(context).notification,
                  style: TextStyle(color: Colors.white),
                ),
              ))),
    );
  }

  String generateDateTime(notificaton.Notification data) {
    String date = dateformat
        .formatDate(data.createdAt, [dateformat.dd, ' ', dateformat.M]);
    return date;
  }

  @override
  void update() {
    mBloc.add(GetNotificationEvent());
  }
}
