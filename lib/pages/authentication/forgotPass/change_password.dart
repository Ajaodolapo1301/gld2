
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:glade_v2/pages/authentication/login_page.dart';
import 'package:glade_v2/pages/settings/settings_page.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {



  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  AppState appState;
  var password;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  LoginState loginState;
 bool isVisiblePassword = false;
  bool isVisiblePassword1 = false;
 var  newpasssword;
 var oldPassword;

  final FocusNode newpassswordNode = FocusNode();
  final FocusNode oldPasswordNode = FocusNode();
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
                Header(
                  preferredActionOnBackPressed: (){
                  pop(context);

                  },
                  text: "",
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Change Password!",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: blue,
                              fontSize: 21),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Change your password",
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
                            focusNode: oldPasswordNode,
                            textActionType: ActionType.next,
                            header: "Enter Current Password",
                            hint: "******",
                            obscureText: !isVisiblePassword,
                            onSubmit: (value){
                            _fieldFocusChange(context, oldPasswordNode, newpassswordNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Password  shouldn't be empty";
                              }
                              oldPassword = value;

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
                          CustomTextField(
                            focusNode: newpassswordNode,
                            textActionType: ActionType.next,
                            header: "Enter new Password",
                            hint: "******",
                            obscureText: !isVisiblePassword1,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Password  shouldn't be empty";
                              }
                              newpasssword = value;
                              return null;
                            },
                            onSubmit: (value){
                             newpassswordNode.unfocus();
                             if(_formKey.currentState.validate()){
                               changePassword();

                             }

                            },

                            suffix: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isVisiblePassword1 = !isVisiblePassword1;
                                    });
                                  },
                                  child: Text(
                                    isVisiblePassword1 ? "HIDE" : "SHOW",
                                    style: TextStyle(fontSize: 10, color: cyan),
                                  ),
                                ),
                                SizedBox(width: 8),

                              ],
                            ),
                          ),
                          SizedBox(height: 30),
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
                      print(oldPassword);
                      print(newpasssword);
                    changePassword();
                    }

                  },
                  text:"Change",
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

//
//  (){
//  pushToAndClearStack(context, (SettingsPage(
//
//  )),);
//  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  changePassword() async {
    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result = await loginState.changePassword(token: loginState.user.token, newPassword: newpasssword, currentPassword: oldPassword);
    Navigator.pop(context);

    if (result["error"] == false) {
  setState(() {
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

  });
    } else {
      CommonUtils.showMsg(body: result["message"] ?? "tt",
          context: context,
          scaffoldKey: _scaffoldKey,
          snackColor: Colors.red);
    }
  }
}
