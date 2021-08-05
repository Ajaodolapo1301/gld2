import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glade_v2/firebase_notification/NotificationsManager.dart';
import 'package:glade_v2/pages/authentication/forgotPass/forgot_password_page.dart';
import 'package:glade_v2/pages/authentication/register/register_page.dart';
import 'package:glade_v2/pages/authentication/register/stages/createPasscode.dart';
import 'package:glade_v2/pages/authentication/register/stages/emailVerification.dart';
import 'package:glade_v2/pages/authentication/register/stages/verifyBvn.dart';
import 'package:glade_v2/pages/authentication/welcome_back_page.dart';
import 'package:glade_v2/pages/dashboard/dashboard_page.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/functions/dev_utils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>  with AfterLayoutMixin<LoginPage>{
  bool isVisiblePassword = false;
  final FocusNode emailNode = FocusNode();
  final FocusNode passwordNode = FocusNode();
  TextEditingController emailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  var email;
  var password;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  LoginState loginState;
  BusinessState businessState;
AppState appState;
  @override
  void initState() {
    // emailCont.text = "ajao@glade.ng";
    // passCont.text = "123456";
    printLoginInit();
    super.initState();
  }


  @override
  void dispose() {
  emailNode.dispose();
  passwordNode.dispose();

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    loginState = Provider.of<LoginState>(context);
    businessState = Provider.of<BusinessState>(context);
    appState = Provider.of<AppState>(context);
    setStatusBarColor(color: BarColor.black);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: ListView(
            children: [
              SizedBox(height: 40),
              Image.asset(
                "assets/images/logo.png",
                height: 55,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello!\nWelcome.",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: blue,
                            fontSize: 21),
                      ),
                      Text(
                        "Please sign into your account",
                        style: TextStyle(
                          color: blue,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                  Spacer(),
                  Image.asset(
                    "assets/images/login rocket.png",
                    width: 140,
                  )
                ],
              ),
              SizedBox(height: 20),
              Form(
                key: formKey,
                child:Column(
                  children: [
                    CustomTextField(

                      textEditingController:emailCont ,
                      autoFocus: true,
                      focusNode: emailNode,
                      textActionType: ActionType.next,

                      header: "Enter Email Address",
                      hint: "josteve@glade.ng",
                      onSubmit: (value){
                        _fieldFocusChange(context, emailNode, passwordNode);
                      },
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return "Email is required";
                        } else if (!EmailValidator.validate(
                            value.replaceAll(" ", "").trim())) {
                          return "Email is invalid";

                        }
                        email = value;
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
      textEditingController: passCont,
                      focusNode: passwordNode,
                      textActionType: ActionType.done,
                      header: "Enter Password",
                      hint: "******",
                      obscureText: !isVisiblePassword,
                      onSubmit: (value){
                        passwordNode.unfocus();
                        if (formKey.currentState.validate()) {
                          handleLogin();


                        }
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Password  shouldn't be empty";
                        }
                        password = value;
                        print(value);
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
                          fingerPrintLogin()
                        ],
                      ),
                    ),
                  ],
                )
              ),

              SizedBox(height: 40),
              CustomButton(
                text: "Sign In",
                onPressed: () {
                  if (formKey.currentState.validate()) {
                    handleLogin();


                  }
                },
              ),
              SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  pushTo(context, RegisterPage());
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Center(
                    child: Text(
                      "New to Glade? Create An Account",
                      style: TextStyle(
                        color: blue,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  pushTo(context, ForgotPasswordPage());
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Center(
                    child: Text(
                      "Forgot your Password?",
                      style: TextStyle(
                        color: blue,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  handleLogin()async{

    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result = await loginState.login(email: email, password: password);
    // print(email);
    // phoneInfo();
    // print(result);
    Navigator.pop(context);
      if(result["error"] == false && loginState.user.is_email_verified && loginState.user.hasPassCode && loginState.user.is_bvn_matched){
        pref.setString("email", email);
        pref.setString("password", password);
        phoneInfo();
        FocusScopeNode currentScope = FocusScope.of(context);
        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          FocusManager.instance.primaryFocus.unfocus();
        }
        // FocusScope.of(context).unfocus();
        pushTo(context,  (WelcomeBackPage()),PushStyle.cupertino);
        // pushToAndClearStack(context,  (VerifyBvn()));
      }


      else if (result["error"] == false && !loginState.user.is_email_verified){
        // pushTo(context,  (EmailVerification()),PushStyle.cupertino);
        pushToAndClearStack(context,  (EmailVerification()));
      } else if(result["error"] == false && !loginState.user.hasPassCode ){
      // pushTo(context,  (CreatePassCode()),PushStyle.cupertino);
      pushToAndClearStack(context,  (CreatePassCode()));
    }else if(result["error"] == false && !loginState.user.is_bvn_matched) {
      pushToAndClearStack(context,  (VerifyBvn(user: loginState.user,)));
    }


      else{
        CommonUtils.showMsg(body: result["message"]  ?? 'tt', context: context, scaffoldKey: _scaffoldKey,snackColor : Colors.red );

      }
  }







  bool fingerprintLogin = false;
  bool verified = false;
  SharedPreferences pref;

  void printLoginInit() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      fingerprintLogin = pref.getBool("printLogin") ?? false;
    });
    print(fingerprintLogin);
  }

  Widget fingerPrintLogin() {
    if (fingerprintLogin) {
      return Builder(builder: (context) {
        return GestureDetector(
            onTap: (){
              tryFingerPrintLogin(context);

            },
          child: Icon(
            Icons.fingerprint_rounded,
            color: blue,
            size: 18,
          ),
        );
      });
    }
    return SizedBox();
  }

  void tryFingerPrintLogin(BuildContext context) async {
    print(pref.getString("email") );
    print(pref.getString("password") );
    if ((pref.getString("email")).isNotEmpty && pref.getString("password").isNotEmpty) {
      await _checkBiometrics();
      print(_canCheckBiometrics);
      await _getAvailableBiometrics();
      print(_availableBiometrics);
      await _authenticate(context);
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Enter your Credentials this time."),
      ));
    }
  }

  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });

    print(_availableBiometrics);
  }

  Future<void> _authenticate(context) async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
      print("ad $authenticated");
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    print(authenticated);
    if (authenticated) {
      showDialog(
          context: this.context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Preloader();
          });
      var result = await loginState.login(email: pref.getString("email"), password: pref.getString("password"));

        if(result["error"] == false){
          setState(() {
            verified = true;
          });
          if(loginState.user.business_uuid != null){
            //get business details if User has business
            var result2 = await businessState.getBusiness(token: loginState.user.token,business_uuid: loginState.user.business_uuid );
            Navigator.pop(context);
            if(result2["error"] == false){
              pushToAndClearStack(context, DashboardPage());
            }
            // pop(context);
            CommonUtils.showMsg(body: result["message"]  ?? 'tt', context: context, scaffoldKey: _scaffoldKey,snackColor : Colors.red );
          }
        }else{
          CommonUtils.showMsg(body: result["message"]  ?? 'tt', context: context, scaffoldKey: _scaffoldKey,snackColor : Colors.red );
        }

      String incorrectMessage = "Invalid Pin Provided";
      // if (verified == true) {
      //
      // } else {
      //   if (verified != "Unauthenticated") {
      //     Navigator.pop(context);
      //   } else if (verified == "Unauthenticated") {
      //     incorrectMessage = "Unauthenticated.\nPlease login again.";
      //   }
      //   showDialog(
      //     context: context,
      //     builder: (context) {
      //       return Align(
      //         alignment: Alignment.center,
      //         child: Container(
      //           height: 125,
      //           width: MediaQuery.of(context).size.width * 0.68,
      //           decoration: BoxDecoration(
      //               color: Colors.white,
      //               borderRadius: BorderRadius.circular(12)),
      //           alignment: Alignment.center,
      //           child: Column(
      //             mainAxisSize: MainAxisSize.max,
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: <Widget>[
      //               Text(
      //                 incorrectMessage,
      //                 textAlign: TextAlign.center,
      //                 style: TextStyle(
      //                   inherit: false,
      //                   fontSize: 24,
      //                   color: Colors.black,
      //                 ),
      //               ),
      //               SizedBox(
      //                 height: 10,
      //               ),
      //               Button(
      //                 onPressed: () {
      //                   Navigator.pop(context);
      //                   Navigator.pop(context);
      //                 },
      //                 text: "Back",
      //               ),
      //             ],
      //           ),
      //         ),
      //       );
      //     },
      //   );
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Unauthorized"),
      ));
    }
    setState(() {
      _authorized = message;
    });
  }

  void _cancelAuthentication() {
    auth.stopAuthentication();
  }

  @override
  void afterFirstLayout(BuildContext context) {
  // phoneInfo();
  }
  phoneInfo()async{
    var result = await  loginState.phoneInfo(token: loginState.user.token, device_uuid: appState.deviceId, device_token: PushNotificationsManager.deviceToken, device_platform: Platform.isIOS ? "ios" : "android");

  }




}
