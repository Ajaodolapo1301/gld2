
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';

class CardPinScreen extends StatefulWidget {
//   final bool isDark;
//
// //
//
//   CardPinScreen({this.isDark = false});

  @override
  _CardPinScreenState createState() => _CardPinScreenState();
}

class _CardPinScreenState extends State<CardPinScreen> {
//  Dimens dimens;

  String enteredPin;
  Size _screenSize;

  // Variables

  int _currentDigit;
  int _firstDigit;
  int _secondDigit;
  int _thirdDigit;
  int _fourthDigit;
  int _fifthDigit;
  int _sixth;

//  Timer timer;
  int totalTimeInSeconds;
  bool _hideResendButton;
  String otp = "";
  List<TextEditingController> controllers;

  @override
  Widget build(BuildContext context) {
//    dimens = Dimens(context);
    _screenSize = MediaQuery.of(context).size;
    var radius = Radius.circular(5);
    return Container(
      height: _screenSize.height,
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(20.0),
              topRight: const Radius.circular(20.0)),
        ),
        // padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
//            physics: BouncingScrollPhysics(),
              children: <Widget>[
                Column(
                  children: [
                    Container(
                      margin:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Enter Your Card Pin".toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: blue),
                          ),
                          GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Text(
                                "x",
                              ))
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    // Container(
                    //   margin: EdgeInsets.symmetric(horizontal: 20, vertical:10),
                    //   child: Text.rich(TextSpan(children: [
                    //     TextSpan(
                    //         text: "You about to transfer ",
                    //         style: GoogleFonts.raleway(
                    //           color: widget.isDark ? Colors.white : kprimaryLight,
                    //           fontSize: 10,
                    //         )),
                    //     TextSpan(
                    //         text: "121.0 EUR (61,710NGN)",
                    //         style: GoogleFonts.raleway(
                    //           color: widget.isDark ? Colors.white : kPrimaryColor,
                    //           fontSize: 10,
                    //           fontWeight: FontWeight.bold,
                    //         )),
                    //     TextSpan(
                    //         text: " from",
                    //         style: GoogleFonts.raleway(
                    //           color: widget.isDark ? Colors.white : kprimaryLight,
                    //           fontSize: 10,
                    //         )),
                    //     TextSpan(
                    //         text: " 001122334432",
                    //         style: GoogleFonts.raleway(
                    //           color: widget.isDark ? Colors.white : kPrimaryColor,
                    //           fontSize: 10,
                    //           fontWeight: FontWeight.bold,
                    //         )),
                    //     TextSpan(
                    //         text: " to",
                    //         style: GoogleFonts.raleway(
                    //           color: widget.isDark ? Colors.white : kprimaryLight,
                    //           fontSize: 10,
                    //         )),
                    //     TextSpan(
                    //         text: " Christopher Ntuk-@chris- 2211122334",
                    //         style: GoogleFonts.raleway(
                    //           color: widget.isDark ? Colors.white : kPrimaryColor,
                    //           fontSize: 10,
                    //           fontWeight: FontWeight.bold,
                    //         )),
                    //   ])),
                    // ),
                    SizedBox(
                      height: 10,
                    ),

                    _getInputPart,
//              Container(
//                height: 50,
//                child: Button(
//                  disableColor: kPrimaryColor.withOpacity(0.5),
//                  onPressed:() async {
//                    print(otp);
//                    if(otp?.length == 4){
//                      print("Clicked");
////                      widget.onClickContinue(otp);
//                      // controllers.forEach((element) {
//                      //   element.clear();
//                      // });
//                    }
//                    //Confirm pin.
//
//
//                  },
//                  text: "Continue".toUpperCase(),
//                ),
//              ),

                    SizedBox(
                      height: 220,
                    )
                  ],
                ),
              ]),
        ));
  }

  get _getInputPart {
    return new Column(
//      mainAxisSize: MainAxisSize.max,
//      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _getInputField,
        SizedBox(
          height: 10,
        ),
        Text(
          "",
          style: TextStyle(
              fontSize: 14,
              color:  blue,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 10,
        ),
        _getOtpKeyboard,
      ],
    );
  }

  // Returns "Otp keyboard input Button"
  Widget _otpKeyboardInputButton({String label, VoidCallback onPressed}) {
    return new Material(
      color: Colors.transparent,
      child: new InkWell(
        onTap: onPressed,
        borderRadius: new BorderRadius.circular(40.0),
        child: new Container(
          height: 50.0,
          width: 50.0,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: new Center(
            child: new Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color:  blue,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Returns "Otp keyboard action Button"
  _otpKeyboardActionButton({Widget label, VoidCallback onPressed}) {
    return new InkWell(
      onTap: onPressed,
      borderRadius: new BorderRadius.circular(40.0),
      child: new Container(
        height: 50.0,
        width: 50.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: new Center(
          child: label,
        ),
      ),
    );
  }

  get _getOtpKeyboard {
    return new Container(
        height: _screenSize.width - 80,
        child: new Column(
          children: <Widget>[
            new Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 0, left: 0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _otpKeyboardInputButton(
                        label: "1",
                        onPressed: () {
                          _setCurrentDigit(1);
                        }),
                    _otpKeyboardInputButton(
                        label: "2",
                        onPressed: () {
                          _setCurrentDigit(2);
                        }),
                    _otpKeyboardInputButton(
                        label: "3",
                        onPressed: () {
                          _setCurrentDigit(3);
                        }),
                  ],
                ),
              ),
            ),
            new Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 0, left: 0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _otpKeyboardInputButton(
                        label: "4",
                        onPressed: () {
                          _setCurrentDigit(4);
                        }),
                    _otpKeyboardInputButton(
                        label: "5",
                        onPressed: () {
                          _setCurrentDigit(5);
                        }),
                    _otpKeyboardInputButton(
                        label: "6",
                        onPressed: () {
                          _setCurrentDigit(6);
                        }),
                  ],
                ),
              ),
            ),
            new Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 0, left: 0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _otpKeyboardInputButton(
                        label: "7",
                        onPressed: () {
                          _setCurrentDigit(7);
                        }),
                    _otpKeyboardInputButton(
                        label: "8",
                        onPressed: () {
                          _setCurrentDigit(8);
                        }),
                    _otpKeyboardInputButton(
                        label: "9",
                        onPressed: () {
                          _setCurrentDigit(9);
                        }),
                  ],
                ),
              ),
            ),
            new Expanded(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new SizedBox(
                    width: 80.0,
                  ),
                  _otpKeyboardInputButton(
                      label: "0",
                      onPressed: () {
                        _setCurrentDigit(0);
                      }),
                  _otpKeyboardActionButton(
                      label: Text("<", style: TextStyle(color: orange, fontSize: 20, fontWeight: FontWeight.bold),),
                      onPressed: () {
                        setState(() {
                          if (_fourthDigit != null) {
                            _fourthDigit = null;
                          } else if (_thirdDigit != null) {
                            _thirdDigit = null;
                          } else if (_secondDigit != null) {
                            _secondDigit = null;
                          } else if (_firstDigit != null) {
                            _firstDigit = null;
                          }
                        });
                      }),
                ],
              ),
            ),
          ],
        ));
  }

  get _getInputField {
    return Padding(
      padding: const EdgeInsets.only(right: 0, left: 0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _otpTextField(_firstDigit),
          _otpTextField(_secondDigit),
          _otpTextField(_thirdDigit),
          _otpTextField(_fourthDigit),
        ],
      ),
    );
  }

  Widget _otpTextField(int digit) {
    return new Container(
      width: 47.0,
      height: 44.0,
      alignment: Alignment.center,
      child: new Text(
        digit != null ? "*" : " ",
        style: new TextStyle(
          fontSize: 30.0,
          color:  Colors.black,
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: blue.withOpacity(0.1),
      ),
    );
  }

  void _setCurrentDigit(int i) {
    setState(() {
      _currentDigit = i;
      if (_firstDigit == null) {
        _firstDigit = _currentDigit;
      } else if (_secondDigit == null) {
        _secondDigit = _currentDigit;
      } else if (_thirdDigit == null) {
        _thirdDigit = _currentDigit;
      } else if (_fourthDigit == null) {
        _fourthDigit = _currentDigit;

        otp = _firstDigit.toString() +
            _secondDigit.toString() +
            _thirdDigit.toString() +
            _fourthDigit.toString();

        Navigator.pop(context, otp);
//        var otp = _firstDigit.toString() +
//            _secondDigit.toString() +
//            _thirdDigit.toString() +
//            _fourthDigit.toString();

        // Verify your otp by here. API call
      } else if (_fifthDigit == null) {
        _fifthDigit = _currentDigit;
      } else if (_sixth == null) {
        _sixth = _currentDigit;
      }
    });
  }
}