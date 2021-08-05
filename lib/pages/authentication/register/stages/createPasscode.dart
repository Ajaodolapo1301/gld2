
import 'package:flutter/material.dart';
import 'package:glade_v2/pages/authentication/login_page.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:glade_v2/utils/widgets/pin_entry_text_field.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class CreatePassCode extends StatefulWidget {
  // final Function(String value)onPinPayload;
  // CreatePassCode({this.onPinPayload});
  @override
  _CreatePassCodeState createState() => _CreatePassCodeState();
}

class _CreatePassCodeState extends State<CreatePassCode> {
  AppState appState;
  String ping;
  LoginState loginState;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String passcode;
  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);
    loginState = Provider.of<LoginState>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Header(
                    preferredActionOnBackPressed: (){
                     pushReplacementTo(context, LoginPage());
                    },
                      text: "",
                    ),

                    Image.asset(
                      "assets/images/logo.png",
                      height: 60,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Create a New\nPasscode",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: blue, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Choose your preferred 4 digit passcode and \nclick continue to proceed",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: blue, fontSize: 13),
                    ),
                    SizedBox(height: 40),
                    Text(
                      "Enter Passcode",
                      style: TextStyle(
                          color: blue,
                          fontSize: 12
                      ),
                    ),
                    SizedBox(height: 8),
                    PinEntryTextField(
                      fields: 4,
                      showFieldAsBox: true,
                      isTextObscure: true,
                      getCont: (controllers){},
                      onSubmit: (pin) {
                        setState(() {
                          passcode = pin;
                          // widget.onPinPayload(passcode);

                        });
                      },
                    ),
                    SizedBox(height: 40),
                    Text(
                      "Confirm Passcode",
                      style: TextStyle(
                          color: blue,
                          fontSize: 12
                      ),
                    ),
                    SizedBox(height: 8),
                    PinEntryTextField(

                      fields: 4,
                      showFieldAsBox: true,
                      isTextObscure: true,
                      getCont: (controllers){},
                      onSubmit: (pin) {
//               setState(() {
//                 ping = pin;
//               });
                      },
                    ),


                  ],
                ),
              ),

              Container(
                // padding: EdgeInsets.symmetric(horizontal: 25),
                child: CustomButton(
                  onPressed:  () async {

            createPassCode(passcode);



                  },
                  text:  "Create",
                  showArrow: true,
                  color: cyan,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  createPassCode(passcode)async{
    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result = await loginState.createPasscode(passCode:passcode, user_uuid:loginState.user.user_uuid );
    Navigator.pop(context);
    if(result["error"] == false){
      toast("Please login again");
      pushToAndClearStack(context, LoginPage());

    }else{
      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );

    }

  }
}
