import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:glider/bloc/MyProductBloc.dart';
import 'package:glider/config/app_config.dart' as config;
import 'package:glider/event/ChangeProductStatusEvent.dart';
import 'package:glider/event/DeleteProductEvent.dart';
import 'package:glider/event/GetMyProductEvent.dart';
import 'package:glider/generated/l10n.dart';
import 'package:glider/model/MyProductModel.dart';
import 'package:glider/model/home/HomeModel.dart';
import 'package:glider/state/BaseState.dart';
import 'package:glider/state/DoneState.dart';
import 'package:glider/state/MyProductState.dart';
import 'package:glider/state/OtpState.dart';
import 'package:glider/util/FeaturePaymentManager.dart';
import 'package:glider/util/Utils.dart';
import 'package:glider/widget/EmptyWidget.dart';
import 'package:glider/widget/FeatureWidget.dart';
import 'package:glider/widget/PlaceHolderWidget.dart';
import 'package:glider/widget/ProgressDialog.dart';
import 'package:glider/widget/ProgressIndicatorWidget.dart';

class MyProductListingScreen extends StatefulWidget {
  MyProductListingScreen();

  @override
  State<StatefulWidget> createState() {
    return MyProductListingScreenState();
  }
}

class MyProductListingScreenState extends State<MyProductListingScreen> {
  MyProductBloc mBloc = MyProductBloc();

  List<MyProduct> searchItem = List();

  int page = 1;

  ProgressDialog dialog;
  FeaturePaymentManager _featurePaymentManager;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      mBloc.add(GetMyProductEvent());
    });
    mBloc.listen((state) {
      if (state is ProgressDialogState) {
        dialog = ProgressDialog(context, isDismissible: true);
        dialog.show();
      } else {
        if (dialog != null && dialog.isShowing()) {
          dialog.hide();
        }
        if (state is DoneState) {
          mBloc.add(GetMyProductEvent());
        }
      }
    });
  }

  void openDetails(BuildContext context, MyProduct products) async {
    var map = Map();
    map["id"] = products.id;
    map["name"] = products.name;
    Navigator.of(context)
        .pushNamed("/product_details", arguments: map)
        .then((value) {
      mBloc.add(GetMyProductEvent());
    });
  }

  Widget publishWidget() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 10, bottom: 5, top: 5, right: 10),
      decoration: BoxDecoration(
          color: config.Colors().color1ABE5B,
          borderRadius: BorderRadius.circular(5)),
      child: Text(
        S.of(context).publish,
        style: TextStyle(
            color: config.Colors().white,
            fontSize: 13,
            fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget unpPublishWidget() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 10, bottom: 5, top: 5, right: 10),
      decoration: BoxDecoration(
        color: config.Colors().colorFE2B2B,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        S.of(context).unpublished,
        style: TextStyle(
            color: config.Colors().white,
            fontSize: 13,
            fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget addToFeature(MyProduct product) {
    Color containerColor = isActive(product)
        ? config.Colors().colorF25633
        : config.Colors().colorEBEBEB;
    Color textColor = isActive(product)
        ? config.Colors().white
        : config.Colors().statusGrayColor;
    return InkWell(
      onTap: () {
        if (isActive(product)) {
          _featurePaymentManager = FeaturePaymentManager(
              context, product.name, product.details.images, product.id);
          _featurePaymentManager.requestBloc();
        }
      },
      child: Container(
        padding: EdgeInsets.only(left: 10, bottom: 5, top: 5, right: 10),
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
                  color: textColor, fontSize: 13, fontWeight: FontWeight.w800),
            )
          ],
        ),
      ),
    );
  }

  Widget cardView(MyProduct product) {
    return InkWell(
        onTap: () {
          openDetails(context, product);
        },
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 4,
                      child: Text(
                        product.name,
                        style: TextStyle(
                            fontSize: 16,
                            color: config.Colors().color545454,
                            fontWeight: FontWeight.w800),
                      )),
                  Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              openDeleteDialog(product.id);
                            },
                            child: Icon(
                              Icons.delete,
                              color: config.Colors().colorFE2B2B,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5, right: 5),
                            child: InkWell(
                              onTap: () {
                                editProduct(product);
                              },
                              child: Icon(
                                Icons.edit,
                                color: config.Colors().colorF25321,
                              ),
                            ),
                          )
                        ],
                      ))
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Stack(children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: OptimizedCacheImage(
                              placeholder: (context, url) {
                                return PlaceHolderWidget();
                              },
                              fit: BoxFit.fill,
                              imageUrl: product.details.images),
                        ),
                        FeatureWidget(
                          product.isFeatured,
                          radius: 0,
                        )
                      ]),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).dollar(product.details.price +
                                  "/" +
                                  priceUnitValues
                                      .reverse[product.details.priceUnit]),
                              style: TextStyle(
                                  color: config.Colors().color545454,
                                  fontWeight: FontWeight.w800),
                            ),
                            Text(
                              Utils.generateStringV2(product.details.fileds),
                              maxLines: 1,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Expanded(flex: 2, child: productState(product)),
                      Expanded(
                        flex: 3,
                        child: Container(
                          margin: EdgeInsets.only(left: 3, right: 3),
                          child: addToFeature(product),
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              status(product),
                            ],
                          ))
                    ],
                  ))
            ],
          ),
        ));
  }

  void openCreateProduct() async {
    Navigator.of(context).pushNamed("/create_product").then((value) {
      mBloc.add(GetMyProductEvent());
    });
  }

  Widget productState(MyProduct product) {
    if (product.isApproved == "1") {
      if (product.status == "2") {
        return InkWell(
          child: publishWidget(),
          onTap: () {
            mBloc.add(ChangeProductStatusEvent(product.id, "1"));
          },
        );
      } else {
        return InkWell(
          child: unpPublishWidget(),
          onTap: () {
            mBloc.add(ChangeProductStatusEvent(product.id, "2"));
          },
        );
      }
    }

    return publishWidget();
  }

  bool isActive(MyProduct product) {
    return product.isApproved == "1" && product.status == "1";
  }

  bool isOffline(MyProduct product) {
    return product.isApproved == "1" && product.status != "1";
  }

  Widget status(MyProduct product) {
    Color color;
    String statusText = S.of(context).pending;

    if (isActive(product)) {
      color = config.Colors().color33D243;
      statusText = S.of(context).live;
    } else if (isOffline(product)) {
      statusText = S.of(context).offline;
      color = config.Colors().colorFE2B2B;
    } else {
      statusText = S.of(context).pending;
      color = config.Colors().colorFFA200;
    }

    return Container(
      padding: EdgeInsets.only(left: 10, bottom: 5, top: 5, right: 10),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
      child: Text(
        statusText,
        style: TextStyle(
            color: config.Colors().white,
            fontSize: 13,
            fontWeight: FontWeight.w800),
      ),
    );
  }

  void editProduct(MyProduct product) {
    Navigator.of(context)
        .pushNamed("/create_product", arguments: product)
        .then((value) {
      mBloc.add(GetMyProductEvent());
    });
  }

  void openDeleteDialog(String productId) {
    Widget cancelButton = FlatButton(
      child: Text(
        S.of(context).cancel,
        style: TextStyle(color: config.Colors().orangeColor),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text(S.of(context).yes,
          style: TextStyle(color: config.Colors().orangeColor)),
      onPressed: () {
        mBloc.add(DeleteProductEvent(productId));
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(S.of(context).areYouSureYouWantToDeleteThisProduct),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
      ),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            openCreateProduct();
          },
          child: Icon(Icons.add),
        ),
        body: BlocProvider(
            create: (BuildContext context) => MyProductBloc(),
            child: BlocBuilder<MyProductBloc, BaseState>(
                bloc: mBloc,
                builder: (BuildContext context, BaseState state) {
                  if (state is LoadingState && searchItem.isEmpty) {
                    return ProgressIndicatorWidget();
                  } else if (state is MyProductState) {
                    if (state.productModel.data == null) {
                      return EmptyWidget();
                    }
                    searchItem.clear();
                    searchItem.addAll(state.productModel.data);
                  }
                  return ListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemBuilder: (context, index) {
                      return cardView(searchItem[index]);
                    },
                    itemCount: searchItem.length,
                  );
                })),
        appBar: AppBar(
          elevation: 0,
          title: Text(S.of(context).myProduct),
        ),
      ),
    );
  }
}
