
import 'package:flutter/material.dart';

class RoundConnerBottomSheet extends StatelessWidget {
  final Widget child;
  final bool isDark;
  RoundConnerBottomSheet(this.child, {this.isDark = false});

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.transparent,
      child: new Container(
          decoration: new BoxDecoration(
            color: isDark ? Color(0xff121416) : Colors.white,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(0.0),
              topRight: const Radius.circular(0.0),
            ),
          ),
          child: child),
    );
  }
}