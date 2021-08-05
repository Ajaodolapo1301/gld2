import 'package:flutter/cupertino.dart';
import 'package:glade_v2/api/Personal/FundAccount/fundAccount.dart';
import 'package:glade_v2/core/models/apiModels/Personal/FundAccount/savedCards.dart';

import '../loginState.dart';

abstract class AbstractFundAccountViewModel{
  Future<Map<String, dynamic>> fundAccount({card_name, amount, card_number, expiry_month, expiry, bool save_card, token, cvv, LoginState loginState, bool isPersonal, business_uuid});
  Future<Map<String, dynamic>> fundAccountCharge({card_name, amount, card_number, expiry_month, expiry, bool save_card, token, cvv, LoginState loginState, pin,  bool isPersonal, business_uuid, auth_type});

  Future<Map<String, dynamic>> fundAccountValidate({otp, txRef, token,  bool isPersonal, business_uuid});
  Future<Map<String, dynamic>> fundAccountVerify({txRef,token,  bool isPersonal, business_uuid});
  Future<Map<String, dynamic>> getSavedCard({String token,  bool isPersonal, business_uuid});
  Future<Map<String, dynamic>> fundAccountfromBusiness({paymentType,token, amount, business_uuid, currency, remark});
}




class FundAccountState with ChangeNotifier implements AbstractFundAccountViewModel{



  List<SavedCard> _savedCard= [];
  List<SavedCard> get savedCard => _savedCard;
  set savedCard(List<SavedCard> savedCard1) {
    _savedCard = savedCard1;
    notifyListeners();
  }

  @override
  Future<Map<String, dynamic>> fundAccount({card_name, card_number, expiry_month, expiry, bool save_card, token, amount, cvv, LoginState loginState, bool isPersonal, business_uuid}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await FundAccountImpl().fundAccount(token: token, card_name: card_name, card_number: card_number, expiry: expiry, expiry_month: expiry_month, save_card: save_card, amount: amount, cvv:cvv, loginState: loginState, business_uuid: business_uuid, isPersonal: isPersonal);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){

        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> getSavedCard({String token,  bool isPersonal, business_uuid})async {
    Map<String, dynamic> result = Map();

    try{
      result = await FundAccountImpl().getSavedCard(token: token);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
        savedCard = result["savedCards"];
        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> fundAccountCharge({card_name, amount, card_number, expiry_month, expiry, bool save_card, token, cvv, LoginState loginState, pin,  bool isPersonal, business_uuid, auth_type}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await FundAccountImpl().fundAccountCharge(token: token, card_name: card_name, card_number: card_number, expiry: expiry, expiry_month: expiry_month, save_card: save_card, amount: amount, cvv:cvv, loginState: loginState, pin: pin,  business_uuid: business_uuid, isPersonal: isPersonal, auth_type: auth_type);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){

        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> fundAccountValidate({otp, txRef, token,  bool isPersonal, business_uuid}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await FundAccountImpl().fundAccountValidate(token: token, otp: otp, txRef: txRef,  business_uuid: business_uuid, isPersonal: isPersonal);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){

        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> fundAccountVerify({txRef, token,  bool isPersonal, business_uuid})async {
    Map<String, dynamic> result = Map();

    try{
      result = await FundAccountImpl().fundAccountVerify(token: token, txRef: txRef,  business_uuid: business_uuid, isPersonal: isPersonal);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){

        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> fundAccountfromBusiness({paymentType, token, amount, business_uuid, currency, remark}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await FundAccountImpl().fundAccountfromBusiness(token: token, amount: amount,  business_uuid: business_uuid, currency: currency, remark: remark);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){

        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

}
