import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:glider/bloc/CategoryListBloc.dart';
import 'package:glider/config/app_config.dart' as config;
import 'package:glider/event/CategoryListEvent.dart';
import 'package:glider/generated/l10n.dart';
import 'package:glider/model/category/CategoryList.dart';
import 'package:glider/state/BaseState.dart';
import 'package:glider/state/CategoryListState.dart';
import 'package:glider/widget/ProgressIndicatorWidget.dart';

class CategoryScreenWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CategoryScreenWidgetState();
  }
}

class CategoryScreenWidgetState extends State<CategoryScreenWidget> {
  Widget _acutionList(Category mCategory) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed("/category_detail", arguments: mCategory.id);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Container(
              color: mCategory.color,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  OptimizedCacheImage(
                    imageUrl: mCategory.categoryIcon,
                    width: 50,
                    height: 50,
                  ),
                  Text(
                    mCategory.name,
                    style: TextStyle(
                        color: config.Colors().scaffoldColor, fontSize: 16),
                  )
                ],
              ),
            )),
      ),
    );
  }

  CategoryListBloc mBloc = new CategoryListBloc();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      mBloc.add(CategoryListEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(S.of(context).category),
        ),
        body: BlocProvider(
            create: (BuildContext context) => CategoryListBloc(),
            child: BlocBuilder<CategoryListBloc, BaseState>(
                bloc: mBloc,
                builder: (BuildContext context, BaseState state) {
                  if (state is CategoryListState) {
                    return Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: GridView.builder(
                            itemCount: state.categoryList.data.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemBuilder: (BuildContext ctxt, int index) {
                              return _acutionList(
                                  state.categoryList.data[index]);
                            }));
                  } else {
                    return ProgressIndicatorWidget();
                  }
                })));
  }
}
