import 'package:rentors/event/BaseEvent.dart';

class SearchEvent extends BaseEvent {
  final String search;

  SearchEvent(this.search);
}
