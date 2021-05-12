import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/event/BaseEvent.dart';
import 'package:glider/event/ChangePasswordEvent.dart';
import 'package:glider/repo/ChangePasswordRepo.dart';
import 'package:glider/state/BaseState.dart';
import 'package:glider/state/DoneState.dart';
import 'package:glider/state/OtpState.dart';

class ChangePasswordBloc extends Bloc<BaseEvent, BaseState> {
  @override
  // TODO: implement initialState
  BaseState get initialState => LoadingState();

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is ChangePasswordEvent) {
      yield ProgressDialogState();
      var response = await changePassword(event.newPassword);
      yield DoneState(response);
    }
  }
}
