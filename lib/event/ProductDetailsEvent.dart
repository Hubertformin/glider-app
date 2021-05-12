import 'package:glider/event/BaseEvent.dart';

class ProductDetailsEvent extends BaseEvent {
  final String id;

  ProductDetailsEvent(this.id);
}
