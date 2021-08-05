
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glade_v2/pages/authentication/forgotPass/resetPass.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:glade_v2/utils/widgets/number_button_view.dart';
import 'package:provider/provider.dart';

class ForgotPassPad extends StatefulWidget {
  final String email;

  ForgotPassPad({this.email});
  @override
  _ForgotPassPadState createState() => _ForgotPassPadState();
}

class _ForgotPassPadState extends State<ForgotPassPad> {

  AppState appState;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String otp = "";
  @override
  Widget build(BuildContext context) {
    appState = Provider.of(context);

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              Header(
                preferredActionOnBackPressed: (){


                },
                text: "",
              ),
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

                if ( otp.isNotEmpty ) {
                  otp = otp.substring(0, otp.length - 1);

                }
              } else {

                if ( otp.length != 6) {

                  otp += number;
                  if (otp.length == 6) {
                    resetPassword2();

                  }

                }
              }
            });
      },
    );
  }

  resetPassword2() async {
    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });

    Future.delayed(const Duration(seconds: 2), () {
Navigator.pop(context);
      pushTo(context, (ResetPass(
        email: widget.email,
        verificationCode: otp,
      )), PushStyle.cupertino);
    });



    }
  }



