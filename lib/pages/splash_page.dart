import 'dart:async';

import 'package:flutter/material.dart';
import 'package:glade_v2/core/models/apiModels/Auth/user.dart';
import 'package:glade_v2/pages/authentication/login_page.dart';
import 'package:glade_v2/pages/authentication/register/stages/createPasscode.dart';
import 'package:glade_v2/pages/authentication/register/stages/emailVerification.dart';
import 'package:glade_v2/pages/authentication/register/stages/verifyBvn.dart';
import 'package:glade_v2/pages/authentication/welcome_back_page.dart';
import 'package:glade_v2/pages/dashboard/dashboard_page.dart';
import 'package:glade_v2/pages/onboard_page.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';

class SplashPage extends StatefulWidget {
  final bool hasUSedAppBefore;
  final User user;
    SplashPage({this.hasUSedAppBefore, this.user});
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    print(" hshs${widget.user}");
    print(" hshs${widget.hasUSedAppBefore}");
    super.initState();



        Timer(Duration(seconds: 3), () {
          if(widget.user != null){
            ! widget.user.is_bvn_matched ?   pushToWithRoute(context, CustomRoutes.fadeIn(VerifyBvn())) :
            !widget.user.is_email_verified ?   pushToWithRoute(context, CustomRoutes.fadeIn(EmailVerification())) :
            !widget.user.hasPassCode ?   pushToWithRoute(context, CustomRoutes.fadeIn(CreatePassCode())) :
            widget.user.hasPassCode  ? pushToWithRoute(context, CustomRoutes.fadeIn(WelcomeBackPage())):
            pushToWithRoute(context, CustomRoutes.fadeIn(LoginPage()));
          }
          !widget.hasUSedAppBefore ?  pushToWithRoute(context, CustomRoutes.fadeIn(OnboardPage())) :
          pushToWithRoute(context, CustomRoutes.fadeIn(LoginPage()));
        });





  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/images/logo.png"),
      ),
    );
  }
}
