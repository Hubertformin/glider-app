import 'package:glider/event/BaseEvent.dart';

class CategoryDetailEvent extends BaseEvent {
  final String id;

  CategoryDetailEvent(this.id);
}
