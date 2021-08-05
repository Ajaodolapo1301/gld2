import 'package:flutter/material.dart';
import 'package:glade_v2/core/models/apiModels/Auth/register.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:provider/provider.dart';

class RegisterStage4 extends StatefulWidget {
  PageController controller;
  final Function(Register1 value)registerObject;
  Map<String, dynamic> userPayload;
  var bvn;
  RegisterStage4({this.registerObject, this.controller, this.userPayload, this.bvn});
  @override
  _RegisterStage4State createState() => _RegisterStage4State();
}

class _RegisterStage4State extends State<RegisterStage4> {
  AppState appState;
  bool isVisiblePassword = true;
  bool isVisiblePassword2 = true;
  LoginState loginState;
Register1 register1;
  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var bvn;
  Map<String, dynamic> userPayload = {};

  @override
  void initState() {
    userPayload = widget.userPayload;
    bvn = widget.bvn;
    super.initState();
  }

@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);
    loginState = Provider.of<LoginState>(context);

    print(userPayload);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              child: Column(
                children: [
                  CustomTextField(
                    obscureText: isVisiblePassword,
                    onTap: () {
                      setState(() {
                        isVisiblePassword = !isVisiblePassword;
                      });
                    },
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return " Password is required";
                      }
                      return null;
                    },
                    header: "Password",
                    hint: "******",

                   textEditingController: password,
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

                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    obscureText: isVisiblePassword2,
                    validator: (value) {
                    if(value.isEmpty)
                      return 'Empty';
                    if(value != password.text)
                      return 'Passwords do Not Match';
                      // widget.onPassPayload(password.text);

                    return null;
                                },
                    header: "Confirm Password",
                    hint: "******",
                    suffix: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isVisiblePassword2 = !isVisiblePassword2;
                            });
                          },
                          child: Text(
                            isVisiblePassword2 ? "HIDE" : "SHOW",
                            style: TextStyle(fontSize: 10, color: cyan),
                          ),
                        ),

                      ],
                    ),
                  ),
                    // SizedBox(height: 30),
                  Spacer(),
                  Container(
                    // padding: EdgeInsets.symmetric(horizontal: 25),
                    child: CustomButton(
                      onPressed:  () async {


                        // if(widget.index == 1 ){
                          if(_formKey.currentState.validate()){
                            register(context);
                        }
                        // }else if(index == 1){
                        //   if(_formKey.currentState.validate()){
                        //     setState(() {
                        //       index ++;
                        //     });
                        //     await controller.nextPage(
                        //       duration: Duration(milliseconds: 500),
                        //       curve: Curves.easeOutExpo,
                        //     );
                        //   }
                        // }else if(index == 2){
                        //   if(_formKey.currentState.validate()){
                        //     print(_formKey.currentState.validate());
                        //     register(context);
                        //
                        //   }
                        // }else if (index == 3) {
                        //   if(passcode != null){
                        //     createPassCode(passcode);
                        //   }
                        // }
                        // else if (index ==4){
                        //   if(passcode != null){
                        //     createPassCode(passcode);
                        //   }
                        // }





                        //Check index to know the endpoint to call
                        // if (controller.page == 4) {
                        //
                        // }
                        // else if (controller.page ==  1) {
                        //
                        //     FocusScope.of(context).requestFocus(FocusNode());
                        // }


                      },
                      text:  "Next",
                      showArrow: true,
                      color: cyan,
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // register(context) async {
  //   print("call me");
  //   // print(userPayload);
  //   // print(passcode);
  //   // print(bvn);
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return Preloader();
  //       });
  //   var result  = await loginState.register1(email:email.text, firstName: firstname.text, lastName:lastname.text, phone: phone.text, preferredPhone: preferredPhone.text, bvn: widget.bvn , password: password);
  //   Navigator.pop(context);
  //   if(result["error"] == false){
  //     register1 = result["res"];
  //
  //     await widget.controller.nextPage(
  //       duration: Duration(milliseconds: 500),
  //       curve: Curves.easeOutExpo,
  //     );
  //     print("here");
  //   }else{
  //
  //     // CommonUtils.kShowSnackBar(body:result["message"] ?? "Error", context: context,  snackColor: Colors.red );
  //
  //   }
  //
  // } // giv



  register(context) async {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });



    var result  = await loginState.register1(email: userPayload["email"], firstName: userPayload["firstname"], lastName: userPayload["lastname"],  phone: userPayload["phone"], bvn: bvn , password: password.text);
    Navigator.pop(context);
    if(result["error"] == false){
      register1 = result["res"];
      widget.registerObject(register1);
      await widget.controller.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOutExpo,
      );
      print("here");
    }else{
      CommonUtils.kShowSnackBar(ctx: context, msg: result["message"], color: Colors.red);
      // CommonUtils.showMsg(body:result["message"] ?? "Error", context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );

    }

  }

}
