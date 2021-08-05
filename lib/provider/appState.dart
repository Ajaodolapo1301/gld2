

import 'package:flutter/cupertino.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:glade_v2/core/models/apiModels/Business/LoanAndOverdraft/loanTypes.dart';
import 'package:glade_v2/pages/personal/go_live/go_live_personal_page.dart';

class AppState with ChangeNotifier{



  String _deviceId = "";
  String get deviceId => _deviceId;
  set deviceId(String deviceId1) {
    _deviceId = deviceId1;
    notifyListeners();
  }



  // String _devicePlatform = "";
  // String get devicePlatform => _devicePlatform;
  // set devicePlatform(String devicePlatform1) {
  //   _devicePlatform = devicePlatform1;
  //   notifyListeners();
  // }

  bool selectingFile = false;
  bool _isPersonal = true;
  bool get isPersonal => _isPersonal;
  set isPersonal(bool isPersonal1) {
    _isPersonal = isPersonal1;
    notifyListeners();
  }

  // PSEUDO AMOUNT ====================================================================
  bool enableHiddenAmount = false; // enable or disabled by the user in settings - fetch from sharedPrefs
  bool hideAmount = false; // default false
  String pseudoBalance;











// CREATE VIRTUAL CARDS ========================================================================================== START
  String cardTitle;
  String currencyType;
  String amountToFundVCard;
  Color vCardColor;

// LOAN AND OVERDRAFT ========================================================================================== End




// GO-LIVE ========================================================================================== START

  TextEditingController addressGoLive  = TextEditingController();
  TextEditingController idCardNumber  = TextEditingController();
  String idCardType;








}