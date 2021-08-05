import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:device_info/device_info.dart';
import 'package:device_preview/device_preview.dart';

// import 'package:device_preview/device_preview.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glade_v2/core/models/apiModels/Auth/Business.dart';
import 'package:glade_v2/firebase_notification/remote_config.dart';
import 'package:glade_v2/pages/authentication/psedoPage.dart';
import 'package:glade_v2/pages/splash_page.dart';
import 'package:glade_v2/provider/Business/accountStatement.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/Business/fundTransferState.dart';
import 'package:glade_v2/provider/Business/increaseLimitState.dart';
import 'package:glade_v2/provider/Business/invoiceState.dart';
import 'package:glade_v2/provider/Business/loanAndOverdraftState.dart';
import 'package:glade_v2/provider/Business/paymentLinkState.dart';
import 'package:glade_v2/provider/Business/virtualCardState.dart';
import 'package:glade_v2/provider/Personal/budgetState.dart';
import 'package:glade_v2/provider/Personal/fundAccountState.dart';
import 'package:glade_v2/provider/Personal/goliveState.dart';
import 'package:glade_v2/provider/Personal/posState.dart';
import 'package:glade_v2/provider/Personal/reserveState.dart';
import 'package:glade_v2/provider/Personal/withdrawalState.dart';
import 'package:glade_v2/provider/airtimeAndBills.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';

import 'package:glade_v2/utils/functions/dev_utils.dart';
import 'package:hive/hive.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camera/camera.dart';

import 'core/models/apiModels/Auth/user.dart';
import 'firebase_notification/NotificationsManager.dart';
import 'pages/authentication/login_page.dart';

import 'pages/authentication/register/stages/createPasscode.dart';

import 'pages/authentication/welcome_back_page.dart';
import 'pages/onboard_page.dart';
import 'utils/navigation/navigator.dart';
List<CameraDescription> cameras;
Future <void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();

  Hive.init(appDocumentDirectory.path);
  var box;
  Hive.registerAdapter(UserAdapter());

  Hive.registerAdapter(BusinessAdapter());






  await Hive.openBox("user");
box = Hive.box("user");
  User user = box.get('user', defaultValue: null);


  await Hive.openBox("business");
  box = Hive.box("business");
  Business business = box.get('business', defaultValue: null);
  bool hasUserUsedApp = false;




  runApp(
      DevicePreview(
          enabled: false,
          builder: (context) =>
              MultiProvider(
                providers: [
                  ChangeNotifierProvider(create: (_) => AppState()),
                  ChangeNotifierProvider(create: (_) => LoginState(user)),
                  ChangeNotifierProvider(create: (_) => LoanAndOverdraftState()),
                  ChangeNotifierProvider(create: (_) => InvoiceState()),
                  ChangeNotifierProvider(create: (_) => FundTransferState()),
                  ChangeNotifierProvider(create: (_) => IncreaseLimitState()),
                  ChangeNotifierProvider(create: (_) => PaymentLinkState()),
                  ChangeNotifierProvider(create: (_) => VirtualCardState()),
                  ChangeNotifierProvider(create: (_) => BudgetState()),
                  ChangeNotifierProvider(create: (_) => FundAccountState()),
                  ChangeNotifierProvider(create: (_) => GoLIveState()),
                  ChangeNotifierProvider(create: (_) => POSState()),
                  ChangeNotifierProvider(create: (_) => AirtimeAndBillsState()),
                  ChangeNotifierProvider(create: (_) => WithdrawalState()),
                  ChangeNotifierProvider(create: (_) => ReserveState()),
                  ChangeNotifierProvider(create: (_) => BusinessState(business)),
                  ChangeNotifierProvider(create: (_) => AccountStatementState()),
                ],
                  child: MyApp(
                    user: user,
                      // firstTimeUser: hasUserUsedApp
                  ))
      )
  );
}

class MyApp extends StatefulWidget {
   // bool firstTimeUser;
   User user;
  MyApp({ this.user});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>  with AfterLayoutMixin<MyApp>{
  AppState appState;
  LoginState loginState;

  bool hasUserUsedApp =false;
   SharedPreferences sharedPref;





  @override
  void initState() {

    super.initState();

    PushNotificationsManager().init(context);


  }


  Future<bool> isFirstTime() async {
    var isFirstTime = sharedPref.getBool('first_time');
    if (isFirstTime != null && !isFirstTime) {
      sharedPref.setBool('first_time', false);
      return false;
    } else {
      sharedPref.setBool('first_time', false);
      return true;
    }
  }


  static Future<List<String>> getDeviceDetails() async {
    String deviceName;
    String deviceVersion;
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.toString();
        identifier = build.androidId; //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor; //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
//if (!mounted) return;
    return [deviceName, deviceVersion, identifier];
  }


  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);
      loginState = Provider.of<LoginState>(context);

    setStatusBarColor(color: BarColor.black);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return OverlaySupport(
      child: GestureDetector(
        onTap: (){
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.focusedChild.unfocus();
          }

        },
        child: MaterialApp(
          title: 'Glade',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'DMSans'
          ),
          // locale: DevicePreview.locale(context), // Add the locale here
          // builder: DevicePreview.appBuilder,
          home:  hasUserUsedApp ? OnboardPage() : widget.user == null && !hasUserUsedApp ?  LoginPage() : !widget.user.is_email_verified ? LoginPage():  !widget.user.is_bvn_matched ? LoginPage(): !widget.user.hasPassCode ?  CreatePassCode() : WelcomeBackPage()



        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) async{
    sharedPref = await SharedPreferences.getInstance();

    isFirstTime().then((isFirstTimeb) {
      setState(() {
        hasUserUsedApp = isFirstTimeb;
      });
    });

    getDeviceDetails().then((value) {
      print(value);
      setState(() {
        appState.deviceId = value[2];
        print(appState.deviceId);
      });
    });

  }



}










