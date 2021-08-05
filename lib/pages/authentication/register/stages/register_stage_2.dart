import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glade_v2/core/models/apiModels/Auth/bvn.dart';
import 'package:glade_v2/core/models/apiModels/Auth/register.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:provider/provider.dart';

class RegisterStage2 extends StatefulWidget {
  final Function(Map<String, dynamic> value) onUserPayload;
  PageController controller;
  int index;
  var bvn;
  BVNModel bvnModel;
  RegisterStage2(
      {this.onUserPayload,
      this.bvnModel,
      this.controller,
      this.index,
      this.bvn});

  @override
  _RegisterStage2State createState() => _RegisterStage2State();
}

class _RegisterStage2State extends State<RegisterStage2> {
  Register1 register1;
  AppState appState;
  LoginState loginState;
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController preferredPhone = TextEditingController();
  TextEditingController email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Timer _debounce;
  bool isCheckloading = false;
  bool emailAvailable;
  @override
  void initState() {
    // firstname.text = widget.bvnModel.firstname;
    // lastname.text = widget.bvnModel.lastname;
    // phone.text = widget.bvnModel.phone;
    super.initState();
  }

  _onSearchChanged(String query) {
    print(query);
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 1500), () {
      if (query.isNotEmpty) {
        checkEmail(query);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.index);
    loginState = Provider.of<LoginState>(context);
    appState = Provider.of<AppState>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Form(
        key: _formKey,
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
                        "Hello!\nWelcome.",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: blue,
                            fontSize: 21),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Create  a New Account in minutes by telling us about yourself.",
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
                children: [
                  CustomTextField(
                    textEditingController: firstname,
                    header: "First name",
                    hint: "Josteve",
                    onChanged: (String value) {
                      setState(() {});
                    },
                    type: FieldType.text,
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return "First name is required";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    textEditingController: lastname,
                    header: "Last name",
                    hint: "Adekanbi",
                    onChanged: (String value) {
                      setState(() {});
                    },
                    type: FieldType.text,
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return "Last name is required";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    textEditingController: email,
                    header: "Email Address",
                    suffix: emailAvailable == null
                        ? SizedBox()
                        : isCheckloading
                            ? CupertinoActivityIndicator()
                            : emailAvailable
                                ? CommonUtils.checkMArk()
                                : !emailAvailable
                                    ? CommonUtils.checkCancel()
                                    : Container(),
                    hint: "josteve@xyz.ng",
                    onChanged: _onSearchChanged,
                    type: FieldType.email,
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return "Email is required";
                      } else if (!EmailValidator.validate(
                          value.replaceAll(" ", "").trim())) {
                        return "Email is invalid";
                      }
                      return null;
                    },
                  ),
                  emailAvailable == null
                      ? SizedBox()
                      : Text(
                          emailAvailable
                              ? "No existing user with email"
                              : "Email already used by someone else",
                          style: TextStyle(
                              color: emailAvailable ? Colors.green : Colors.red,
                              fontSize: 9)),
                  SizedBox(height: 15),
                  // CustomTextField(
                  //   type: FieldType.phone,
                  //   textInputFormatters: [
                  //     WhitelistingTextInputFormatter.digitsOnly,
                  //     new LengthLimitingTextInputFormatter(11),
                  //   ],
                  //   textEditingController: phone,
                  //   header: "Phone Number",
                  //   hint: "0800000000000",
                  //   onChanged: (String value) {
                  //     setState(() {});
                  //   },
                  //   validator: (value) {
                  //     if (value.trim().isEmpty) {
                  //       return "Phone number is required";
                  //     }
                  //     return null;
                  //   },
                  // ),
                  // SizedBox(height: 15),
                  CustomTextField(
                    textEditingController: phone,
                    type: FieldType.phone,
                    textInputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      new LengthLimitingTextInputFormatter(11),
                    ],
                    header: "Phone Number",
                    hint: "0800000000000",
                    onChanged: (String value) {
                      setState(() {
                      });
                    },
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return "Phone number is required";
                      }
                      widget.onUserPayload({
                        "firstname": firstname.text,
                        "lastname": lastname.text,
                        "email": email.text,
                        "phone": phone.text
                      });

                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  Container(
                    // padding: EdgeInsets.symmetric(horizontal: 25),
                    child: CustomButton(
                      onPressed: () async {
                        // if(widget.index == 1 ){
                        if (_formKey.currentState.validate() &&
                            emailAvailable) {
                          widget.controller.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeOutExpo,
                          );
                        } else {
                          CommonUtils.kShowSnackBar(
                              color: Colors.red,
                              ctx: context,
                              msg: "Fix input errors");
                        }

                      },
                      text: "Next",
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
  //   var result = await loginState.register1(
  //       email: email.text,
  //       firstName: firstname.text,
  //       lastName: lastname.text,
  //
  //       phone: preferredPhone.text,
  //       bvn: widget.bvn,
  //       password: password);
  //   Navigator.pop(context);
  //   if (result["error"] == false) {
  //     register1 = result["res"];
  //
  //     await widget.controller.nextPage(
  //       duration: Duration(milliseconds: 500),
  //       curve: Curves.easeOutExpo,
  //     );
  //     print("here");
  //   } else {
  //     CommonUtils.kShowSnackBar(ctx: context, msg: result["message"]);
  //     // CommonUtils.kShowSnackBar(body:result["message"] ?? "Error", context: context,  snackColor: Colors.red );
  //
  //   }
  // } // giv u OTP

  checkEmail(email) async {
    setState(() {
      isCheckloading = true;
    });
    var result = await loginState.checkEmail(email: email);
    setState(() {
      isCheckloading = false;
    });
    if (result["error"] == false) {
      setState(() {
        emailAvailable = true;
      });
    } else {
      setState(() {
        emailAvailable = false;
      });
    }
  }
}
