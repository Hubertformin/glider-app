import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/event/BaseEvent.dart';
import 'package:glider/event/FeatureSubscriptionListEvent.dart';
import 'package:glider/repo/SubscriptionRepo.dart';
import 'package:glider/state/BaseState.dart';
import 'package:glider/state/FeatureSubcriptionListState.dart';
import 'package:glider/state/OtpState.dart';

class FeatureBloc extends Bloc<BaseEvent, BaseState> {
  @override
  // TODO: implement initialState
  BaseState get initialState => LoadingState();

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is FeatureSubscriptionListEvent) {
      yield ProgressDialogState();
      var response = await getFeatureSubscriptionList();
      yield FeatureSubscriptionListState(response);
    }
  }
}
