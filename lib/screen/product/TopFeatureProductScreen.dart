import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:glider/config/app_config.dart' as config;
import 'package:glider/core/InheritedStateContainer.dart';
import 'package:glider/core/GliderState.dart';
import 'package:glider/generated/l10n.dart';
import 'package:glider/model/home/HomeModel.dart';
import 'package:glider/util/Utils.dart';
import 'package:glider/widget/LikeWidget.dart';
import 'package:glider/widget/PlaceHolderWidget.dart';

class TopFeatureProductScreen extends StatefulWidget {
  final List<FeaturedProductElement> featuredProducts;

  TopFeatureProductScreen(this.featuredProducts);

  @override
  State<StatefulWidget> createState() {
    return TopFeatureProductScreenState();
  }
}

class TopFeatureProductScreenState
    extends GliderState<TopFeatureProductScreen> {
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
          body: ListView.builder(
            itemBuilder: (context, index) {
              return cardView(widget.featuredProducts[index]);
            },
            itemCount: widget.featuredProducts.length,
          ),
          appBar: AppBar(
            title: Text(S.of(context).topFeatured),
          ),
        ));
  }

  @override
  void update() {}
}
