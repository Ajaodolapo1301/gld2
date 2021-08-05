import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glade_v2/pages/authentication/forgotPass/forgotPinPad.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String email;
  AppState appState;
  LoginState loginState;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String otp = "";
  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);
    loginState = Provider.of<LoginState>(context);
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Image.asset(
                  "assets/images/logo.png",
                  height: 60,
                ),
                SizedBox(height: 10),
                Text(
                  "Forgot\nPassword?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: blue, fontSize: 23, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
              Form(
                key:_formKey ,
                child:  CustomTextField(
                  validator: (value){
                    if (value.trim().isEmpty) {
                      return "Email is required";
                    } else if (!EmailValidator.validate(
                        value.replaceAll(" ", "").trim())) {
                      return "Email is invalid";
                    }
                    email = value;
                    return null;
                  },


                  header: "Enter Email Address",
                  hint: "josteve@glade.ng",
                ),
              ),
                Spacer(),
                CustomButton(
                  onPressed: () {
                  if(_formKey.currentState.validate()){
                    resetPassword();
                  }

                  },
                  text: "Reset Password",
                  color: cyan,
                ),
                SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    text: "Already Have An Account? ",
                    style: TextStyle(
                      color: blue,
                      fontSize: 12
                    ),
                    children: [
                      TextSpan(
                        text: "Sign In",
                        style: TextStyle(
                          color: orange,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                        ),
                        recognizer: TapGestureRecognizer()..onTap = (){
                          pop(context);
                        }
                      )
                    ]
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
  resetPassword() async {
    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result = await loginState.resetPassword(email: email);
    Navigator.pop(context);

    if (result["error"] == false) {

      CommonUtils.showMsg(body: result["message"] ?? "tt",
          context: context,
          scaffoldKey: _scaffoldKey,
          snackColor: Colors.green);

      Future.delayed(const Duration(milliseconds: 500), () {

        pushTo(context, (ForgotPassPad(
          email: email,
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
