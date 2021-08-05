
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

class PseudoPage extends StatefulWidget {



  @override
  _PseudoPageState createState() => _PseudoPageState();
}

class _PseudoPageState extends State<PseudoPage> {
  @override
  void initState() {
    super.initState();

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
