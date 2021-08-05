
import 'package:flutter/foundation.dart';
import 'package:glade_v2/api/Auth/auth.dart';
import 'package:glade_v2/core/models/apiModels/Auth/balance.dart';
import 'package:glade_v2/core/models/apiModels/Auth/user.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/bankModel.dart';

import 'package:hive/hive.dart';

class LoginState extends AbstractLoginViewModel with ChangeNotifier {
  User _user;
  Box box;

  User get user => _user;
  set user(User value) {
    _user = value;
    notifyListeners();
  }

  LoginState(User value) {
    box = Hive.box("user");
    if (value != null) {
      user = value;
    }
  }


  List<BankBVNModel> _banks= [];
  List<BankBVNModel> get banks => _banks;
  set banks(List<BankBVNModel> banks1) {
    _banks = banks1;
    notifyListeners();
  }



  @override
  Future<Map<String, dynamic>> bvnValidation({bvn}) async{

    Map<String, dynamic> result = Map();


    try{
      result = await Auth().bvnValidation(bvn: bvn);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){

        }
      }
    }catch(e){

    }
    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic>> createPasscode({passCode,user_uuid })async {
    Map<String, dynamic> result = Map();


    try{
      result = await Auth().createPasscode(passCode: passCode, user_uuid: user_uuid);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){

        }
      }
    }catch(e){

    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> login({email, password})async {
    Map<String, dynamic> result = Map();


    try{
      result = await Auth().login(email: email, password: password);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occurred,Please try again';
      }else{
        if(result['error'] == false){
          box.put('user', result['user']);
          user = result['user'];
        }
      }
    }catch(e){

    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> otpValidation({otp, user_uuid}) async{
    Map<String, dynamic> result = Map();


    try{
      result = await Auth().otpValidation(otp: otp, user_uuid: user_uuid);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
          result["bvn"] = result["bvn"];
        }
      }
    }catch(e){

    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> register1({email, firstName, lastName,  phone, bvn, password}) async{
    Map<String, dynamic> result = Map();


    try{
      result = await Auth().register1(email: email, lastName: lastName, firstName: firstName,  phone: phone, bvn: bvn, password: password);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){

        }
      }
    }catch(e){

    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> register2({password, user_uuid})async {
    Map<String, dynamic> result = Map();


    try{
      result = await Auth().createPassword(password: password, user_uuid: user_uuid);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){

        }
      }
    }catch(e){

    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> verifyPasscode({token, passcode}) async{
    Map<String, dynamic> result = Map();


    try{
      result = await Auth().verifyPasscode(passCode: passcode, token:token, );
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){

        }
      }
    }catch(e){

    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> emailVerification({otp, token}) async{
    Map<String, dynamic> result = Map();


    try{
      result = await Auth().emailVerification(otp: otp, token: token);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
//          result["bvn"] = result["bvn"];
        }
      }
    }catch(e){

    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> resetPin({currentPin, newPin, token}) async{
    Map<String, dynamic> result = Map();


    try{
      result = await Auth().changePin(newPin: newPin, token: token, currentPin: currentPin);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){

        }
      }
    }catch(e){

    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> resetPassword({email}) async{
    Map<String, dynamic> result = Map();


    try{
      result = await Auth().resetPassword(email: email);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){

        }
      }
    }catch(e){

    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> resetpassword2({email, verification_code,  new_pass}) async{
    Map<String, dynamic> result = Map();


    try{
      result = await Auth().resetpassword2(email: email, verification_code:verification_code, new_pass:new_pass);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){

        }
      }
    }catch(e){

    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> ChangePin1({token}) async{
    Map<String, dynamic> result = Map();


    try{
      result = await Auth().resetPin1(token: token);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){

        }
      }
    }catch(e){

    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> ChangePin2({newPasscode, verification_code, token}) async{
    Map<String, dynamic> result = Map();


    try{
      result = await Auth().resetPin2( verification_code:verification_code, newPasscode: newPasscode, token: token);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){

        }
      }
    }catch(e){

    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> changePassword({currentPassword, newPassword, token}) async {
    Map<String, dynamic> result = Map();


    try{
      result = await Auth().changePassword(currentPassword: currentPassword, newPassword: newPassword, token: token);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){

        }
      }
    }catch(e){

    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> getUser({token}) async{
    Map<String, dynamic> result = Map();
    try {
      result = await Auth().getUser(token: token);


      if (result['error'] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      } else if (result['error'] == true) {
        result['error'] = true;
        result['message'] = result["message"];
      }
    } catch (error) {
//      print(error.toString());
      result['error'] = true;
      result['message'] = result["message"];
    }

    if (result['error'] == false) {
      User user1 = result['user'];
      user.business_uuid = user1.business_uuid;
      user.availableBalance = user1.availableBalance;
      user.compliance_status = user1.compliance_status;
      user?.business_uuid = user1?.business_uuid;
      // user.
      // user.availableBalance = user1.availableBalance;
      notifyListeners();
    }
//    print(result);
    return result;

  }

  @override
  Future<Map<String, dynamic>> getBalance({token})async {
    Map<String, dynamic> result = Map();
    try {
      result = await Auth().getBalance(token: token);


      if (result['error'] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      } else if (result['error'] == true) {
        result['error'] = true;
        result['message'] = result["message"];
      }
    } catch (error) {
//      print(error.toString());
      result['error'] = true;
      result['message'] = result["message"];
    }

    if (result['error'] == false) {
      Balance balance = result['balance'];

      user.availableBalance = balance.balance;

      // user.availableBalance = user1.availableBalance;
      notifyListeners();
    }
//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic>> bvnMatchBanks({token}) async{
    Map<String, dynamic> result = Map();


    try{
      result = await Auth().bvnMatchBanks(token: token);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
      banks = result["banks"];
        }
      }
    }catch(e){

    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> bvnMatch({bvn, first_name, last_name, bank_code, account_number, token}) async {
    Map<String, dynamic> result = Map();


    try{
      result = await Auth().bvnMatch(bank_code: bank_code, last_name: last_name, token: token, account_number: account_number, bvn: bvn, first_name: first_name);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){

        }
      }
    }catch(e){

    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> phoneInfo({token, device_token, device_uuid, device_platform}) async{
    Map<String, dynamic> result = Map();


    try{
      result = await Auth().phoneInfo(token: token, device_platform: device_platform, device_token: device_token, device_uuid: device_uuid );
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){

        }
      }
    }catch(e){

    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> resendEmail({user_uuid})async {
    Map<String, dynamic> result = Map();


    try{
      result = await Auth().resendEmail(user_uuid: user_uuid);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){

        }
      }
    }catch(e){

    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> checkEmail({email}) async{
    Map<String, dynamic> result = Map();


    try{
      result = await Auth().checkEmail(email: email);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){

        }
      }
    }catch(e){

    }
    return result;
  }


















}












abstract class AbstractLoginViewModel {
  Future<Map<String, dynamic>> checkEmail({email});
  Future<Map<String, dynamic>> resendEmail({user_uuid});
  Future<Map<String, dynamic>> login({email, password});
  Future<Map<String, dynamic>> getBalance({token});
  Future<Map<String, dynamic>> bvnValidation({bvn});
  Future<Map<String, dynamic>> register1({email, firstName, lastName, phone, bvn, password});
  Future<Map<String, dynamic>> otpValidation({otp, user_uuid});

  Future<Map<String, dynamic>> register2({password, user_uuid});
  Future<Map<String, dynamic>> createPasscode({passCode, user_uuid});
  Future<Map<String, dynamic>> emailVerification({otp, token});
  Future<Map<String, dynamic>> verifyPasscode({token, passcode});
  Future<Map<String, dynamic>> resetPin({currentPin, newPin, token,});
  Future<Map<String, dynamic>> resetPassword({email});
  Future<Map<String, dynamic>> resetpassword2({email, verification_code,  new_pass});
  Future<Map<String, dynamic>> ChangePin1({token,});
  Future<Map<String, dynamic>> ChangePin2({newPasscode, verification_code, token,});
  Future<Map<String, dynamic>> bvnMatch({bvn, first_name,last_name,bank_code , account_number, token });
  Future<Map<String, dynamic>> getUser({token});
  Future<Map<String, dynamic>> changePassword({currentPassword, newPassword, token,});
  Future<Map<String, dynamic>> bvnMatchBanks({token});
  Future<Map<String, dynamic>> phoneInfo({token, device_token, device_uuid, device_platform});
}