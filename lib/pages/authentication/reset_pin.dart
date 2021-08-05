import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glade_v2/pages/authentication/welcome_back_page.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:glade_v2/utils/widgets/pin_entry_text_field.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';

class ResetYourPinPage extends StatefulWidget {
  @override
  _ResetYourPinPageState createState() => _ResetYourPinPageState();
}

class _ResetYourPinPageState extends State<ResetYourPinPage> {
  AppState appState;
  var otp;
  var newPin;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinPutController = TextEditingController();
  final TextEditingController _pinPutController2 = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final FocusNode _pinPutFocusNode2 = FocusNode();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      color: lightBlue,
      border: Border.all(color: borderBlue.withOpacity(0.35)),
      // borderRadius: BorderRadius.circular(15.0),
    );
  }
  LoginState loginState;
  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);
    loginState = Provider.of<LoginState>(context);
    return Scaffold(key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Column(
            children: [
              Header(
                preferredActionOnBackPressed: (){
                  pop(context);
                },
                text: "",
              ),
              // SizedBox(height: 20),
              Image.asset(
                "assets/images/logo.png",
                height: 60,
              ),
              SizedBox(height: 10),
              Text(
                "Reset your Pin",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: blue, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Reset your 4 digit Passcode (PIN) \nand keep it safe. ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: blue,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 40),
              Expanded(
                child: ListView(
                  children: [

                    SizedBox(height: 40),
                    Text(
                      "Enter OTP Sent to your Email",
                      style: TextStyle(color: blue, fontSize: 12),
                    ),
                    SizedBox(height: 8),
                    // Expanded(
                    //   child: PinEntryTextField(
                    //     fields: 6,
                    //
                    //     fieldWidth: 20,
                    //     showFieldAsBox: true,
                    //     isTextObscure: true,
                    //     getCont: (controllers) {},
                    //     onSubmit: (pin) {
                    //       setState(() {
                    //         otp = pin;
                    //       });
                    //     },
                    //   ),
                    // ),

                    Container(
                    color: Colors.white,
                    // margin: const EdgeInsets.all(20.0),
                    // padding: const EdgeInsets.all(20.0),
                    child: PinPut(
                  eachFieldWidth: 50,
                      eachFieldHeight: 50,
                      obscureText: "*",
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,

                      ],
                      textStyle: TextStyle(fontSize: 20, color: blue),
                      fieldsCount:6,
                      // onSubmit: (String pin) => _showSnackBar(pin, context),
                      focusNode: _pinPutFocusNode,
                      controller: _pinPutController,
                      submittedFieldDecoration: _pinPutDecoration.copyWith(
                        // borderRadius: BorderRadius.circular(20.0),
                      ),
                      selectedFieldDecoration: _pinPutDecoration,

                      followingFieldDecoration: _pinPutDecoration.copyWith(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: borderBlue.withOpacity(0.35),
                        ),
                      ),
                    ),
                    ),
                    SizedBox(height:30),
                    
                    Text(
                      "Enter New Pin",
                      style: TextStyle(color: blue, fontSize: 12),
                    ),


                    SizedBox(height: 10),
                    // PinEntryTextField(
                    //   fields: 4,
                    //   fieldWidth: 60,
                    //   showFieldAsBox: true,
                    //   isTextObscure: true,
                    //   getCont: (controllers) {},
                    //   onSubmit: (pin) {
                    //      setState(() {
                    //        newPin = pin;
                    //      });
                    //   },
                    // ),
//                    SizedBox(height: 40),
//                    Text(
//                      "Enter OTP Sent to your Email",
//                      style: TextStyle(color: blue, fontSize: 12),
//                    ),
//                    SizedBox(height: 8),
//                    PinEntryTextField(
//                      fields: 6,
//                      fieldWidth: 15,
//                      showFieldAsBox: true,
//                      isTextObscure: true,
//                      getCont: (controllers) {},
//                      onSubmit: (pin) {
//                         setState(() {
//                           otp = pin;
//                         });
//                      },
//                    ),
//                    SizedBox(height: 8),

                    Container(
                      color: Colors.white,
                      // margin: const EdgeInsets.all(20.0),
                      // padding: const EdgeInsets.all(20.0),
                      child: PinPut(
                        obscureText: "*",
                        eachFieldWidth: 50,
                        eachFieldHeight: 50,

                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,

                        ],
                        textStyle: TextStyle(fontSize: 20, color: blue),
                        fieldsCount:4,
                        // onSubmit: (String pin) => _showSnackBar(pin, context),
                        focusNode: _pinPutFocusNode2,
                        controller: _pinPutController2,
                        submittedFieldDecoration: _pinPutDecoration.copyWith(
                          // borderRadius: BorderRadius.circular(20.0),
                        ),
                        selectedFieldDecoration: _pinPutDecoration,
                        followingFieldDecoration: _pinPutDecoration.copyWith(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                            color: borderBlue.withOpacity(0.35),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              CustomButton(
                text: "Reset Pin",
                color: cyan,
                onPressed: () {
                  resetPin();
                },
              )
            ],
          ),
        ),
      ),
    );
  }


  resetPin() async {
    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result = await loginState.ChangePin2(newPasscode: _pinPutController2.text, verification_code: _pinPutController.text, token: loginState.user.token);
    Navigator.pop(context);

    if (result["error"] == false) {

      CommonUtils.showMsg(body: result["message"] ?? "tt",
          context: context,
          scaffoldKey: _scaffoldKey,
          snackColor: Colors.green);

      Future.delayed(const Duration(seconds: 2), () {

        pushTo(context, (WelcomeBackPage(

        )), PushStyle.cupertino);
      });


    } else {
      CommonUtils.showMsg(body: result["message"] ?? "tt",
          context: context,
          scaffoldKey: _scaffoldKey,
          snackColor: Colors.red);
    }
  }

}
