import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/bloc/ProductDetailsBloc.dart';
import 'package:glider/config/app_config.dart' as config;
import 'package:glider/core/InheritedStateContainer.dart';
import 'package:glider/core/glidertate.dart';
import 'package:glider/event/AllProductEvent.dart';
import 'package:glider/generated/l10n.dart';
import 'package:glider/model/home/HomeModel.dart';
import 'package:glider/state/AllProductState.dart';
import 'package:glider/state/BaseState.dart';
import 'package:glider/state/OtpState.dart';
import 'package:glider/util/Utils.dart';
import 'package:glider/widget/LikeWidget.dart';
import 'package:glider/widget/PlaceHolderWidget.dart';
import 'package:glider/widget/ProgressIndicatorWidget.dart';

class AllProductListScreen extends StatefulWidget {
  final SubCategory category;

  AllProductListScreen(this.category);

  @override
  State<StatefulWidget> createState() {
    return AllProductListScreenState();
  }
}

class AllProductListScreenState extends glidertate<AllProductListScreen> {
  ProductDetailsBloc mBloc = ProductDetailsBloc();

  List<FeaturedProductElement> searchItem = List();

  int page = 1;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      update();
    });
  }

  void openDetails(
      BuildContext context, FeaturedProductElement products) async {
    var map = Map();
    map["id"] = products.id;
    map["name"] = products.name;
    Navigator.of(context).pushNamed("/product_details", arguments: map);
  }

  Widget cardView(FeaturedProductElement item) {
    return InkWell(
        onTap: () {
          openDetails(context, item);
        },
        child: Card(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5)),
                    child: OptimizedCacheImage(
                        placeholder: (context, url) {
                          return PlaceHolderWidget();
                        },
                        fit: BoxFit.fill,
                        width: config.App(context).appWidth(100),
                        height: config.App(context).appHeight(36) * .60,
                        imageUrl: item.details.images != null
                            ? item.details.images
                            : "")),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                      LikeWidget(item.id, item.isLike)
                    ],
                  ),
                ),
                SizedBox(height: 5),
                for (var item in item.details.fileds)
                  Text(Utils.generateString(item)),
                Container(
                  margin: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        S.of(context).startings(item.details.price),
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                    ],
                  ),
                )
              ],
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
              create: (BuildContext context) => ProductDetailsBloc(),
              child: BlocBuilder<ProductDetailsBloc, BaseState>(
                  bloc: mBloc,
                  builder: (BuildContext context, BaseState state) {
                    if (state is LoadingState && searchItem.isEmpty) {
                      return ProgressIndicatorWidget();
                    } else if (state is AllProductState) {
                      searchItem.clear();
                      searchItem.addAll(state.home.data.product);
                    }
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return cardView(searchItem[index]);
                      },
                      itemCount: searchItem.length,
                    );
                  })),
          appBar: AppBar(
            title: Text(widget.category.subCategoryName),
          ),
        ));
  }

  @override
  void update() {
    mBloc.add(AllProductEvent(widget.category.subCategoryId, page));
  }
}
