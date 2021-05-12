import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/event/BaseEvent.dart';
import 'package:glider/event/GetNotificationEvent.dart';
import 'package:glider/repo/NotificationRepo.dart';
import 'package:glider/state/BaseState.dart';
import 'package:glider/state/NotificationListState.dart';
import 'package:glider/state/OtpState.dart';

class NotificationBloc extends Bloc<BaseEvent, BaseState> {
  @override
  // TODO: implement initialState
  BaseState get initialState => LoadingState();

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is GetNotificationEvent) {
      yield LoadingState();
      var response = await getNotification();
      yield NotificationListState(response);
    }
  }
}
