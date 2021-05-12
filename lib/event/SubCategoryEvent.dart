import 'package:glider/event/BaseEvent.dart';
import 'package:glider/model/category/CategoryList.dart';

class SubCategoryEvent extends BaseEvent {
  final Category category;

  SubCategoryEvent(this.category);
}
