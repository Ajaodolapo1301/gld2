import 'dart:async';

import 'package:flutter/material.dart';

import 'package:glade_v2/pages/authentication/login_page.dart';
import 'package:glade_v2/pages/authentication/register/stages/verifyBvn.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/reuseables/otpTimer.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:glade_v2/utils/widgets/number_button_view.dart';
import 'package:provider/provider.dart';



class EmailVerification extends StatefulWidget {
  @override
  _EmailVerificationState createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> with SingleTickerProviderStateMixin{
  final int time = 30;
  AppState appState;
  AnimationController _controller;
  LoginState loginState;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String otp = "";

  Timer timer;
  int totalTimeInSeconds;
  bool _hideResendButton;


  @override
  void initState() {
    totalTimeInSeconds = time;
    _controller =
    AnimationController(vsync: this, duration: Duration(seconds: time))
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          setState(() {
            _hideResendButton = !_hideResendButton;
          });
        }
      });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
    _startCountdown();

    // getCurrentAppTheme();
    super.initState();
  }


  @override
  void dispose() {
  _controller.dispose();
  timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);
    loginState = Provider.of<LoginState>(context);
    // print(" hideR ${_hideResendButton}");
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              Image.asset(
                "assets/images/logo.png",
                height: 60,
              ),
              SizedBox(height: 10),
              Text(
                "Enter OTP sent to your\n Email",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: blue, fontSize: 17, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Enter 6 digits OTP to continue",
                style: TextStyle(color: blue, fontSize: 13),
              ),
              SizedBox(height: 40),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          6,
                              (index) {
                            return AnimatedContainer(
                              height: 15,
                              width: 15,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: otp.length > index ? blue : Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: blue, width: 2),
                              ),
                              duration: Duration(milliseconds: 100),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 30),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 20,
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    numberButton(number: "1"),
                                    numberButton(number: "2"),
                                    numberButton(number: "3"),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    numberButton(number: "4"),
                                    numberButton(number: "5"),
                                    numberButton(number: "6"),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    numberButton(number: "7"),
                                    numberButton(number: "8"),
                                    numberButton(number: "9"),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    IgnorePointer(
                                      child: numberButton(number: ""),
                                      ignoring: true,
                                    ),
                                    numberButton(number: "0"),
                                    numberButton(
                                        number: "<",
                                        preferredColor: orange,
                                        preferredSize: 35),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _hideResendButton ? _getTimerText : _getResendButton,
                      SizedBox(height: 20,)
                    ],
                  ),
                ),
              ),





            ],
          ),
        ),
      ),
    );
  }


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
//              otp.isNotEmpty ||
                if (otp.isNotEmpty) {
                  otp = otp.substring(0, otp.length - 1);
//                appState.OTPPhone.substring(0, appState.OTPPhone.length - 1);
                }
              } else {
//              otp.length != 6 ||
                if (otp.length != 6) {
//                otp += number;
                  otp += number;
                  if (otp.length == 6) {
                    verifyEmail();
                  }
                }
              }
            });
      },
    );
  }



  get _getResendButton {
    return new InkWell(
        onTap: (){
        resendEmail();
        },
      child: new Container(
        height: 30,
        width: 157,
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(32)),
        alignment: Alignment.center,
        child: new Text(
          "Didn't get OTP, Resend OTP",
          style: TextStyle(
              fontSize: 12,
              color: orange,
        ),
      ),

    )
    );
  }



  get _getTimerText {
    return Container(
      height: 32,
      child: new Offstage(
        offstage: !_hideResendButton,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Icon(Icons.access_time, color: Colors.black,),
            new SizedBox(
              width: 5.0,
            ),
            OtpTimer(_controller, 15.0, blue)
          ],
        ),
      ),
    );
  }



  Future<Null> _startCountdown() async {
    setState(() {
      _hideResendButton = true;
      totalTimeInSeconds = time;
    });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
  }


  resendEmail() async {
    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result = await loginState.resendEmail(user_uuid: loginState.user.user_uuid);
    Navigator.pop(context);
    if (result["error"] == false) {

      CommonUtils.showMsg(body: result["message"] , context: context, scaffoldKey: _scaffoldKey, snackColor: Colors.green);

    } else {
      CommonUtils.showMsg(body: result["message"] ,
          context: context,
          scaffoldKey: _scaffoldKey,
          snackColor: Colors.red);
    }
  }


  verifyEmail() async {
    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result = await loginState.emailVerification(
        token: loginState.user.token, otp: otp);
    Navigator.pop(context);
    if (result["error"] == false) {

      CommonUtils.showMsg(body: result["message"] , context: context, scaffoldKey: _scaffoldKey, snackColor: Colors.green);

    Future.delayed(const Duration(milliseconds: 1000), () {
    loginState.user.is_bvn_matched  ?    pushReplacementTo(context, (LoginPage()), PushStyle.cupertino) : pushReplacementTo(context, (VerifyBvn(user: loginState.user,)), PushStyle.cupertino );

    });


    } else {
      setState(() {
        otp = otp.substring(0, otp.length - 6);
      });
      CommonUtils.showMsg(body: result["message"] ,
          context: context,
          scaffoldKey: _scaffoldKey,
          snackColor: Colors.red);
    }
  }
}
