import 'package:glider/event/BaseEvent.dart';

class ChangeProductStatusEvent extends BaseEvent {
  final String status;
  final String id;

  ChangeProductStatusEvent(this.id, this.status);
}
