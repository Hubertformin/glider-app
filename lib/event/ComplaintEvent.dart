import 'package:glider/event/BaseEvent.dart';

class ComplaintEvent extends BaseEvent {
  final String title, message;

  ComplaintEvent(this.title, this.message);
}
