import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:date_format/date_format.dart' as dateformat;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:rentors/config/app_config.dart' as config;
import 'package:rentors/core/RentorState.dart';
import 'package:rentors/generated/l10n.dart';
import 'package:rentors/model/FeatureSubscriptionList.dart';
import 'package:rentors/model/UserModel.dart';
import 'package:rentors/model/home/HomeModel.dart';
import 'package:rentors/model/productdetail/ProductDetailModel.dart';
import 'package:rentors/util/FeaturePaymentManager.dart';
import 'package:rentors/util/Utils.dart';
import 'package:rentors/widget/CircularImageWidget.dart';
import 'package:rentors/widget/FeatureWidget.dart';
import 'package:rentors/widget/LikeWidget.dart';
import 'package:rentors/widget/PlaceHolderWidget.dart';
import 'package:rentors/widget/ProgressDialog.dart';
import 'package:rentors/widget/ProgressIndicatorWidget.dart';
import 'package:rentors/widget/RentorRaisedButton.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ProductOverViewWidget extends StatefulWidget {
  final ProductDetailModel mModel;

  ProductOverViewWidget(this.mModel);

  @override
  State<StatefulWidget> createState() {
    return ProductOverViewWidgetState();
  }
}

class ProductOverViewWidgetState extends State<ProductOverViewWidget> {
  UserModel model;

  ProgressDialog dialog;
  List<Feature> featureListData = List();
  Feature selectedFeature;
  FeaturePaymentManager _featurePaymentManager;

  @override
  void initState() {
    super.initState();
    fetchUserDetail();
    _featurePaymentManager = FeaturePaymentManager(
        context,
        widget.mModel.data.name,
        widget.mModel.data.details.images,
        widget.mModel.data.id);
  }

  void fetchUserDetail() async {
    model = await Utils.getUser();
  }

  void gotoPaymentMethod() {
    if (selectedFeature == null) {
      Fluttertoast.showToast(msg: S.of(context).pleaseSelectAnyFeature);
      return;
    }
    var map = Map();
    map["feat"] = selectedFeature;
    map["prod"] = widget.mModel;
    Navigator.of(context)
        .popAndPushNamed("/payment_method", arguments: map)
        .then((value) {
      RentorState.of(context).update();
    });
  }

  Widget chatWithOwnerWidget() {
    return Container(
      margin: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 5, right: 5),
              child: Hero(
                tag: "chat_with_owner",
                child: OutlineButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("/chat",
                        arguments: widget.mModel.data.userId);
                  },
                  child: Text(
                    S.of(context).chatWithOwner,
                    style: TextStyle(color: config.Colors().orangeColor),
                  ),
                  borderSide: BorderSide(color: config.Colors().orangeColor),
                  shape: StadiumBorder(),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 5, right: 5),
              child: RentorRaisedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed("/book_product", arguments: widget.mModel);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    S.of(context).bookNow,
                    style: TextStyle(
                        color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  bool isActive(ProductDetailModel product) {
    return product.data.isApproved == "1" && product.data.status == "1";
  }

  Widget addToFeature(ProductDetailModel product) {
    Color containerColor = isActive(product)
        ? config.Colors().colorF25633
        : config.Colors().colorEBEBEB;
    Color textColor = isActive(product)
        ? config.Colors().white
        : config.Colors().statusGrayColor;
    return InkWell(
      onTap: () {
        if (isActive(product)) {
          _featurePaymentManager.requestBloc();
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.only(left: 15, bottom: 5, top: 5, right: 15),
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.add,
                  size: 16,
                  color: textColor,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  S.of(context).addToFeature,
                  style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w800),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool isMyProduct(UserModel data) {
    return data.data.id == widget.mModel.data.userId;
  }

  void updateFeatureData(Feature data) {}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
        future: Utils.getUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                body: Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: PageTransitionSwitcher(
                      duration: const Duration(milliseconds: 3000),
                      transitionBuilder: (
                        Widget child,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                      ) {
                        return SharedAxisTransition(
                          child: child,
                          animation: animation,
                          secondaryAnimation: secondaryAnimation,
                          transitionType: SharedAxisTransitionType.horizontal,
                        );
                      },
                      child: SingleChildScrollView(
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Hero(
                                    tag: widget.mModel.data.id,
                                    child: AspectRatio(
                                      aspectRatio: 1.7,
                                      child: OptimizedCacheImage(
                                          placeholder: (context, url) {
                                            return PlaceHolderWidget();
                                          },
                                          fit: BoxFit.fill,
                                          imageUrl: Utils.getImageUrl(widget
                                              .mModel.data.details.images)),
                                    ),
                                  ),
                                  Hero(
                                    tag: widget.mModel.data.id + "_feature",
                                    child: FeatureWidget(
                                      widget.mModel.data.isFeatured,
                                      fontSize: 16,
                                      radius: 0,
                                    ),
                                  )
                                ],
                              ),
                              Card(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Text(
                                            widget.mModel.data.details.address,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10, top: 10),
                                        ),
                                        Container(
                                          child: LikeWidget(
                                              widget.mModel.data.id,
                                              widget.mModel.data.isLike),
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10, top: 10),
                                        )
                                      ],
                                    ),
                                    Container(
                                        margin: EdgeInsets.all(5),
                                        child: Row(
                                          children: [
                                            SmoothStarRating(
                                                allowHalfRating: false,
                                                onRated: (v) {},
                                                starCount: 5,
                                                rating: double.parse(widget
                                                    .mModel.data.avgRatting),
                                                size: 20.0,
                                                isReadOnly: true,
                                                color:
                                                    config.Colors().orangeColor,
                                                borderColor:
                                                    config.Colors().orangeColor,
                                                spacing: 0.0),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(S.of(context).basedOn),
                                            SizedBox(
                                              width: 2,
                                            ),
                                            Text(
                                              S.of(context).reviews(widget
                                                  .mModel
                                                  .data
                                                  .reviewdata
                                                  .length),
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            )
                                          ],
                                        )),
                                    Container(
                                        margin: EdgeInsets.all(5),
                                        child: Text(widget
                                            .mModel.data.details.description)),
                                    Container(
                                        margin: EdgeInsets.all(5),
                                        child: Text(
                                          S.of(context).rate(
                                              widget.mModel.data.details.price +
                                                  "/" +
                                                  priceUnitValues.reverse[widget
                                                      .mModel
                                                      .data
                                                      .details
                                                      .priceUnit]),
                                          style: TextStyle(fontSize: 16),
                                        )),
                                    Container(
                                        margin: EdgeInsets.all(5),
                                        child: Text(
                                          S.of(context).minimumBookingAmount(
                                              widget.mModel.data.details
                                                  .minBookingAmount),
                                          style: TextStyle(fontSize: 14),
                                        )),
                                    isMyProduct(snapshot.data)
                                        ? addToFeature(widget.mModel)
                                        : chatWithOwnerWidget(),
                                  ],
                                ),
                              ),
                              Card(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(
                                            S.of(context).specifications,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10, top: 10),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: config.App(context).appHeight(20),
                                      margin: EdgeInsets.all(5),
                                      child: ListView.builder(
                                          itemCount: widget.mModel.data.details
                                              .fileds.length,
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemBuilder:
                                              (BuildContext ctxt, int index) {
                                            return specificationList(widget
                                                .mModel
                                                .data
                                                .details
                                                .fileds[index]);
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                              Card(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(
                                            S.of(context).userReviews,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10, top: 10),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: config.App(context).appHeight(20),
                                      margin: EdgeInsets.all(5),
                                      child: ListView.builder(
                                          itemCount: widget
                                              .mModel.data.reviewdata.length,
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemBuilder:
                                              (BuildContext ctxt, int index) {
                                            return _userReview(widget
                                                .mModel.data.reviewdata[index]);
                                          }),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )));
          } else {
            return ProgressIndicatorWidget();
          }
        });
  }

  Widget specificationList(Filed filed) {
    return Container(
        width: config.App(context).appWidth(40),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.insert_drive_file_outlined),
                    Text(
                      filed.key,
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      filed.value,
                      style: TextStyle(fontWeight: FontWeight.w300),
                    )
                  ],
                ),
              )),
        ));
  }

  Widget _userReview(Reviewdatum data) {
    return Container(
        width: config.App(context).appWidth(60),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                margin: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Text(
                          S.of(context).five(data.ratting),
                          style: TextStyle(fontSize: 15),
                        ),
                        SmoothStarRating(
                            allowHalfRating: false,
                            onRated: (v) {},
                            starCount: 5,
                            rating: double.parse(data.ratting),
                            size: 15.0,
                            isReadOnly: true,
                            color: config.Colors().orangeColor,
                            borderColor: config.Colors().orangeColor,
                            spacing: 0.0)
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Text(
                        data.review,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularImageWidget(30, data.profilePic),
                        SizedBox(
                          width: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.name,
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              S.of(context).asOn(dateformat.formatDate(
                                      data.createdAt, [
                                    dateformat.dd,
                                    '-',
                                    dateformat.M,
                                    '-',
                                    dateformat.yyyy
                                  ])),
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w200),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )),
        ));
  }
}
