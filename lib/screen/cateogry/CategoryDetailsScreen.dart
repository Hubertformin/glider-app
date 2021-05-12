import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:glider/bloc/CategoryListBloc.dart';
import 'package:glider/config/app_config.dart' as config;
import 'package:glider/event/CategoryDetailEvent.dart';
import 'package:glider/model/category/CategoryDetailModel.dart' as category;
import 'package:glider/model/category/ConsolidateCategoryDetail.dart';
import 'package:glider/model/home/Separator.dart';
import 'package:glider/state/BaseState.dart';
import 'package:glider/state/CategoryDetailState.dart';
import 'package:glider/widget/PlaceHolderWidget.dart';
import 'package:glider/widget/ProductViewWidget.dart';
import 'package:glider/widget/ProgressIndicatorWidget.dart';
import 'package:glider/widget/SeparatorWidget.dart';
import 'package:glider/widget/StartRentingItemWidget.dart';
import 'package:glider/widget/SubCategoryScreen.dart';

class CategoryDetailsScreen extends StatefulWidget {
  final String id;

  CategoryDetailsScreen(this.id);

  @override
  State<StatefulWidget> createState() {
    return CategoryDetailsScreenState();
  }
}

class CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  CategoryListBloc mBloc = new CategoryListBloc();

  var _current = 0;

  @override
  void initState() {
    super.initState();
    _current = 0;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      mBloc.add(CategoryDetailEvent(widget.id));
    });
  }

  Widget productList(ConsolidateCategoryDetail detail) {
    return ListView.builder(
      itemCount: detail.products.length + 1,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int i) {
        if (i == 0) {
          return subCategory(detail.subCategory);
        } else {
          int index = i - 1;
          var item = detail.products[index];
          if (item is Separator) {
            return SeparatorWidget(
              item.category,
              color: config.Colors().white,
            );
          } else {
            return productView(item);
          }
        }
      },
    );
  }

  Widget productView(category.Product subCategory) {
    return Container(
      color: config.Colors().white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            color: config.Colors().white,
            height: config.App(context).appHeight(35),
            child: ListView.builder(
                itemCount: subCategory.subcategoryProducts.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (BuildContext ctxt, int index) {
                  return ProductViewWidget(
                      subCategory.subcategoryProducts[index]);
                }),
          )
        ],
      ),
    );
  }

  Widget subCategory(List<category.SubCategory> detail) {
    return Container(
        margin: EdgeInsets.only(top: 10),
        height: config.App(context).appHeight(15),
        child: ListView.builder(
            itemCount: detail.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext ctxt, int index) {
              var map = Map<String, dynamic>();
              map["icon"] = detail[index].subcategoryIcon;
              map["name"] = detail[index].name;
              map["id"] = detail[index].id;
              return InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed("/subcategory_detail",
                        arguments: detail[index]);
                  },
                  child: SubCategoryWidget(map));
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: config.Colors().white),
          elevation: 0,
        ),
        body: BlocProvider(
            create: (BuildContext context) => CategoryListBloc(),
            child: BlocBuilder<CategoryListBloc, BaseState>(
                bloc: mBloc,
                builder: (BuildContext context, BaseState state) {
                  if (state is CategoryDetailState) {
                    var detail = state.categoryList;
                    return SingleChildScrollView(
                      child: Stack(
                        children: [
                          CarouselSlider.builder(
                              itemCount: detail.sliderImage.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: config.App(context).appWidth(100),
                                  child: OptimizedCacheImage(
                                    placeholder: (context, url) {
                                      return PlaceHolderWidget();
                                    },
                                    fit: BoxFit.fill,
                                    imageUrl: detail.sliderImage[index].image,
                                  ),
                                );
                              },
                              options: CarouselOptions(
                                  autoPlay: true,
                                  aspectRatio: 4 / 3,
                                  viewportFraction: 1.0,
                                  enlargeCenterPage: false,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _current = index;
                                    });
                                  })),
                          Container(
                              margin: EdgeInsets.only(
                                  top: config.App(context)
                                      .aspectRatioValue(16 / 8)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: detail.sliderImage.map((url) {
                                  int index = detail.sliderImage.indexOf(url);
                                  return Container(
                                    width: 8.0,
                                    height: 8.0,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 2.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _current == index
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).hintColor,
                                    ),
                                  );
                                }).toList(),
                              )),
                          Column(
                            children: [
                              SizedBox(
                                width: config.App(context).appWidth(100),
                                height:
                                    config.App(context).aspectRatioValue(3.2),
                              ),
                              productList(detail),
                              StartRentingItemWidget()
                            ],
                          )
                        ],
                      ),
                    );
                  } else {
                    return ProgressIndicatorWidget();
                  }
                })));
  }
}
