import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glider/bloc/LoginBloc.dart';
import 'package:glider/config/app_config.dart' as config;
import 'package:glider/event/ForgotPasswordEvent.dart';
import 'package:glider/generated/l10n.dart';
import 'package:glider/state/DoneState.dart';
import 'package:glider/state/OtpState.dart';
import 'package:glider/widget/ProgressDialog.dart';
import 'package:glider/widget/GliderRaisedButton.dart';
import 'package:glider/widget/RoundedFloatingField.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ForgotPasswordScreenState();
  }
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  LoginBloc mBloc = LoginBloc();
  TextEditingController emailController = new TextEditingController();

  ProgressDialog dialog;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mBloc.listen((state) {
      if (state is ProgressDialogState) {
        dialog = ProgressDialog(context, isDismissible: true);
        dialog.show();
      } else {
        if (dialog != null && dialog.isShowing()) {
          dialog.hide();
        }
        if (state is DoneState) {
          Fluttertoast.showToast(msg: state.home.message);
          // Navigator.of(context).pop();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(S.of(context).forgot),
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              child: Image.asset("assets/img/splash/signin_background.jpeg",
                  fit: BoxFit.fill,
                  width: config.App(context).appWidth(100),
                  height: config.App(context).appHeight(100)),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: RoundedFloatingField(
                      controller: emailController,
                      hint: S.of(context).enterYourEmail,
                      label: S.of(context).enterYourEmail,
                      inputType: TextInputType.emailAddress,
                      readOnly: false,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 10),
                    child: GliderRaisedButton(
                      child: Text(
                        S.of(context).submit,
                        style: TextStyle(
                            color: Theme.of(context).scaffoldBackgroundColor),
                      ),
                      onPressed: () {
                        validate(context);
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }

  void validate(BuildContext context) {
    var email = emailController.text.trim().toString();
    if (EmailValidator.validate(email)) {
      mBloc.add(ForgotPasswordEvent(email));
    } else {
      Fluttertoast.showToast(msg: S.of(context).enterValidEmailAddress);
    }
  }
}
