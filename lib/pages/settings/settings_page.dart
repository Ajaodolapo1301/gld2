import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glade_v2/pages/authentication/forgotPass/change_password.dart';
import 'package:glade_v2/pages/authentication/recover_your_pin_page.dart';
import 'package:glade_v2/pages/personal/go_live/go_live_personal_page.dart';
import 'package:glade_v2/pages/settings/hide_account_balance_page.dart';
import 'package:glade_v2/pages/settings/increase_limits_page.dart';
import 'package:glade_v2/pages/settings/merchant_credentials_page.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:local_auth/local_auth.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'change_font_size_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  LoginState loginState;
  double textScale = 1.0;
  void initTextScale() async {
    var pref = await SharedPreferences.getInstance();
    setState(() {
      textScale = pref.getDouble("textScaleFactor") ?? 1.0;
    });
  }
  bool fingerprintLogin = false;

  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  SharedPreferences pref;

  void printLoginInit() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      fingerprintLogin = pref.getBool("printLogin") ?? false;

    });
  }
  @override
  void initState() {
initTextScale();
printLoginInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loginState = Provider.of<LoginState>(context);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: textScale),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 10),
                Header(
                  text: "Settings",
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: (){
                 loginState.user.compliance_status == "approved"   ?    toast("You are already activated") :        loginState.user.compliance_status == "pending" ?   toast("Your application is pending") :
                 pushTo(context, GoLivePage());
                  },
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Activate Account(Personal)",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: blue,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              "Activate your Account for Transactions",
                              style: TextStyle(
                                color: blue,
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(

                            Icons.verified_rounded,
                            color: loginState.user.compliance_status == "approved" ? Colors.green :  loginState.user.compliance_status == "pending" ? Colors.amber:  Colors.grey,
                          ),
                          onPressed: () {},
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: lightBlue,
                        border: Border.all(color: borderBlue.withOpacity(0.09))),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    children: [
                      // buildListTile(
                      //   title: "Increase Limits",
                      //   subTitle: "Increase Transaction Limit",
                      //   onTap: () {
                      //     pushTo(context, IncreaseLimitsPage());
                      //   },
                      // ),
                      divider(),
                      buildListTile(
                        title: "Security",
                        subTitle: "Sign in with Biometrics",
                        onTap: () {},
                        preferredTrailing: Transform(
                          transform: Matrix4.identity()..scale(0.5)..translate(70.0, 20),
                          child: CupertinoSwitch(
                            value: fingerprintLogin,
                            onChanged: (value) async{
                              if (value) {
                                await _checkBiometrics();
                                if (_canCheckBiometrics) {
                                  await _getAvailableBiometrics();
                                  if (_availableBiometrics
                                      .isNotEmpty) {
                                    setState(() {
                                      pref.setBool(
                                          "printLogin", value);
                                      fingerprintLogin = value;
                                    });
                                  } else {
                                    Scaffold.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          "Fingerprint not supported"),
                                    ));
                                  }
                                } else {
                                  Scaffold.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        "Fingerprint not supported"),
                                  ));
                                }
                              } else {
                                setState(() {
                                  pref.setBool("printLogin", value);
                                  fingerprintLogin = value;
                                });
                              }
                            },
                            activeColor: cyan,
                          ),
                        ),
                      ),
                      divider(),
                      buildListTile(
                        title: "Hide my Account Balance",
                        subTitle: "Prevent Intruders from Snooping",
                        onTap: () {
                          pushTo(context, HideAccountBalancePage());
                        },
                      ),
                      divider(),
                      buildListTile(
                        title: "Merchant Credentials",
                        subTitle: "See Credentials and Referral Code",
                        onTap: () {
                          pushTo(context, MerchantCredentialsPage());
                        },
                      ),
                      divider(),
                      buildListTile(
                        title: "Knight Mode",
                        subTitle: "Change App theme to Dark mode",
                        onTap: () {},
                        preferredTrailing: Transform(
                          transform: Matrix4.identity()..scale(0.5)..translate(70.0, 20),
                          child: CupertinoSwitch(
                            value: true,
                            onChanged: (value) {},
                            activeColor: cyan,
                          ),
                        ),
                      ),
                      divider(),
                      buildListTile(
                        title: "Change Password",
                        subTitle: "Forgot password, click here to reset.",
                        onTap: () {
                          pushTo(context, ChangePassword());
                        },
                      ),
                      divider(),
                      buildListTile(
                        title: "Recover Pin",
                        subTitle: "Forgot pin, click here to reset.",
                        onTap: () {
                          pushTo(context, RecoverYourPinPage());
                        },
                      ),
                      divider(),
                      buildListTile(
                        title: "Change Text Size",
                        subTitle: "",
                        onTap: () {
                          pushTo(context, ChangeFontSizePage());
                        },
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container divider() => Container(
        height: 1,
        width: double.maxFinite,
        color: Colors.grey[100],
      );

  ListTile buildListTile(
      {@required String title,
      @required String subTitle,
      Widget preferredTrailing,
      @required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      title: Text(
        "$title",
        style: TextStyle(
          color: blue,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      trailing: preferredTrailing ??
          Icon(
            Icons.arrow_forward_ios,
            size: 12,
          ),
      subtitle: Text(
        "$subTitle",
        style: TextStyle(color: blue, fontSize: 12),
      ),
    );
  }




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
  }


}
