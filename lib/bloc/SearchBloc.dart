import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/event/BaseEvent.dart';
import 'package:glider/event/SearchEvent.dart';
import 'package:glider/repo/SearchRepo.dart';
import 'package:glider/state/BaseState.dart';
import 'package:glider/state/ErrorState.dart';
import 'package:glider/state/OtpState.dart';
import 'package:glider/state/SearchState.dart';

class SearchBloc extends Bloc<BaseEvent, BaseState> {
  @override
  // TODO: implement initialState
  BaseState get initialState => ProgressDialogState();

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is SearchEvent) {
      yield LoadingState();
      try {
        var response = await searchResult(event.search);
        yield SearchState(response);
      } catch (ex) {
        yield ErrorState(ex.toString());
      }
    }
  }
}
