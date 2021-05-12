import 'package:flutter/cupertino.dart';
import 'package:glider/core/InheritedStateContainer.dart';

abstract class GliderState<T extends StatefulWidget> extends State<T> {
  static GliderState of(BuildContext context) {
    return (context
            .dependOnInheritedWidgetOfExactType<InheritedStateContainer>())
        .state;
  }

  void update();

  void updateView(item) {}
}
