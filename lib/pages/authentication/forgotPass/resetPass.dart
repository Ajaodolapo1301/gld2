
import 'package:flutter/material.dart';
import 'package:glade_v2/pages/authentication/login_page.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:provider/provider.dart';

class ResetPass extends StatefulWidget {

  final String email;
  final verificationCode;

  ResetPass({this.email, this.verificationCode});
  @override
  _ResetPassState createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  AppState appState;
  var password;
  bool isVisiblePassword = true;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  LoginState loginState;
  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);
    loginState = Provider.of<LoginState>(context);
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Almost there!",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: blue,
                              fontSize: 21),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Enter you choose your preferred password",
                          style: TextStyle(
                            color: blue,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                  Image.asset(
                    "assets/images/bicycle_man.png",
                    width: 100,
                  )
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                      Form(
                        key:_formKey ,
                        child: Column(
                          children: [
                            CustomTextField(
                              // autoFocus: true,
                              textActionType: ActionType.done,
                              header: "Enter new Password",
                              hint: "******",
                              obscureText: !isVisiblePassword,
                              onSubmit: (value){
                                if(_formKey.currentState.validate()){
                                  resetPassword();

                                }

                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Password  shouldn't be empty";
                                }
                                password = value;
                                return null;
                              },
                              suffix: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isVisiblePassword = !isVisiblePassword;
                                      });
                                    },
                                    child: Text(
                                      isVisiblePassword ? "HIDE" : "SHOW",
                                      style: TextStyle(fontSize: 10, color: cyan),
                                    ),
                                  ),
                                  SizedBox(width: 8),

                                ],
                              ),
                            ),
                            SizedBox(height: 15),

                          ],
                        ),
                      )
                  ],
                ),
              ),
              SizedBox(height: 20),

              Container(
//                padding: EdgeInsets.symmetric(horizontal: 25),
                child: CustomButton(
                  onPressed:  () async {
                    if(_formKey.currentState.validate()){
                      resetPassword();

                    }

                  },
                  text:   "Reset",
                  showArrow: true,
                  color: cyan,
                ),
              ),
              SizedBox(height: 15),

            ],
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
    var result = await loginState.resetpassword2(email: widget.email, verification_code: widget.verificationCode, new_pass: password);
    Navigator.pop(context);

    if (result["error"] == false) {

      CommonUtils.showMsg(body: result["message"] ?? "tt",
          context: context,
          scaffoldKey: _scaffoldKey,
          snackColor: Colors.green);

      Future.delayed(const Duration(seconds: 2), () {

        pushTo(context, (LoginPage(

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
