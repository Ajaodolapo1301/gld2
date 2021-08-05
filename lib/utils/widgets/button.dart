

import 'package:flutter/material.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';

class Button extends StatelessWidget {
  Button({
    @required this.onPressed,
    this.text,
    this.widthFactor,
    this.disable,
    this.color = cyan,
    this.expand = true,
    this.isOutlined = false, this.disableColor,
  });

  final GestureTapCallback onPressed;
  final String text;
  final double widthFactor;
  final bool disable;
  final bool expand;
  final bool isOutlined;
  final Color color;
  final Color disableColor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: ButtonTheme(
        child: IgnorePointer(
          ignoring: disable == null ? false : disable,
          child: SizedBox(
            width: expand ? double.maxFinite : 100,
            child: isOutlined
                ? OutlineButton(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                text == null ? "" : text,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              onPressed: onPressed,
            )
                : FlatButton(
              padding: EdgeInsets.symmetric(vertical: 12),
              color: disable == null
                  ? color
                  : disable ? Color(0xff191D20) : color,
              disabledColor: disableColor ??  Colors.grey,
              child: Text(
                text == null ? "" : text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              onPressed: onPressed,
            ),
          ),
        ),
      ),
    );
  }
}