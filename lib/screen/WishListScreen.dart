import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:glider/bloc/WishListBloc.dart';
import 'package:glider/config/app_config.dart' as config;
import 'package:glider/core/InheritedStateContainer.dart';
import 'package:glider/core/GliderState.dart';
import 'package:glider/event/WishListEvent.dart';
import 'package:glider/generated/l10n.dart';
import 'package:glider/model/wishlist/WishList.dart';
import 'package:glider/state/BaseState.dart';
import 'package:glider/state/ErrorState.dart';
import 'package:glider/state/OtpState.dart';
import 'package:glider/state/WishListState.dart';
import 'package:glider/util/Utils.dart';
import 'package:glider/widget/EmptyWidget.dart';
import 'package:glider/widget/FeatureWidget.dart';
import 'package:glider/widget/LikeWidget.dart';
import 'package:glider/widget/NetworkErrorWidget.dart';
import 'package:glider/widget/PlaceHolderWidget.dart';
import 'package:glider/widget/ProgressIndicatorWidget.dart';

class WishListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WishListScreenState();
  }
}

class WishListScreenState extends GliderState<WishListScreen> {
  WishListBloc mBloc;

  WishList data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mBloc = WishListBloc();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      update();
    });
  }

  void openDetails(BuildContext context, WishItem products) async {
    var map = Map();
    map["id"] = products.id;
    map["name"] = products.details.productName;
    Navigator.of(context).pushNamed("/product_details", arguments: map);
  }

  Widget cardView(WishItem item) {
    return InkWell(
        onTap: () {
          openDetails(context, item);
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Card(
            elevation: 5,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(children: [
                    ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5)),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: OptimizedCacheImage(
                              placeholder: (context, url) {
                                return PlaceHolderWidget();
                              },
                              fit: BoxFit.fill,
                              imageUrl: item.details.images),
                        )),
                    FeatureWidget(
                      item.isFeatured,
                      radius: 4,
                    )
                  ]),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: config.Colors().color545454),
                        ),
                        LikeWidget(item.id, "1")
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(Utils.generateStringV2(item.details.fileds))),
                  // Container(
                  //     margin: EdgeInsets.symmetric(horizontal: 5),
                  //     child: RichText(
                  //       text: TextSpan(
                  //         text: '',
                  //         style: DefaultTextStyle.of(context).style,
                  //         children: Utils.generateStringV3(item.details.fileds),
                  //       ),
                  //     )),
                  Container(
                    margin:
                        EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          S.of(context).startings(item.details.price),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: config.Colors().color00A03E,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return InheritedStateContainer(
        state: this,
        child: Scaffold(
            body: BlocProvider(
                create: (BuildContext context) => WishListBloc(),
                child: BlocBuilder<WishListBloc, BaseState>(
                    bloc: mBloc,
                    builder: (BuildContext context, BaseState state) {
                      if (state is ErrorState) {
                        return NetworkWidget();
                      } else if (state is LoadingState && data == null) {
                        return ProgressIndicatorWidget();
                      } else if (state is WishListState) {
                        data = state.home;
                      }
                      if (data.data.isEmpty) {
                        return EmptyWidget();
                      }
                      return ListView.separated(
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 10,
                          );
                        },
                        itemBuilder: (context, index) {
                          return cardView(data.data[index]);
                        },
                        itemCount: data.data.length,
                      );
                    })),
            appBar: AppBar(
              title: Text(S.of(context).wishlist),
            )));
  }

  @override
  void update() {
    mBloc.add(WishListEvent());
  }
}
