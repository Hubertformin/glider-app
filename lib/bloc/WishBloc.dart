import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/event/BaseEvent.dart';
import 'package:glider/event/LikeEvent.dart';
import 'package:glider/event/UnLikeEvent.dart';
import 'package:glider/repo/WishListRepo.dart';
import 'package:glider/state/BaseState.dart';
import 'package:glider/state/DoneState.dart';
import 'package:glider/state/ErrorState.dart';
import 'package:glider/state/OtpState.dart';

class WishBloc extends Bloc<BaseEvent, BaseState> {
  @override
  // TODO: implement initialState
  BaseState get initialState => LoadingState();

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is LikeEvent) {
      yield ProgressDialogState();
      try {
        var response = await like(event.productId);
        yield DoneState(response);
      } catch (ex) {
        yield ErrorState(ex.toString());
      }
    } else if (event is UnLikeEvent) {
      yield ProgressDialogState();
      try {
        var response = await unlike(event.productId);
        yield DoneState(response);
      } catch (ex) {
        yield ErrorState(ex.toString());
      }
    }
  }
}
