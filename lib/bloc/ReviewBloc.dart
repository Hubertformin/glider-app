import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/event/AddReviewEvent.dart';
import 'package:glider/event/BaseEvent.dart';
import 'package:glider/event/RequestReviewEvent.dart';
import 'package:glider/repo/ReviewRepo.dart';
import 'package:glider/state/BaseState.dart';
import 'package:glider/state/DoneState.dart';
import 'package:glider/state/OtpState.dart';

class ReviewBloc extends Bloc<BaseEvent, BaseState> {
  @override
  // TODO: implement initialState
  BaseState get initialState => LoadingState();

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is AddReviewEvent) {
      yield LoadingState();
      var response =
          await addReview(event.productId, event.rating, event.comment);
      yield DoneState(response);
    } else if (event is RequestReviewEvent) {
      yield ProgressDialogState();
      var response = await requestReview(event.receiverUserId, event.productId);
      yield DoneState(response);
    }
  }
}
