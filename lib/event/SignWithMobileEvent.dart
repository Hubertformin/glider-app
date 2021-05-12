import 'package:glider/event/BaseEvent.dart';

class SignWithMobileEvent extends BaseEvent {
  final String mobileNumber;
  final String countryCode;
  final String token;

  SignWithMobileEvent(this.mobileNumber, this.countryCode, this.token);
}
