import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/event/BaseEvent.dart';
import 'package:glider/event/BookingStatusEvent.dart';
import 'package:glider/event/MyBookingEvent.dart';
import 'package:glider/event/MyBookingRequestEvent.dart';
import 'package:glider/event/MyProductBookingEvent.dart';
import 'package:glider/repo/BookingRepo.dart';
import 'package:glider/state/BaseState.dart';
import 'package:glider/state/DoneState.dart';
import 'package:glider/state/MyBookingState.dart';
import 'package:glider/state/MyProductBookingState.dart';
import 'package:glider/state/OtpState.dart';

class BookingBloc extends Bloc<BaseEvent, BaseState> {
  @override
  // TODO: implement initialState
  BaseState get initialState => LoadingState();

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is MyBookingEvent) {
      yield LoadingState();
      var response = await getBookingRepo();
      yield MyBookingState(response);
    } else if (event is MyProductBookingevent) {
      yield LoadingState();
      var response = await getMyProductBooking();
      yield MyProductBookingState(response);
    } else if (event is MyBookingRequestEvent) {
      yield LoadingState();
      var response = await getBookingRequestList(event.id);
      yield MyBookingState(response);
    } else if (event is BookingStatusEvent) {
      yield ProgressDialogState();
      var response = await changeBookingStatus(
          event.productId, event.buyerId, event.status);
      yield DoneState(response);
    }
  }
}
