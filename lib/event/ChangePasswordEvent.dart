import 'package:glider/event/BaseEvent.dart';

class ChangePasswordEvent extends BaseEvent {
  final String newPassword;

  ChangePasswordEvent(this.newPassword);
}
