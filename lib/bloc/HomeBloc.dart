import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/event/BaseEvent.dart';
import 'package:glider/event/HomeEvent.dart';
import 'package:glider/repo/HomeRepo.dart' as homeRepo;
import 'package:glider/state/BaseState.dart';
import 'package:glider/state/ErrorState.dart';
import 'package:glider/state/HomeState.dart';
import 'package:glider/state/OtpState.dart';

class HomeBloc extends Bloc<BaseEvent, BaseState> {
  @override
  BaseState get initialState => LoadingState();

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is HomeEvent) {
      yield LoadingState();
      try {
        var response = await homeRepo.getHomeData();
        yield HomeState(response);
      } catch (exception) {
        yield ErrorState(exception.toString());
      }
    }
  }
}
