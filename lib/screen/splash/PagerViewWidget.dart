import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glider/generated/l10n.dart';
import 'package:glider/screen/splash/Page1Widget.dart';
import 'package:glider/screen/splash/Page2Widget.dart';
import 'package:glider/screen/splash/Page3Widget.dart';
import 'package:glider/util/Utils.dart';

class PagerViewWidget extends StatelessWidget {
  final PageController _controller = PageController(
    initialPage: 0,
  );

  checkLogin(BuildContext context) async {
    Future.delayed(Duration(milliseconds: 500)).then((value) async {
      var user = await Utils.getUser();
      if (user != null) {
        Navigator.of(context).popAndPushNamed("/home");
      } else {
        Navigator.of(context).pushNamed("/otp");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // checkLogin(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            PageView(
              controller: _controller,
              children: [Page1Widget(), Page2Widget(), Page3Widget()],
            ),
            Positioned.fill(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed("/otp");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Text(
                            S.of(context).connectViaMobile,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          margin: EdgeInsets.only(left: 30, right: 30),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(5),
                          width: double.infinity,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                        child: Row(children: <Widget>[
                          Expanded(
                              child: Divider(
                            color: Colors.white,
                            thickness: 1.5,
                          )),
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Text(S.of(context).or,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          ),
                          Expanded(
                              child: Divider(
                            color: Colors.white,
                            thickness: 1.5,
                          )),
                        ]),
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed("/email");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Text(
                              S.of(context).connectViaEmail,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            margin: EdgeInsets.only(
                                left: 30, right: 30, top: 20, bottom: 20),
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(5),
                            width: double.infinity,
                          ))
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
