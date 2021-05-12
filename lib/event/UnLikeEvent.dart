import 'package:glider/event/BaseEvent.dart';

class UnLikeEvent extends BaseEvent {
  final String productId;

  UnLikeEvent(this.productId);
}
