import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/event/BaseEvent.dart';
import 'package:glider/event/ForgotPasswordEvent.dart';
import 'package:glider/event/SendEmaiEvent.dart';
import 'package:glider/event/SignWithEmailEvent.dart';
import 'package:glider/event/SignupEvent.dart';
import 'package:glider/repo/LoginRepo.dart' as homeRepo;
import 'package:glider/state/BaseState.dart';
import 'package:glider/state/DoneState.dart';
import 'package:glider/state/EmailSentState.dart';
import 'package:glider/state/OtpState.dart';
import 'package:glider/state/SignInWithEmailState.dart';

class LoginBloc extends Bloc<BaseEvent, BaseState> {
  @override
  // TODO: implement initialState
  BaseState get initialState => LoadingState();

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is SignWithEmailEvent) {
      yield ProgressDialogState();
      var response = await homeRepo.signWithEmail(
          event.email, event.password, event.token);
      yield SignInWithEmailState(response);
    } else if (event is ForgotPasswordEvent) {
      yield ProgressDialogState();
      var response = await homeRepo.forgotPassword(event.emailAddress);
      yield DoneState(response);
    } else if (event is SendEmaiEvent) {
      yield ProgressDialogState();
      var response =
          await homeRepo.sendEmail(event.email, event.subject, event.msg);
      yield EmailSentState(response);
    }
    if (event is SignupEvent) {
      yield ProgressDialogState();
      var response = await homeRepo.signupEvent(
          event.email, event.password, event.name, event.type);
      yield SignInWithEmailState(response);
    }
  }
}
