import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';

class NumberButtonView extends StatefulWidget {
  final String number;
  final Color preferredColor;
  final double preferredSize;
  final VoidCallback onTap;

  const NumberButtonView(
      {Key key,
        this.number,
        this.preferredColor,
        this.preferredSize,
        this.onTap
      })
      : super(key: key);

  @override
  _NumberButtonViewState createState() => _NumberButtonViewState();
}

class _NumberButtonViewState extends State<NumberButtonView> {
  bool clicked = false;
  bool canVibrate = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        widget.onTap();
        HapticFeedback.heavyImpact();
        setState(() {
          clicked = true;
        });
        await Future.delayed(Duration(milliseconds: 400));
        setState(() {
          clicked = false;
        });
      },
      child: AnimatedContainer(
        width: 55,
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: clicked ? deepCyan : Colors.white,
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Center(
          child: Text(
            "${widget.number}",
            style: TextStyle(
              color: widget.preferredColor ?? blue,
              fontWeight: FontWeight.bold,
              fontSize: widget.preferredSize ?? 20,
            ),
          ),
        ),
      ),
    );
  }
}