import 'package:glider/event/BaseEvent.dart';

class UserSubscriptionEvent extends BaseEvent {
  final String subscriptionid;
  final String details;

  UserSubscriptionEvent(this.subscriptionid, this.details);
}
