import 'package:glider/event/BaseEvent.dart';

class ForgotPasswordEvent extends BaseEvent {
  final String emailAddress;

  ForgotPasswordEvent(this.emailAddress);
}
