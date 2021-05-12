import 'package:flutter/material.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:glider/config/app_config.dart' as config;

class SubCategoryWidget extends StatelessWidget {
  final Map item;

  SubCategoryWidget(this.item);

  Widget _acutionList(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            color: config.Colors().orangeColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OptimizedCacheImage(
                  imageUrl: item["icon"],
                  width: 30,
                  height: 30,
                ),
                Text(
                  item["name"],
                  style: TextStyle(
                      color: config.Colors().scaffoldColor, fontSize: 14),
                )
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _acutionList(context),
      width: config.App(context).appWidth(35),
    );
  }
}
