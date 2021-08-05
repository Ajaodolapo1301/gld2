import 'package:flutter/material.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';

import '../custom_button.dart';
import '../number_button_view.dart';

class TransactionPinBottomSheet extends StatefulWidget {
  final TransactionBottomSheetDetails details;
  final Function(String pin) onButtonPressed;
  final int minusValue;

  const TransactionPinBottomSheet(
      {Key key, this.details, this.onButtonPressed, this.minusValue})
      : super(key: key);

  @override
  _TransactionPinBottomSheetState createState() =>
      _TransactionPinBottomSheetState();
}

class _TransactionPinBottomSheetState extends State<TransactionPinBottomSheet> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: height - (height - 630),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              pop(context);
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: lightBlue,
                    border: Border.all(color: borderBlue.withOpacity(0.1))),
                child: Icon(
                  Icons.close,
                  size: 20,
                  color: blue,
                ),
              ),
            ),
          ),
          Text(
            "Review Transaction",
            style: TextStyle(
              color: blue,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          SizedBox(height: 10),
          widget.details?.middle ?? Container(),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      4,
                      (index) {
                        return AnimatedContainer(
                          height: 15,
                          width: 15,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: pin.length > index ? blue : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: blue, width: 2),
                          ),
                          duration: Duration(milliseconds: 100),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                numberButton(number: "1"),
                                numberButton(number: "2"),
                                numberButton(number: "3"),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                numberButton(number: "4"),
                                numberButton(number: "5"),
                                numberButton(number: "6"),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                numberButton(number: "7"),
                                numberButton(number: "8"),
                                numberButton(number: "9"),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IgnorePointer(
                                  child: numberButton(number: ""),
                                  ignoring: true,
                                ),
                                numberButton(number: "0"),
                                numberButton(
                                    number: "<",
                                    preferredColor: orange,
                                    preferredSize: 25),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          CustomButton(
            text: "${widget.details?.buttonText}" ?? "",
            onPressed: () {
              pop(context);
              widget.onButtonPressed(pin);
            },
          )
        ],
      ),
    );
  }

  String pin = "";

  Widget numberButton({
    String number,
    Color preferredColor,
    double preferredSize,
  }) {
    return NumberButtonView(
      number: number,
      preferredColor: preferredColor,
      preferredSize: preferredSize,
      onTap: () async {
        setState(
          () {
            if (number == "<") {
              if (pin.isNotEmpty) {
                pin = pin.substring(0, pin.length - 1);
              }
            } else {
              if (pin.length != 4) {
                pin += number;
              }
            }
          },
        );
      },
    );
  }
}

class TransactionBottomSheetDetails {
  final String buttonText;
  final Widget middle;
  // final String name;
  // final String bankname;

  TransactionBottomSheetDetails({@required this.buttonText, this.middle} );
}
