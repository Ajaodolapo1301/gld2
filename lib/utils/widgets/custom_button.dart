import 'package:flutter/material.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final bool showArrow;
  final Color color;

  const CustomButton({
    Key key,
    @required this.text,
    this.onPressed,
    this.type = ButtonType.filled,
    this.showArrow = false,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (type == ButtonType.outlined) {
      return SizedBox(
        width: double.maxFinite,
        child: OutlineButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'DMSans',
              color: blue,
              fontSize: 16
            ),
          ),
          borderSide: BorderSide(color: cyan),
          padding: EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          highlightElevation: 0,
        ),
      );
    }
    return SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontFamily: 'DMSans',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (showArrow)
              Container(
                margin: EdgeInsets.only(left: 10),
                child: RotatedBox(
                  quarterTurns: 2,
                  child: Icon(
                    Icons.keyboard_backspace_rounded,
                  ),
                ),
              ),
          ],
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color ?? orange),
          padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(vertical: 18),
          ),
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ),
    );
  }
}

enum ButtonType { outlined, filled }
