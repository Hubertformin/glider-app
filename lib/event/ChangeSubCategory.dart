import 'package:glider/event/BaseEvent.dart';
import 'package:glider/model/DropDownItem.dart';

class ChangeSubCategory extends BaseEvent {
  final DropDownItem category;

  ChangeSubCategory(this.category);
}
