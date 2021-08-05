
import 'dart:convert';


import 'package:glade_v2/core/models/apiModels/Personal/FundAccount/savedCards.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:http/http.dart' as http;

import 'package:glade_v2/utils/apiUrls/env.dart';

abstract class AbstractFundAccount{
  Future<Map<String, dynamic>> fundAccount({card_name, amount, card_number, expiry_month, expiry, bool save_card, token, cvv, LoginState loginState, bool isPersonal, business_uuid});
  Future<Map<String, dynamic>> fundAccountCharge({card_name, amount, card_number, expiry_month, expiry, bool save_card, token, cvv, LoginState loginState, pin,  bool isPersonal, business_uuid, auth_type});
  Future<Map<String, dynamic>> fundAccountValidate({otp, txRef, token,  bool isPersonal, business_uuid});
  Future<Map<String, dynamic>> fundAccountVerify({txRef,token,  bool isPersonal, business_uuid});
  Future<Map<String, dynamic>> fundAccountfromBusiness({paymentType,token, amount, business_uuid, currency, remark});

  Future<Map<String, dynamic>> getSavedCard({String token,  bool isPersonal, business_uuid});
}



class FundAccountImpl implements AbstractFundAccount{


  @override
  Future<Map<String, dynamic>> fundAccount({card_name, amount, card_number, expiry_month, expiry, bool save_card, cvv,token, LoginState loginState,  bool isPersonal, business_uuid})async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/fund";


    var headerPer = {
      "Authorization" : "Bearer $token",
      "Accept": "application/json",
      "content-Type": "application/json"
    };


    var header = {
      "Authorization" : "Bearer $token",
      "content-Type" : "application/json",
      "business-uuid": "$business_uuid"
    };


    var body = {
      "action": "initiate",
      "paymentType": "card",
      "amount": amount.trim(),
      "currency": "NGN",
    "save_card" : save_card ? "1" : "0",
      "card": {
        "card_name": card_name.trim(),
        "card_no": card_number.trim(),
        "expiry_month": expiry_month.trim(),
        "expiry_year": expiry.trim(),
        "cvv": cvv.trim()
      },
      "user": {
        "firstname": loginState.user.firstname.trim(),
        "lastname": loginState.user.lastname.trim(),
        "email": loginState.user.email.trim()
      }


    };

    print(url);

    try {
      var response = await http.post( url, body: jsonEncode(body), headers: isPersonal ? headerPer : header,    encoding: Encoding.getByName("utf-8")).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(statusCode);
      print(response.body);

      if (jsonDecode(response.body)["data"]["status"] == 503) {
        result["message"] = jsonDecode(response.body)["data"]["message"];
        result['statusCode'] = statusCode;
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        result["message"] = jsonDecode(response.body)["data"];
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> getSavedCard({String token,  bool isPersonal, business_uuid})async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/fund/cards";

    var headerPer = {
      "Authorization" : "Bearer $token",
      "content-Type" : "application/json"
    };


    var header = {
      "Authorization" : "Bearer $token",
      "content-Type" : "application/json",
      "business-uuid": "$business_uuid"
    };


    try {
      var response = await http.get(url,headers: isPersonal ? headerPer : header).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(statusCode);
      print(response.body);
      print(jsonDecode(response.body)["token"]);
      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["error"];

        print("eeroror${result["message"]}");
        result['error'] = true;
      } else if (statusCode == 500) {
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        List<SavedCard> savedCards = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){
          savedCards.add(SavedCard.fromJson(dat));
        });
        result['savedCards'] = savedCards;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> fundAccountCharge({card_name, amount, card_number, expiry_month, expiry, bool save_card, token, cvv, LoginState loginState, pin,  bool isPersonal, business_uuid, auth_type}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/fund";



    var headerPer = {
      "Authorization" : "Bearer $token",
      "content-Type" : "application/json"
    };


    var header = {
      "Authorization" : "Bearer $token",
      "content-Type" : "application/json",
      "business-uuid": "$business_uuid"
    };


    var body = {
      "action": "charge",
      "paymentType": "card",
      "amount": amount.trim(),
      "currency": "NGN",
      "save_card" : save_card ? "1" : "0",
      "card": {
        "card_name": card_name.trim(),
        "card_no": card_number.trim(),
        "expiry_month": expiry_month.trim(),
        "expiry_year": expiry.trim(),
        "cvv": cvv.trim(),
        "pin": pin.trim()
      },
      "user": {
        "firstname": loginState.user.firstname.trim(),
        "lastname": loginState.user.lastname.trim(),
        "email": loginState.user.email.trim()
      },
      // "auth_type":"OTP"
      "auth_type":auth_type.trim()

    };



    //
    // print(body);
    // print(header);
    try {
      var response = await http.post(url, body: jsonEncode(body), headers: isPersonal ? headerPer : header).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(statusCode);
      print(response.body);
      print(jsonDecode(response.body)["token"]);
      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result['statusCode'] = statusCode;
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        result["message"] = jsonDecode(response.body)["data"];
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> fundAccountValidate({otp, txRef, token,  bool isPersonal, business_uuid})async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/fund";


    var headerPer = {
      "Authorization" : "Bearer $token",
      "content-Type" : "application/json"
    };


    var header = {
      "Authorization" : "Bearer $token",
      "content-Type" : "application/json",
      "business-uuid": "$business_uuid"
    };



    var body = {
      "action": "validate",
      "txnRef": txRef.trim(),
      "otp": otp.trim(),
    };




    print(body);
    print(header);
    try {
      var response = await http.post(url, body: jsonEncode(body), headers: isPersonal ? headerPer : header).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(statusCode);
      print(response.body);
      print(jsonDecode(response.body)["token"]);
      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result['statusCode'] = statusCode;
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        result["message"] = jsonDecode(response.body)["data"];
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> fundAccountVerify({txRef, token,  bool isPersonal, business_uuid})async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/fund";


    var headerPer = {
      "Authorization" : "Bearer $token",
      // "content-Type" : "application/json"
    };


    var header = {
      "Authorization" : "Bearer $token",
      // "content-Type" : "application/json",
      "business-uuid": "$business_uuid"
    };


    var body = {
      "action": "verify",
      "txnRef": txRef,
    };




    print(body);
    print(header);
    try {
      var response = await http.post(url, body: body, headers: isPersonal ? headerPer : header).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(statusCode);
      print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result['statusCode'] = statusCode;
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        result["message"] = jsonDecode(response.body)["data"];
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> fundAccountfromBusiness({paymentType, token, amount, business_uuid, currency, remark}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/fund";


    var headerPer = {
      "Authorization" : "Bearer $token",
      // "content-Type" : "application/json"
    };



    var body = {
      "paymentType": "business",
      "amount": amount,
      "business_uuid": business_uuid,
      "narration": remark,
      "currency": "NGN"
    };




    print(body);

    try {
      var response = await http.post(url, body: body, headers: headerPer ).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(statusCode);
      print(response.body);
      print(jsonDecode(response.body)["token"]);
      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result['statusCode'] = statusCode;
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        result["message"] = jsonDecode(response.body)["data"];
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

}