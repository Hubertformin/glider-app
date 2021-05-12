import 'package:glider/event/BaseEvent.dart';

class LikeEvent extends BaseEvent {
  final String productId;

  LikeEvent(this.productId);
}
