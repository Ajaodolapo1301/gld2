

import 'dart:convert';

import 'package:glade_v2/core/models/apiModels/Business/LoanAndOverdraft/loanHistory.dart';
import 'package:glade_v2/core/models/apiModels/Business/LoanAndOverdraft/loanTypes.dart';
import 'package:glade_v2/core/models/apiModels/Business/LoanAndOverdraft/noteModel.dart';
import 'package:glade_v2/utils/apiUrls/env.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
abstract class AbstractLoanAndOverdraft {
      Future <Map<String, dynamic>> getLoanHistory({String token, business_uuid});
      Future <Map<String, dynamic>> applyLoan({String token, type_id, amount, reason, guarantor_name, guarantor_phone, guarantor_email, guarantor_address, String business_uuid});

      Future <Map<String, dynamic>> addNote({String token,narration, credit_id, business_uuid});

      Future <Map<String, dynamic>> getNote({String token, credit_id, business_uuid});
      Future <Map<String, dynamic>> cancelLoan({String token,reason, credit_id, business_uuid});
      Future <Map<String, dynamic>> creditTypes({String token, business_uuid});



}



class LoanAndOverdraftImpl implements AbstractLoanAndOverdraft{
  @override
  Future<Map<String, dynamic>> addNote({String token, narration, credit_id, business_uuid}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/credits/$credit_id/notes";

    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" : "$business_uuid"
    };
    var body = {
      "narration" : narration,

    };

    try {
      var response =
          await http.post(url,headers: headers, body: body ).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      // print(statusCode);
      // print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["error"];

        print("eeroror${result["message"]}");
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        result["message"] = jsonDecode(response.body)["message"];
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> applyLoan({String token,type_id, amount, reason, guarantor_name, guarantor_phone, guarantor_email, guarantor_address, String business_uuid})  async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/credits";

    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" : "$business_uuid"
    };
    var body = {
      "type" : type_id,
      "amount" : amount,
      "reason" : reason,
      "guarantor_name" : guarantor_name,
      "guarantor_phone" : guarantor_phone,
      "guarantor_email" : guarantor_email,
      "guarantor_address" : guarantor_address,

    };
print(body);
// print(headers);


    try {
      var response =
          await http.post(url,headers: headers, body: body ).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      // print(statusCode);
      print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        result["message"] = jsonDecode(response.body)["message"];
      }
    } catch (error) {
      print(error.toString());

    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> cancelLoan({String token, reason, credit_id, business_uuid}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/credits/$credit_id/cancel";


    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" : "$business_uuid"
    };
    var body = {
      "reason_for_cancellation" : reason,


    };

    try {
      var response =
          await http.put(url,headers: headers, body: body ).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      // print(statusCode);
      // print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
        result["statusCode"] = statusCode;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        result["message"] = jsonDecode(response.body)["message"];
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> getLoanHistory({String token, business_uuid}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/credits/history";

    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" : "$business_uuid"
    };


    try {
      var response =
          await http.get(url,headers: headers).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      // print(statusCode);
      print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
        result["statusCode"] = statusCode;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {

        result["error"] = false;
        List<CreditHistory> credit = [];
        (jsonDecode(response.body)['data'] as List).forEach((dat){
          credit.add(CreditHistory.fromJson(dat));
        });
        result['creditHistory'] = credit;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> creditTypes({String token, business_uuid})async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/credits/lookup/types";

    var headers = {
      "Authorization" : "Bearer $token"
    };


    try {
      var response =
          await http.get(url,headers: headers).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      // print(statusCode);
      // print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["error"];
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {

        result["error"] = false;
        List<CreditTypes> loanTypes = [];
        (jsonDecode(response.body)['data'] as List).forEach((dat){
          loanTypes.add(CreditTypes.fromJson(dat));
        });
        result['loanTypes'] = loanTypes;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> getNote({String token, credit_id, business_uuid}) async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/credits/$credit_id/notes";

    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" : "$business_uuid"
    };



    // print(url);
    // print(headers);

    try {
      var response =
          await http.get(url,headers: headers).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      // print(statusCode);
      print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {

        result["error"] = false;
        List<NoteModel> noteModel = [];
        (jsonDecode(response.body)['data'] as List).forEach((dat){
          noteModel.add(NoteModel.fromJson(dat));
        });
        result['noteModel'] = noteModel;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

}