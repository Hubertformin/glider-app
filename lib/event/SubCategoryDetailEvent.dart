import 'package:glider/event/BaseEvent.dart';

class SubCategoryDetailEvent extends BaseEvent {
  final String id;
  final int page;

  SubCategoryDetailEvent(this.id, this.page);
}
