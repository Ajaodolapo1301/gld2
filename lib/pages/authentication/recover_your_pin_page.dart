import 'package:flutter/material.dart';
import 'package:glade_v2/pages/authentication/login_page.dart';
import 'package:glade_v2/pages/dashboard/dashboard_page.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:glade_v2/utils/widgets/pin_entry_text_field.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecoverYourPinPage extends StatefulWidget {
  @override
  _RecoverYourPinPageState createState() => _RecoverYourPinPageState();
}

class _RecoverYourPinPageState extends State<RecoverYourPinPage> {

  var currentPin;

  var newPin;
  AppState appState;
  LoginState loginState;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String otp = "";
  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);
    loginState = Provider.of<LoginState>(context);

    return Scaffold(
      key: _scaffoldKey,
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
              SizedBox(height: 20),
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
                    Text(
                      "Enter Current Pin",
                      style: TextStyle(color: blue, fontSize: 12),
                    ),
                    SizedBox(height: 8),
                    PinEntryTextField(
                      fields: 4,
                      showFieldAsBox: true,
                      isTextObscure: true,
                      getCont: (controllers) {},
                      onSubmit: (pin) {
                         setState(() {
                           currentPin = pin;
                         });
                      },
                    ),
                    SizedBox(height: 40),
                    Text(
                      "Enter New Pin",
                      style: TextStyle(color: blue, fontSize: 12),
                    ),
                    SizedBox(height: 8),
                    PinEntryTextField(
                      fields: 4,
                      showFieldAsBox: true,
                      isTextObscure: true,
                      getCont: (controllers) {},
                      onSubmit: (pin) {
                         setState(() {
                           newPin = pin;
                         });
                      },
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
              CustomButton(
                text: "Change pin".toUpperCase(),
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
    var result = await loginState.resetPin(
        token: loginState.user.token, currentPin: currentPin, newPin: newPin);
    Navigator.pop(context);

    if (result["error"] == false) {

      CommonUtils.showAlertDialog(context: context, text: result["message"], onClose: () async{
        final box = Hive.box("user");
        box.put('user', null);
        final SharedPreferences sharedPref = await SharedPreferences.getInstance();
//        sharedPref.clear();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
                (Route<dynamic> route) => false);
      });


    } else {
      CommonUtils.showMsg(body: result["message"] ?? "tt",
          context: context,
          scaffoldKey: _scaffoldKey,
          snackColor: Colors.red);
    }
  }


}
