import 'package:flutter/cupertino.dart';
import 'package:glider/core/InheritedStateContainer.dart';

abstract class glidertate<T extends StatefulWidget> extends State<T> {
  static glidertate of(BuildContext context) {
    return (context
            .dependOnInheritedWidgetOfExactType<InheritedStateContainer>())
        .state;
  }

  void update();

  void updateView(item) {}
}
