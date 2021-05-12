import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/event/AddBookingEvent.dart';
import 'package:glider/event/BaseEvent.dart';
import 'package:glider/event/CityEvent.dart';
import 'package:glider/event/UploadPhotoEvent.dart';
import 'package:glider/repo/BookingRepo.dart';
import 'package:glider/state/BaseState.dart';
import 'package:glider/state/CityState.dart';
import 'package:glider/state/DoneState.dart';
import 'package:glider/state/OtpState.dart';
import 'package:glider/state/UploadPhotoDoneState.dart';

class BookingProductBloc extends Bloc<BaseEvent, BaseState> {
  @override
  // TODO: implement initialState
  BaseState get initialState => LoadingState();
  bool isUploading = false;

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is CityEvent) {
      yield LoadingState();
      var response = await getCity();
      yield CityState(response);
    } else if (event is UploadPhotoEvent) {
      print("isUploding $isUploading");
      yield ProgressDialogState();
      try {
        var response = await uploadPhoto(event.file);
        yield UploadPhotoDoneState(response, event.typeEnum);
      } catch (ex) {}
      isUploading = false;
    } else if (event is AddBookingEvent) {
      yield ProgressDialogState();
      var response = await addBookingProduct(event.body);
      yield DoneState(response);
    }
  }
}
