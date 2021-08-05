import 'package:flutter/material.dart';
import 'package:glade_v2/core/models/apiModels/Auth/register.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/functions/dialog_utils.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:glade_v2/utils/widgets/pin_entry_text_field.dart';
import 'package:provider/provider.dart';

class RegisterStage5 extends StatefulWidget {
  final Function(String value)onPinPayload;
  Register1 register1;
  RegisterStage5({this.onPinPayload,this.register1 });
  @override
  _RegisterStage5State createState() => _RegisterStage5State();
}

class _RegisterStage5State extends State<RegisterStage5> {
  AppState appState;
  LoginState loginState;
  String ping;
  String passcode;
  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);
    loginState = Provider.of<LoginState>(context);
    print(widget.register1);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                widget.onPinPayload(passcode);

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
          // SizedBox(height: 8),

          Spacer(),
          Container(
            // padding: EdgeInsets.symmetric(horizontal: 25),
            child: CustomButton(
              onPressed:  () async {

                if(passcode != null ){
                  createPassCode(passcode);
                }else{
                  CommonUtils.kShowSnackBar(color: Colors.red, msg: "Enter a PassCode", ctx: context);
                }




              },
              text:  "Next",
              showArrow: true,
              color: cyan,
            ),
          ),
          SizedBox(height: 15),
        ],
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
    var result = await loginState.createPasscode(passCode:passcode, user_uuid: widget.register1.user_uuid);
    Navigator.pop(context);
    if(result["error"] == false){
      // setState(() {
      //   index++;
      // });
      showAccountCreationSuccessfulDialog(context);

    }else{

      CommonUtils.kShowSnackBar(ctx: context, msg: result["message"], color: Colors.red );
      // CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );

    }

  }

}
