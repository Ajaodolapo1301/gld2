import 'package:flutter/material.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';

class Header extends StatelessWidget {
  final String text;
  final VoidCallback preferredActionOnBackPressed;

  const Header({
    Key key,
    this.text,
    this.preferredActionOnBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 18,
            color: blue,
          ),
          onPressed: () {
            // FocusScopeNode currentFocus = FocusScope.of(context);
            //
            // if (!currentFocus.hasPrimaryFocus) {
            //   currentFocus.unfocus();
            // }
            preferredActionOnBackPressed != null
                ? preferredActionOnBackPressed()
                : pop(context);


          },
        ),
        Spacer(),
        Text(
          text,
          style: TextStyle(
            color: blue,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        Spacer(),
        Opacity(
          opacity: 0,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 18,
            ),
            onPressed: null,
          ),
        ),
      ],
    );
  }
}
