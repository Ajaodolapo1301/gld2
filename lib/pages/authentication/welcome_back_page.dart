import 'package:after_layout/after_layout.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glade_v2/firebase_notification/remote_config.dart';
import 'package:glade_v2/pages/authentication/login_page.dart';
import 'package:glade_v2/pages/authentication/recover_your_pin_page.dart';
import 'package:glade_v2/pages/authentication/reset_pin.dart';
import 'package:glade_v2/pages/dashboard/dashboard_page.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:glade_v2/utils/widgets/number_button_view.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:store_redirect/store_redirect.dart';

class WelcomeBackPage extends StatefulWidget {
  @override
  _WelcomeBackPageState createState() => _WelcomeBackPageState();
}

class _WelcomeBackPageState extends State<WelcomeBackPage> with AfterLayoutMixin<WelcomeBackPage> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  LoginState loginState;
  BusinessState addBusnessState;
  RemoteConfigService _remoteConfigService;
  initializeRemoteConfig() async {
    _remoteConfigService = await RemoteConfigService.getInstance();
    await _remoteConfigService.initialize();
      checkConfig(context, _remoteConfigService.remoteConfig);
  }


  @override
  void initState() {
    initializeRemoteConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loginState = Provider.of<LoginState>(context);
    addBusnessState = Provider.of<BusinessState>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Column(
            children: [
              Image.asset(
                "assets/images/logo.png",
                height: 60,
              ),
              SizedBox(height: 10),
              Text(
                "Welcome Back",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: blue, fontSize: 24.5, fontWeight: FontWeight.bold),
              ),
              Text(
                "${loginState.user.firstname} ${loginState.user.lastname}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: blue,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Enter 4 digit passcode to continue",
                style: TextStyle(color: blue, fontSize: 13),
              ),
              SizedBox(height: 40),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          4,
                          (index) {
                            return AnimatedContainer(
                              height: 15,
                              width: 15,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: otp.length > index ? blue : Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: blue, width: 2),
                              ),
                              duration: Duration(milliseconds: 100),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 30),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 20,
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    numberButton(number: "1"),
                                    numberButton(number: "2"),
                                    numberButton(number: "3"),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    numberButton(number: "4"),
                                    numberButton(number: "5"),
                                    numberButton(number: "6"),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    numberButton(number: "7"),
                                    numberButton(number: "8"),
                                    numberButton(number: "9"),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IgnorePointer(
                                      child: numberButton(number: ""),
                                      ignoring: true,
                                    ),
                                    numberButton(number: "0"),
                                    numberButton(
                                        number: "<",
                                        preferredColor: orange,
                                        preferredSize: 35),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Forgot PIN ?",
                              style: TextStyle(
                                color: blue,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {

                              resetPin();
                              },
                              child: Text(
                                " Reset",
                                style: TextStyle(
                                  color: orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Not you?",
                              style: TextStyle(
                                color: blue,
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                pushTo(context, LoginPage());
                              },
                              child: Text(
                                " Login to another account",
                                style: TextStyle(
                                  color: blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String otp = "";

  Widget numberButton({
    String number,
    Color preferredColor,
    double preferredSize,
  }) {
    return NumberButtonView(
      number: number,
      preferredColor: preferredColor,
      preferredSize: preferredSize,
      onTap: () async {
        setState(
          () {
            if (number == "<") {
              if (otp.isNotEmpty) {
                otp = otp.substring(0, otp.length - 1);
              }
            } else {
              if (otp.length != 4) {
                otp += number;
                if (otp.length == 4) {
//                  Future.delayed(Duration(milliseconds: 100)).then((value) {
            verifyPasscode();
//                  });
                }
              }
            }
          },
        );
      },
    );
  }



  resetPin() async {
    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result = await loginState.ChangePin1(token: loginState.user.token);
    Navigator.pop(context);

    if (result["error"] == false) {

      CommonUtils.showMsg(body: result["message"] ?? "tt",
          context: context,
          scaffoldKey: _scaffoldKey,
          snackColor: Colors.green);

      Future.delayed(const Duration(milliseconds: 500), () {

        pushTo(context, ResetYourPinPage());
      });


    } else {
      CommonUtils.showMsg(body: result["message"] ?? "tt",
          context: context,
          scaffoldKey: _scaffoldKey,
          snackColor: Colors.red);
    }
  }



  verifyPasscode() async{
    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result = await loginState.verifyPasscode(token: loginState.user.token, passcode: otp);

    if(result["error"] == false){
        if(loginState.user.business_uuid != null){

          //get business details if User has business
          var result2 = await addBusnessState.getBusiness(token: loginState.user.token,business_uuid: loginState.user.business_uuid );
          Navigator.pop(context);
                  if(result2["error"] == false){
                    pushToAndClearStack(context, DashboardPage());
                  }

        }

        pushToAndClearStack(context, DashboardPage());
    }else if(result["error"] == true && result["statusCode"] == 401){
      CommonUtils.showMsg(body: result["message"]  ?? 'tt', context: context, scaffoldKey: _scaffoldKey,snackColor : Colors.red );
      Future.delayed(Duration(milliseconds: 500)).then((value) {
        pushToAndClearStack(context, LoginPage());
      });
    }

    else {
      pop(context);
      setState(() {
        otp = otp.substring(0, otp.length - 4);
      });
      CommonUtils.showMsg(body: result["message"]  ?? 'tt', context: context, scaffoldKey: _scaffoldKey,snackColor : Colors.red );
    }

  }









  void showAndroidUpdateDialog(BuildContext context, bool mandatory) {
    showDialog(context: context,
        barrierDismissible: !mandatory,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              return !mandatory;
            },
            child: AlertDialog(
              contentPadding: const EdgeInsets.only(
                  bottom: 10, left: 20, right: 20, top: 10),
              title: Text("New Version Available"),
              content: Text(
                  "Your version of Glade mobile app is currently outdated, Please visit android store to get the latest version"),
              actions: <Widget>[
                (mandatory) ? Container() :
                FlatButton(child: Text("Later"),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },),
                FlatButton(
                  child: Text("Update Now"), onPressed: () {
                  StoreRedirect.redirect(
                      androidAppId: SystemProperties.appPackageAndroid,
                      iOSAppId: SystemProperties.appIDIOS);
                },),
              ],
            ),
          );
        });
    print("mandatory comimg from the back $mandatory");
  }

  void showIOSUpdateDialog(BuildContext context, bool mandatory) {
    showDialog(context: context,
        barrierDismissible: !mandatory,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              return !mandatory;
            },
            child: CupertinoAlertDialog(
              title: Text("New Version Available"),
              content: Text(
                  "Your version of Glade mobile app is currently outdated. Please visit Apple store to get the latest version"),
              actions: <Widget>[
                (mandatory) ? Container() :
                FlatButton(child: Text("Later"),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },),
                FlatButton(child: Text("Update Now"), onPressed: () {
                  StoreRedirect.redirect(
                      androidAppId: SystemProperties.appPackageAndroid,
                      iOSAppId: SystemProperties.appIDIOS);
                },),
              ],
            ),
          );
        });
  }


  Future<bool> checkConfig(BuildContext context, RemoteConfig config) async {


    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String buildnum = packageInfo.buildNumber;

    String version = "${packageInfo.version.trim().replaceAll(".", "")}$buildnum";
    // String versionIos = "${packageInfo.version.trim().replaceAll(".", "")}";

    if (Theme
        .of(context)
        .platform == TargetPlatform.android) {
      String currentVersion = config.getString("current_android_version")
          .trim()
          .replaceAll(".", "")
          .replaceAll("+", "");
      // String currentIOsVersion = config.getString("current_ios_version")
      //     .trim()
      //     .replaceAll(".", "")
      //     .replaceAll("+", "");


      bool isMandatory = config.getBool("android_update_mandatory");


      if(!isUserAppCurrent(version,currentVersion)){
        // show dialog
        print(" version$version");
        print("currentVersion $currentVersion");
        print(isUserAppCurrent(version,currentVersion));
        showAndroidUpdateDialog(context, isMandatory);
      }


    }
    else if (Theme
        .of(context)
        .platform == TargetPlatform.iOS) {
      bool isMandatory = config.getBool("ios_update_mandatory");
      String currentIOsVersion = config.getString("current_ios_version")
          .trim()
          .replaceAll(".", "")
          .replaceAll("+", "");
//    if (!config.getBool("ios_active")) {
//      if(Provider.of(context).appConfig['showingPopUP']??false){
//        return false;
//      }
//      showIOSExitDialog(context, Provider.of(context).remote.getString("ios_deactivation_msg"));
//      return false;
//    }


      print("$isMandatory iosMand");
      print("$currentIOsVersion currentIos");

      print("${int.parse(version)} versin again");


      if(!isUserAppCurrent(version,currentIOsVersion )){
        // show dialog
        showIOSUpdateDialog(context, isMandatory);
      }
    }
    return true;
  }

  bool isUserAppCurrent(String deviceVersion, String firebaseVersion){
    List deviceList = deviceVersion.split(".");
    List firebaseList = firebaseVersion.split(".");


    var unionLength = firebaseList.length>deviceList.length?firebaseList.length:deviceList.length;

    for(var i = 0; i < unionLength; i++){

      if(deviceList.length-1 < i){
        return false;
      }
      if(firebaseList.length-1 < i){
        return true;
      }

      if(int.parse(firebaseList[i]) > int.parse(deviceList[i])){
        return false;
      }

      if(int.parse(firebaseList[i]) == int.parse(deviceList[i]) && i == unionLength-1){
        return true;
      }
    }

    return false;
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // initializeRemoteConfig();
  }


}
