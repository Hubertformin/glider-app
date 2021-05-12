import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:glider/bloc/BookingBloc.dart';
import 'package:glider/event/MyProductBookingEvent.dart';
import 'package:glider/generated/l10n.dart';
import 'package:glider/model/booking/MyProductBookingModel.dart';
import 'package:glider/model/home/HomeModel.dart';
import 'package:glider/state/BaseState.dart';
import 'package:glider/state/MyProductBookingState.dart';
import 'package:glider/util/Utils.dart';
import 'package:glider/widget/ProgressIndicatorWidget.dart';

class MyProductBookingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyProductBookingScreenState();
  }
}

class MyProductBookingScreenState extends State<MyProductBookingScreen>
    with AutomaticKeepAliveClientMixin<MyProductBookingScreen> {
  BookingBloc mBloc = new BookingBloc();
  TextEditingController reviewController = TextEditingController();
  double rating = 0;

  @override
  void initState() {
    super.initState();
    mBloc.add(MyProductBookingevent());
  }

  Widget bookingWidget(MyProductBooking data) {
    return InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed("/booking_request", arguments: data.productId);
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
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 5, right: 5, bottom: 5),
                          child: AspectRatio(
                            aspectRatio: 4 / 3,
                            child: Hero(
                                tag: data.bookingId,
                                child: OptimizedCacheImage(
                                  fit: BoxFit.fill,
                                  imageUrl: data.details.images,
                                )),
                          ),
                        ),
                      ],
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
                              data.productName,
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
                                    fontSize: 12, fontWeight: FontWeight.w800),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                data.address,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                Utils.getDateTIme(
                                    data.startDate, data.startTime),
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                Utils.getDateTIme(data.endDate, data.endTime),
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        )),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
        create: (BuildContext context) => BookingBloc(),
        child: BlocBuilder<BookingBloc, BaseState>(
            bloc: mBloc,
            builder: (BuildContext context, BaseState state) {
              if (state is MyProductBookingState) {
                var data = state.booking.data;
                return ListView.separated(
                    separatorBuilder: (ctx, index) {
                      return Divider();
                    },
                    itemCount: data.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return bookingWidget(data[index]);
                    });
              } else {
                return ProgressIndicatorWidget();
              }
            }));
  }

  @override
  bool get wantKeepAlive => true;
}
