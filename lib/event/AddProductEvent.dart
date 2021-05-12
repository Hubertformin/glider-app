import 'package:glider/event/BaseEvent.dart';
import 'package:glider/model/AddProductModel.dart';
import 'package:glider/model/MyProductModel.dart';

class AddProductEvent extends BaseEvent {
  final AddProductModel body;
  final MyProduct oldProduct;

  AddProductEvent(this.body, this.oldProduct);
}
