import 'package:flutter/material.dart';
import 'package:glider/core/GliderState.dart';

class InheritedStateContainer extends InheritedWidget {
  // Data is your entire state. In our case just 'User'
  final GliderState state;

  // You must pass through a child and your state.
  InheritedStateContainer({
    Key key,
    @required this.state,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedStateContainer old) => true;
}
