import 'package:glider/event/BaseEvent.dart';

class AllProductEvent extends BaseEvent {
  final String id;
  final int page;

  AllProductEvent(this.id, this.page);
}
