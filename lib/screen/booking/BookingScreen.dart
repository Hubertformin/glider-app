import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glider/bloc/ProductDetailsBloc.dart';
import 'package:glider/generated/l10n.dart';
import 'package:glider/screen/booking/MyBookingScreen.dart';
import 'package:glider/screen/booking/MyProductBookingScreen.dart';
import 'package:glider/widget/CenterHorizontal.dart';

class BookingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new BookingScreenState();
  }
}

class BookingScreenState extends State<BookingScreen> {
  var mBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mBloc = ProductDetailsBloc();
  }

  Widget tabWiget() {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(tabs: [
              Tab(
                text: S.of(context).bookingPlaced,
              ),
              Tab(text: S.of(context).bookingReceived),
            ], indicatorWeight: 4.0),
            title: Text(S.of(context).booking),
          ),
          body: TabBarView(
            children: [
              MyBookingScreen(),
              MyProductBookingScreen(),
            ],
          ),
        ));
  }

  Widget progressIndicatorView() {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).booking),
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
    return tabWiget();
  }
}
