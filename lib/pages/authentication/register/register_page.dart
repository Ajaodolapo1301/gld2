import 'package:flutter/material.dart';
import 'package:glade_v2/core/models/apiModels/Auth/bvn.dart';
import 'package:glade_v2/core/models/apiModels/Auth/register.dart';
import 'package:glade_v2/pages/authentication/register/stages/register_stage_1.dart';
import 'package:glade_v2/pages/authentication/register/stages/register_stage_2.dart';
import 'package:glade_v2/pages/authentication/register/stages/register_stage_3.dart';
import 'package:glade_v2/pages/authentication/register/stages/register_stage_4.dart';
import 'package:glade_v2/pages/authentication/register/stages/register_stage_5.dart';
import 'package:glade_v2/pages/authentication/register/stages/verifyBvn.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/functions/dialog_utils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:glade_v2/utils/widgets/pin_entry_text_field.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  PageController controller = PageController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int index = 0;
  bool validated = false;
  bool validatedRegist = false;
  LoginState loginState;
  AppState appState;
  BVNModel bvnModel;
  Register1 register1;
  String password;
  String passcode;
  String bvn;
  String otp;
  Map<String, dynamic> userPayload = {};
  @override
  Widget build(BuildContext context) {
  loginState = Provider.of<LoginState>(context);
  appState = Provider.of<AppState>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 30),
              // Header(
              //   preferredActionOnBackPressed: (){
              //     pop(context);
              //   },
              //   text: "back",
              // ),

              Expanded(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Form(
                    key: _formKey,
                    child: Container(
                      color: Colors.white,
                      child: PageView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: controller,
                        children: [
                          RegisterStage1(controller: controller, index: index, onBvnPayload: (v){
                            setState(() {
                              bvn = v;

                            });
                          },),
                          RegisterStage2(bvnModel: bvnModel,  index: index, controller: controller, onUserPayload: (v){
                            setState(() {
                          userPayload = v;
                            });

                          },),
                          RegisterStage4(userPayload:  userPayload, controller: controller, bvn: bvn,  registerObject: (v){
                            setState(() {
                              register1 = v;
                            });
                          },),
                          // RegisterStage3( otp: (v){
                          //   setState(() {
                          //     otp = v;
                          //     if(otp.length == 6){
                          //       OtpValidation();
                          //     }
                          //   });
                          // },),
                          RegisterStage5(register1: register1, onPinPayload: (v){
                            setState(() {
                              passcode = v;
                            });
                          },)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 25),
              //   child: CustomButton(
              //     onPressed:  () async {
              //       if(index == 0 ){
              //         if(_formKey.currentState.validate() || bvn?.length ==  11 ){
              //           verifyBVn();
              //         }
              //       }else if(index == 1){
              //         if(_formKey.currentState.validate()){
              //           setState(() {
              //             index ++;
              //           });
              //           await controller.nextPage(
              //             duration: Duration(milliseconds: 500),
              //             curve: Curves.easeOutExpo,
              //           );
              //         }
              //       }else if(index == 2){
              //         if(_formKey.currentState.validate()){
              //           print(_formKey.currentState.validate());
              //          register(context);
              //
              //         }
              //       }else if (index == 3) {
              //         if(passcode != null){
              //           createPassCode(passcode);
              //         }
              //       }
              //       // else if (index ==4){
              //       //   if(passcode != null){
              //       //     createPassCode(passcode);
              //       //   }
              //       // }
              //
              //
              //
              //
              //
              //       //Check index to know the endpoint to call
              //       // if (controller.page == 4) {
              //       //
              //       // }
              //       // else if (controller.page ==  1) {
              //       //
              //       //     FocusScope.of(context).requestFocus(FocusNode());
              //       //   }
              //
              //
              //     },
              //     text:  index == 3 ? "Confirm OTP": "Next",
              //     showArrow: true,
              //     color: cyan,
              //   ),
              // ),
              // SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }





//  Auth

  verifyBVn()async{
    setState(() {
      index++;
    });
    await  controller.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutExpo,
    );


  }

  register(context) async {
    print("call me");
    print(userPayload);
    print(passcode);
    print(bvn);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });



var result  = await loginState.register1(email: userPayload["email"], firstName: userPayload["firstname"], lastName: userPayload["lastname"], phone: userPayload["preferredPhone"], bvn: bvn , password: password);
    Navigator.pop(context);
if(result["error"] == false){
    register1 = result["res"];
    setState(() {
      index++;
    });
    await controller.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutExpo,
    );
    print("here");
  }else{
    CommonUtils.showMsg(body:result["message"] ?? "Error", context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );

  }

  } // giv u OTP

//  OtpValidation()async {
//      showDialog(
//          context: this.context,
//          barrierDismissible: false,
//          builder: (BuildContext context) {
//            return Preloader();
//          });
// var result  = await loginState.otpValidation(otp: otp, user_uuid: register1.user_uuid);
//      Navigator.pop(context);
//
//   if(result["error"] == false){
//     setState(() {
//       index++;
//     });
//     await controller.nextPage(
//       duration: Duration(milliseconds: 500),
//       curve: Curves.easeOutExpo,
//     );
//
//   }else{
//     CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );
//
//   }
//
//    }


  createPassCode(passcode)async{
    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result = await loginState.createPasscode(passCode:passcode, user_uuid: register1.user_uuid);
    Navigator.pop(context);
      if(result["error"] == false){
    setState(() {
      index++;
    });
   showAccountCreationSuccessfulDialog(context);

  }else{
    CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );

  }

  }

}
