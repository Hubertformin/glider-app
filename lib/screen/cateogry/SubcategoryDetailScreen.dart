import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:glider/bloc/CategoryListBloc.dart';
import 'package:glider/config/app_config.dart' as config;
import 'package:glider/event/SubCategoryDetailEvent.dart';
import 'package:glider/generated/l10n.dart';
import 'package:glider/model/category/CategoryDetailModel.dart' as category;
import 'package:glider/model/home/HomeModel.dart';
import 'package:glider/state/BaseState.dart';
import 'package:glider/state/SubCategoryDetailState.dart';
import 'package:glider/util/Utils.dart';
import 'package:glider/widget/PlaceHolderWidget.dart';
import 'package:glider/widget/ProductViewWidget.dart';
import 'package:glider/widget/ProgressIndicatorWidget.dart';

class SubcategoryDetailScreen extends StatefulWidget {
  final category.SubCategory subCategory;

  SubcategoryDetailScreen(this.subCategory);

  @override
  State<StatefulWidget> createState() {
    return SubcategoryDetailScreenState();
  }
}

class SubcategoryDetailScreenState extends State<SubcategoryDetailScreen> {
  CategoryListBloc mBloc = new CategoryListBloc();

  int _page = 1;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _page = 1;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      mBloc.add(SubCategoryDetailEvent(widget.subCategory.id, _page));
    });
  }

  Widget _recommendProduct(List<FeaturedProductElement> featuredProducts) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Card(
        elevation: 5,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Text(
                      S.of(context).recommendedForYou,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: config.Colors().color545454),
                    ),
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.of(context).pushNamed("/top_featured",
                  //         arguments: featuredProducts);
                  //   },
                  //   child: Container(
                  //     padding: EdgeInsets.only(
                  //         left: 10, right: 10, top: 2, bottom: 2),
                  //     margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                  //     child: Text(
                  //       S.of(context).viewAll,
                  //       style: TextStyle(
                  //           color: config.Colors().yellow, fontSize: 14),
                  //     ),
                  //   ),
                  // )
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                height: config.App(context).appHeight(35),
                child: ListView.builder(
                    itemCount: featuredProducts.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return ProductViewWidget(featuredProducts[index]);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget productView(FeaturedProductElement item) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: productWidget(item),
    );
  }

  Widget productWidget(FeaturedProductElement data) {
    return InkWell(
        onTap: () {
          Utils.openDetails(context, data);
        },
        child: Container(
          margin: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.only(top: 5, right: 5, bottom: 5),
                      child: AspectRatio(
                        aspectRatio: 4 / 3,
                        child: OptimizedCacheImage(
                          placeholder: (context, url) {
                            return PlaceHolderWidget();
                          },
                          fit: BoxFit.fill,
                          imageUrl: data.details.images,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                        margin: EdgeInsets.only(top: 5, right: 5, bottom: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.details.productName,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w800),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                S.of(context).dollar(data.details.price) +
                                    "/" +
                                    priceUnitValues
                                        .reverse[data.details.priceUnit],
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w800),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                Utils.generateStringV2(data.details.fileds),
                                maxLines: 2,
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                          ],
                        )),
                  )
                ],
              )
            ],
          ),
        ));
  }

  Widget _nearProduct(List<FeaturedProductElement> featuredProducts) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Card(
        elevation: 5,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Text(
                      S.of(context).nearYou,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: config.Colors().color545454),
                    ),
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.of(context).pushNamed("/top_featured",
                  //         arguments: featuredProducts);
                  //   },
                  //   child: Container(
                  //     padding: EdgeInsets.only(
                  //         left: 10, right: 10, top: 2, bottom: 2),
                  //     margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                  //     child: Text(
                  //       S.of(context).viewAll,
                  //       style: TextStyle(
                  //           color: config.Colors().yellow, fontSize: 14),
                  //     ),
                  //   ),
                  // )
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                height: config.App(context).appHeight(35),
                child: ListView.builder(
                    itemCount: featuredProducts.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return ProductViewWidget(featuredProducts[index]);
                    }),
              )
            ],
          ),
        ),
      ),
    );
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
                  if (state is SubCategoryDetailState) {
                    var detail = state.categoryList;
                    return CustomScrollView(slivers: [
                      SliverToBoxAdapter(
                        child: Stack(
                          children: [
                            CarouselSlider.builder(
                                itemCount:
                                    widget.subCategory.sliderImage.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: config.App(context).appWidth(100),
                                    child: OptimizedCacheImage(
                                      fit: BoxFit.fill,
                                      imageUrl: widget
                                          .subCategory.sliderImage[index].image,
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
                                        .aspectRatioValue(16 / 10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children:
                                      widget.subCategory.sliderImage.map((url) {
                                    int index = widget.subCategory.sliderImage
                                        .indexOf(url);
                                    return Container(
                                      width: 10.0,
                                      height: 10.0,
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
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child:
                            _recommendProduct(detail.data.recommendedProduct),
                      ),
                      SliverToBoxAdapter(
                        child: _nearProduct(detail.data.nearProduct),
                      ),
                      SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                        var item = detail.data.product[index];

                        return productView(item);
                      }, childCount: detail.data.product.length)),
                    ]);
                  } else {
                    return ProgressIndicatorWidget();
                  }
                })));
  }
}
