import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:rentors/bloc/SearchBloc.dart';
import 'package:rentors/config/app_config.dart' as config;
import 'package:rentors/core/InheritedStateContainer.dart';
import 'package:rentors/core/RentorState.dart';
import 'package:rentors/event/SearchEvent.dart';
import 'package:rentors/generated/l10n.dart';
import 'package:rentors/model/SearchModel.dart';
import 'package:rentors/state/BaseState.dart';
import 'package:rentors/state/ErrorState.dart';
import 'package:rentors/state/OtpState.dart';
import 'package:rentors/state/SearchState.dart';
import 'package:rentors/util/Utils.dart';
import 'package:rentors/widget/LikeWidget.dart';
import 'package:rentors/widget/PlaceHolderWidget.dart';
import 'package:rxdart/rxdart.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchScreenState();
  }
}

class SearchScreenState extends RentorState<SearchScreen> {
  SearchBloc mBloc;

  List<SearchItem> searchItem = List();

  bool showProgress = false;
  final searchOnChange = new BehaviorSubject<String>();

  @override
  void initState() {
    super.initState();
    searchOnChange
        .debounceTime(Duration(milliseconds: 500))
        .listen((queryString) {
      mBloc.add(SearchEvent(queryString));
    });
    showProgress = false;
    mBloc = SearchBloc();
    mBloc.listen((state) {
      if (state is SearchState || state is ErrorState) {
        setState(() {
          showProgress = false;
        });
      } else if (state is LoadingState) {
        setState(() {
          showProgress = true;
        });
      }
    });
  }

  void openDetails(BuildContext context, SearchItem products) async {
    var map = Map();
    map["id"] = products.id;
    map["name"] = products.name;
    Navigator.of(context).pushNamed("/product_details", arguments: map);
  }

  Widget cardView(SearchItem item) {
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
                      LikeWidget(item.id, "0")
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
    return Scaffold(
      body: InheritedStateContainer(
          state: this,
          child: BlocProvider(
              create: (BuildContext context) => mBloc,
              child: BlocBuilder<SearchBloc, BaseState>(
                  bloc: mBloc,
                  builder: (BuildContext context, BaseState state) {
                    if (state is SearchState) {
                      searchItem.clear();
                      searchItem.addAll(state.model.data);
                    } else if (state is ErrorState) {
                      searchItem.clear();
                    }
                    return Hero(
                      tag: "home_screen_search_key",
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return cardView(searchItem[index]);
                        },
                        itemCount: searchItem.length,
                      ),
                    );
                  }))),
      appBar: AppBar(
        bottom: PreferredSize(
            preferredSize: Size(double.infinity, 1.0),
            child: showProgress ? LinearProgressIndicator() : Container()),
        title: TextField(
            onChanged: (text) {
              searchOnChange.add(text);
            },
            autofocus: true,
            style: TextStyle(color: Colors.black, fontSize: 16),
            decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: S
                    .of(context)
                    .search,
                hintStyle: TextStyle(color: Colors.white))),
      ),
    );
  }

  @override
  void update() {}
}
