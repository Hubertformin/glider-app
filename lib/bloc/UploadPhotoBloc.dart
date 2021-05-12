import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/event/BaseEvent.dart';
import 'package:glider/event/UploadPhotoEvent.dart';
import 'package:glider/repo/BookingRepo.dart';
import 'package:glider/state/BaseState.dart';
import 'package:glider/state/OtpState.dart';
import 'package:glider/state/UploadPhotoDoneState.dart';

class UploadPhotoBloc extends Bloc<BaseEvent, BaseState> {
  @override
  // TODO: implement initialState
  BaseState get initialState => LoadingState();

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is UploadPhotoEvent) {
      yield ProgressDialogState();
      try {
        var response = await uploadPhoto(event.file);
        yield UploadPhotoDoneState(response, event.typeEnum);
      } catch (ex) {}
    }
  }
}
