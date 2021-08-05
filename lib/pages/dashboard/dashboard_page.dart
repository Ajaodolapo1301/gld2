import 'dart:async';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:glade_v2/core/constants.dart';
import 'package:glade_v2/pages/authentication/welcome_back_page.dart';
import 'package:glade_v2/pages/dashboard/portions/cards_portion.dart';
import 'package:glade_v2/pages/dashboard/portions/home/home_portion.dart';
import 'package:glade_v2/pages/dashboard/portions/more_portion.dart';
import 'package:glade_v2/pages/dashboard/portions/send/send_portion.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with WidgetsBindingObserver {
  int currentIndex = 0;
  PageController pageController = PageController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AccountState accountState;
  Timer _timer;
AppState appState;
  double textScale = 1.0;
  void initTextScale() async {
    var pref = await SharedPreferences.getInstance();
    setState(() {
      textScale = pref.getDouble("textScaleFactor") ?? 1.0;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    initTextScale();

    super.initState();
  }




  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: textScale),
      child: Scaffold(

        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: PageView(
            controller: pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              HomePortion(
                onClickFundTransfer: (){
                  setState(() {
                    currentIndex++;
                    pageController.animateToPage(
                      currentIndex,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.ease,
                    );
                  });
                },
                pageController: pageController,
                getAccount: (accountState){
                  setState(() {
                    this.accountState = accountState;
                  });
                },
              ),
              SendPortion(),
              CardsPortion(),
              MorePortion(
                accountState: accountState,
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: blue,
          unselectedItemColor: blue.withOpacity(0.35),
          onTap: (v) {
            setState(() {

              currentIndex = v;
              pageController.animateToPage(
                currentIndex,
                duration: Duration(milliseconds: 200),
                curve: Curves.ease,
              );
            });
          },
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Transform.translate(
                offset: Offset(4, -2.5),
                child: Transform.rotate(
                  angle: 5.5,
                  child: Icon(Icons.send_rounded),
                ),
              ),
              label: "Send",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.credit_card_rounded),
              label: "Cards",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz_rounded),
              label: "More",
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    try {
      setState(() {});
      print("LifeState: $state");
      if (state == AppLifecycleState.paused && !appState.selectingFile) {
        _timer = Timer(Duration(minutes: 10), () {
          if (state == AppLifecycleState.paused) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        WelcomeBackPage(

                        )),
                    (route) => false);
          }
          _timer.cancel();
        });
      }
      if (state == AppLifecycleState.resumed) {
        appState.selectingFile = false;
      }
    } catch (e) {}
  }


  Future<RemoteConfig> setupRemoteConfig() async {
    print("tttt remote config");


    final RemoteConfig remoteConfig = await RemoteConfig.instance;
//  String msg ="Dear Customer, Our services are unavailable at the moment. please contact support for more information.";

    remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: false));

    try {

      await remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await remoteConfig.activateFetched();
      await remoteConfig.notifyListeners();
      await remoteConfig.getBool("android_active");
      await remoteConfig.getString("current_android_version");


      remoteConfig.setDefaults(<String, dynamic>{
        'current_ios_version': '1.0.0',
        'current_android_version': '1.0.0',
        'ios_active': true,
        'android_active': true,
        'android_update_mandatory': true,
        'ios_update_mandatory': true,
      });
      print("$remoteConfig remote cong");
      return remoteConfig;
    } catch (e) {
      print(e);
      return null;
    }
  }





//   void showAndroidUpdateDialog(BuildContext context, bool mandatory) {
//     showDialog(context: context,
//         barrierDismissible: !mandatory,
//         builder: (context) {
//           return WillPopScope(
//             onWillPop: () async {
//               return !mandatory;
//             },
//             child: AlertDialog(
//               contentPadding: const EdgeInsets.only(
//                   bottom: 10, left: 20, right: 20, top: 10),
//               title: Text("New Version Available"),
//               content: Text(
//                   "Your version of Glade mobile app is currently outdated, Please visit android store to get the latest version"),
//               actions: <Widget>[
//                 (mandatory) ? Container() :
//                 FlatButton(child: Text("Later"),
//                   onPressed: () {
//                     Navigator.of(context, rootNavigator: true).pop();
//                   },),
//                 FlatButton(
//                   child: Text("Update Now"), onPressed: () {
//                   StoreRedirect.redirect(
//                       androidAppId: SystemProperties.appPackageAndroid,
//                       iOSAppId: SystemProperties.appIDIOS);
//                 },),
//               ],
//             ),
//           );
//         });
//     print("mandatory comimg from the back $mandatory");
//   }
//
//   void showIOSUpdateDialog(BuildContext context, bool mandatory) {
//     showDialog(context: context,
//         barrierDismissible: !mandatory,
//         builder: (context) {
//           return WillPopScope(
//             onWillPop: () async {
//               return !mandatory;
//             },
//             child: CupertinoAlertDialog(
//               title: Text("New Version Available"),
//               content: Text(
//                   "Your version of Glade mobile app is currently outdated. Please visit Apple store to get the latest version"),
//               actions: <Widget>[
//                 (mandatory) ? Container() :
//                 FlatButton(child: Text("Later"),
//                   onPressed: () {
//                     Navigator.of(context, rootNavigator: true).pop();
//                   },),
//                 FlatButton(child: Text("Update Now"), onPressed: () {
//                   StoreRedirect.redirect(
//                       androidAppId: SystemProperties.appPackageAndroid,
//                       iOSAppId: SystemProperties.appIDIOS);
//                 },),
//               ],
//             ),
//           );
//         });
//   }
//
//
//   Future<bool> checkConfig(BuildContext context, AppState appState) async {
//     print("popping dialog");
//
//
//     PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     String buildnum = packageInfo.buildNumber;
//
//     String version = "${packageInfo.version.trim().replaceAll(
//         ".", "")}$buildnum";
//     String versionIos = "${packageInfo.version.trim().replaceAll(".", "")}";
//     if (Theme.of(context).platform == TargetPlatform.android) {
//       String currentVersion = config.getString("current_android_version")
//           .trim()
//           .replaceAll(".", "")
//           .replaceAll("+", "");
//       String currentIOsVersion = config.getString("current_ios_version")
//           .trim()
//           .replaceAll(".", "")
//           .replaceAll("+", "");
//
// //    print("currentV${currentVersion.trim().replaceAll(".", "").replaceAll(
// // //        "+", "")}");
// //       print(" curret${currentIOsVersion}");
// //       print("userV$version}");
// //       print("IosV$versionIos}");
//
//
//       bool isMandatory = config.getBool("android_update_mandatory");
//
//       // if(!config.getBool("android_active")){
//       //   if(Provider.of(context).appConfig['showingPopUP']??false){
//       //     return false;
//       //   }
//       //   Provider.of(context).appConfig['showingPopUP'] = true;
//       //   showAndroidExitDialog(context,Provider.of(context).remote.getString("ios_deactivation_msg"));
//       //   return false;
//       // }
//
//
//       if(!isUserAppCurrent(version,currentVersion)){
//         // show dialog
//
//         print(" version$version");
//         print("currentVersion $currentVersion");
//         print(isUserAppCurrent(version,currentVersion));
//         showAndroidUpdateDialog(context, isMandatory);
//       }
//
//       // if (int.parse(currentVersion) > int.parse(version)) {
//       //   // show dialog
//       //   print("current status $isMandatory");
//       //     print(" currentVersione $currentVersion");
//       //   print(" versione$version");
//       //   showAndroidUpdateDialog(context, isMandatory);
//       // }
//     }
//     else if (Theme
//         .of(context)
//         .platform == TargetPlatform.iOS) {
//       bool isMandatory = config.getBool("ios_update_mandatory");
//       String currentIOsVersion = config.getString("current_ios_version")
//           .trim()
//           .replaceAll(".", "")
//           .replaceAll("+", "");
// //    if (!config.getBool("ios_active")) {
// //      if(Provider.of(context).appConfig['showingPopUP']??false){
// //        return false;
// //      }
// //      showIOSExitDialog(context, Provider.of(context).remote.getString("ios_deactivation_msg"));
// //      return false;
// //    }
//
//
//       // print("$isMandatory iosMand");
//       // print("$currentIOsVersion currentIos");
//       // print("${int.parse(versionIos)} vers");
//       // print("${int.parse(version)} versin again");
//
//
//       // if (int.parse(currentIOsVersion) > int.parse(version)) {
//       //   // show dialog
//       //   showIOSUpdateDialog(context, isMandatory);
//       // }
//       if(!isUserAppCurrent(version,versionIos )){
//
//         // show dialog
//         //   showIOSUpdateDialog(context, isMandatory);
//       }
//     }
//     return true;
//   }
//
//   bool isUserAppCurrent(String deviceVersion, String firebaseVersion){
//     List deviceList = deviceVersion.split(".");
//     List firebaseList = firebaseVersion.split(".");
//
//
//     var unionLength = firebaseList.length>deviceList.length?firebaseList.length:deviceList.length;
//
//     for(var i = 0; i < unionLength; i++){
//
//       if(deviceList.length-1 < i){
//         return false;
//       }
//       if(firebaseList.length-1 < i){
//         return true;
//       }
//
//       if(int.parse(firebaseList[i])> int.parse(deviceList[i])){
//         return false;
//       }
//
//       if(int.parse(firebaseList[i]) == int.parse(deviceList[i]) && i == unionLength-1){
//         return true;
//       }
//     }
//
//     return false;
//   }

}


