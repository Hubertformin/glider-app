import 'package:glider/model/Response.dart';

class ErrorResponse extends Response {
  ErrorResponse(int status, String message) : super(status, message);
}
