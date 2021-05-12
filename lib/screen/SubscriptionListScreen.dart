import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentors/bloc/SubscriptionBloc.dart';
import 'package:rentors/config/app_config.dart' as config;
import 'package:rentors/core/InheritedStateContainer.dart';
import 'package:rentors/core/RentorState.dart';
import 'package:rentors/event/SubscriptionListEvent.dart';
import 'package:rentors/generated/l10n.dart';
import 'package:rentors/model/FeatureSubscriptionList.dart';
import 'package:rentors/state/BaseState.dart';
import 'package:rentors/state/SubscriptionListState.dart';
import 'package:rentors/widget/ProgressIndicatorWidget.dart';
import 'package:rentors/widget/RentorGradient.dart';

class SubScriptionListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SubScriptionListScreenState();
  }
}

class SubScriptionListScreenState extends RentorState<SubScriptionListScreen> {
  SubscriptionBloc mBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mBloc = SubscriptionBloc();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      update();
    });
  }

  Widget cardView(Feature item) {
    return InkWell(
        onTap: () {},
        child: Container(
          margin: EdgeInsets.all(10),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(
                  color: config.Colors().orangeColor,
                  width: 2.0,
                )),
            elevation: 5,
            child: Container(
              margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                            fontSize: 20, color: config.Colors().orangeColor),
                      ),
                    ],
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.period,
                            style: TextStyle(
                                fontSize: 16,
                                color: config.Colors().orangeColor),
                          )
                        ],
                      )),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      item.currencyType + " " + item.price,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: config.Colors().orangeColor),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: config.App(context).appWidth(45),
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            gradient: RentorGradient(),
                            borderRadius: BorderRadius.circular(5)),
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            var map = Map();
                            map["feat"] = item;
                            map["prod"] = null;
                            Navigator.of(context)
                                .popAndPushNamed("/payment_method",
                                    arguments: map)
                                .then((value) {
                              RentorState.of(context).update();
                            });
                          },
                          child: Text(
                            S.of(context).subscribe,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
      ),
      child: InheritedStateContainer(
          state: this,
          child: Scaffold(
              body: BlocProvider(
                  create: (BuildContext context) => SubscriptionBloc(),
                  child: BlocBuilder<SubscriptionBloc, BaseState>(
                      bloc: mBloc,
                      builder: (BuildContext context, BaseState state) {
                        if (state is SubscriptionListState) {
                          return ListView.builder(
                            itemBuilder: (context, index) {
                              return cardView(state
                                  .subscriptionList.subscriptionData[index]);
                            },
                            itemCount:
                                state.subscriptionList.subscriptionData.length,
                          );
                        } else {
                          return ProgressIndicatorWidget();
                        }
                      })),
              appBar: AppBar(
                elevation: 0,
                title: Text(S.of(context).subscription),
              ))),
    );
  }

  @override
  void update() {
    mBloc.add(SubscriptionListEvent());
  }
}
