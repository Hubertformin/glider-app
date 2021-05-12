import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/bloc/ProductDetailsBloc.dart';
import 'package:glider/config/app_config.dart' as config;
import 'package:glider/core/InheritedStateContainer.dart';
import 'package:glider/core/glidertate.dart';
import 'package:glider/event/ProductDetailsEvent.dart';
import 'package:glider/generated/l10n.dart';
import 'package:glider/model/productdetail/ProductDetailModel.dart';
import 'package:glider/screen/product/ProductOverViewWidget.dart';
import 'package:glider/screen/product/ProductOwnerWidget.dart';
import 'package:glider/state/BaseState.dart';
import 'package:glider/state/OtpState.dart';
import 'package:glider/state/ProductDetailsState.dart';
import 'package:glider/widget/CenterHorizontal.dart';

class ProductDetailsWidget extends StatefulWidget {
  final String name;
  final String id;

  ProductDetailsWidget(this.name, this.id);

  @override
  State<StatefulWidget> createState() {
    return new ProductDetailsWidgetState();
  }
}

class ProductDetailsWidgetState extends glidertate<ProductDetailsWidget> {
  ProductDetailsBloc mBloc = ProductDetailsBloc();

  ProductDetailModel response;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      update();
    });
  }

  Widget tabWiget(ProductDetailModel mModel) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.dark,
            iconTheme: IconThemeData(color: config.Colors().white),
            backgroundColor: config.Colors().color1C1E28,
            bottom: TabBar(tabs: [
              Tab(
                child: Text(S.of(context).overview,
                    style: TextStyle(color: config.Colors().white)),
              ),
              Tab(
                child: Text(S.of(context).owner,
                    style: TextStyle(color: config.Colors().white)),
              ),
            ]),
            title: Text(
              widget.name,
              style: TextStyle(color: config.Colors().white),
            ),
          ),
          body: TabBarView(
            children: [
              ProductOverViewWidget(mModel),
              ProductOwnerWidget(mModel)
            ],
          ),
        ));
  }

  Widget progressIndicatorView() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [CenterHorizontal(CircularProgressIndicator())],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InheritedStateContainer(
        state: this,
        child: BlocProvider(
            create: (BuildContext context) => ProductDetailsBloc(),
            child: BlocBuilder<ProductDetailsBloc, BaseState>(
                bloc: mBloc,
                builder: (BuildContext context, BaseState state) {
                  if (state is LoadingState && response == null) {
                    return progressIndicatorView();
                  } else if (state is ProductDetailsState) {
                    response = state.model;
                  }
                  return tabWiget(response);
                })));
  }

  @override
  void update() {
    mBloc.add(ProductDetailsEvent(widget.id));
  }
}
