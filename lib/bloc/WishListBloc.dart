import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/event/BaseEvent.dart';
import 'package:glider/event/WishListEvent.dart';
import 'package:glider/repo/WishListRepo.dart';
import 'package:glider/state/BaseState.dart';
import 'package:glider/state/ErrorState.dart';
import 'package:glider/state/OtpState.dart';
import 'package:glider/state/WishListState.dart';

class WishListBloc extends Bloc<BaseEvent, BaseState> {
  @override
  // TODO: implement initialState
  BaseState get initialState => LoadingState();

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is WishListEvent) {
      try {
        yield LoadingState();
        var response = await getWishList();
        yield WishListState(response);
      } catch (exception) {
        yield ErrorState(exception.toString());
      }
    }
  }
}
