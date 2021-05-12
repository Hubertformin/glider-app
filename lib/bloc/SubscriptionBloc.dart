import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/event/BaseEvent.dart';
import 'package:glider/event/SubscriptionListEvent.dart';
import 'package:glider/repo/SubscriptionRepo.dart';
import 'package:glider/state/BaseState.dart';
import 'package:glider/state/ErrorState.dart';
import 'package:glider/state/OtpState.dart';
import 'package:glider/state/SubscriptionListState.dart';

class SubscriptionBloc extends Bloc<BaseEvent, BaseState> {
  @override
  // TODO: implement initialState
  BaseState get initialState => LoadingState();

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is SubscriptionListEvent) {
      yield LoadingState();
      try {
        var response = await getSubscriptionList();
        yield SubscriptionListState(response);
      } catch (ex) {
        yield ErrorState(ex.toString());
      }
    }
  }
}
