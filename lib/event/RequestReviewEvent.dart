import 'package:glider/event/BaseEvent.dart';

class RequestReviewEvent extends BaseEvent {
  final String productId;
  final String receiverUserId;

  RequestReviewEvent(this.receiverUserId, this.productId);
}
