

import 'dart:convert';

import 'package:glade_v2/core/models/apiModels/Business/increaseLimit/billsType.dart';
import 'package:glade_v2/core/models/apiModels/Business/increaseLimit/limits.dart';
import 'package:glade_v2/utils/apiUrls/env.dart';
import 'package:http/http.dart' as http;


abstract class AbstractIncreaseLimit {
  Future<Map<String, dynamic>> getLimits({String token});
  Future<Map<String, dynamic>> getBillTypes({String token});
  Future<Map<String, dynamic>> limit({String token, limit_id, bill_type_name, bill_image, reason_for_inncrease});
}


class IncreaseLimitImpl implements AbstractIncreaseLimit{
  @override
  Future<Map<String, dynamic>> getBillTypes({String token}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/limit/lookups/bill_types";

    var headers = {
      "Authorization" : "Bearer $token"
    };


    try {
      var response =
          await http.get(url,headers: headers,  ).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(statusCode);
      print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["error"];

        print("eeroror${result["message"]}");
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        List<BillsType> billsType = [];
        (jsonDecode(response.body)['data'] as List).forEach((dat){
          billsType.add(BillsType.fromJson(dat));
        });
        result['billsType'] = billsType;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> getLimits({String token}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/limit/lookups/limits";

    var headers = {
      "Authorization" : "Bearer $token"
    };


    try {
      var response =
          await http.get(url,headers: headers,  ).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(statusCode);
      print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["error"];

        print("eeroror${result["message"]}");
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        List<Limit> limit = [];
        (jsonDecode(response.body)['data'] as List).forEach((dat){
          limit.add(Limit.fromJson(dat));
        });
        result['limit'] = limit;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> limit({String token, limit_id, bill_type_name, bill_image, reason_for_inncrease}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/limit";

    var headers = {
      "Authorization" : "Bearer $token"
    };
    var body = {
      "limit_id" : limit_id,
      "bill_type_name" : bill_type_name,
      "bill_image" : bill_image,
      "reason_for_inncrease" : reason_for_inncrease,

    };

    try {
      var response =
          await http.put(url,headers: headers, body: body ).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(statusCode);
      print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["error"];

        print("eeroror${result["message"]}");
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        result["message"] =jsonDecode(response.body)["message"];
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

}