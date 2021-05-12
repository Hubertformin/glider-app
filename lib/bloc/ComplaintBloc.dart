import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/event/BaseEvent.dart';
import 'package:glider/event/ComplaintEvent.dart';
import 'package:glider/repo/ComplaintRepo.dart';
import 'package:glider/state/BaseState.dart';
import 'package:glider/state/DoneState.dart';
import 'package:glider/state/OtpState.dart';

class ComplaintBloc extends Bloc<BaseEvent, BaseState> {
  @override
  // TODO: implement initialState
  BaseState get initialState => LoadingState();

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is ComplaintEvent) {
      yield ProgressDialogState();
      var response = await complaint(event.title, event.message);
      yield DoneState(response);
    }
  }
}
