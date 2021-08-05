



import 'dart:convert';

import 'package:glade_v2/core/models/apiModels/Personal/GoLive/StateAndLGA.dart';
import 'package:glade_v2/core/models/apiModels/Personal/POS/pos.dart';
import 'package:glade_v2/utils/apiUrls/env.dart';
import 'package:http/http.dart'  as http;
abstract class AbstractPOS {
  Future<Map<String, dynamic>> getRevenue({String token, });
  Future<Map<String, dynamic>> getSales({String token, });
  Future<Map<String, dynamic>> getStates({String token,});
  Future<Map<String, dynamic>> getLGAs({String token,  String state_id});
  Future<Map<String, dynamic>> POS({String token, revenue_id, sales_id, delivery_address, state, lga, additional_note, quantity, business_uuid, bool isPersonal,  });
  Future<Map<String, dynamic>> posPending({String token, business_uuid ,  bool isPersonal, });
  Future<Map<String, dynamic>> posApproved({String token, business_uuid,  bool isPersonal,  });
}


class POSimpl implements AbstractPOS{
  @override
  Future<Map<String, dynamic>> POS({String token, revenue_id, sales_id, delivery_address, state, lga, additional_note, quantity, business_uuid, bool isPersonal})async {
    Map<String, dynamic> result = {};
     String url ;
      if(isPersonal){
        url = "${Env.testing}/pos/personal";
      }else{
        url = "${Env.testing}/pos/business";
      }


    var body = {
      "revenue_id" : revenue_id.trim(),
      "sales_id": sales_id.trim(),
      "delivery_address" : delivery_address.trim(),
       "state_id": state.toString(),
      "lga_id": lga.toString(),
      "additional_note" : additional_note.trim(),
      "quantity": quantity,
    };

    var headers = {
      "business-uuid": "$business_uuid",
      "Authorization" : "Bearer $token"
    };

    var headerPer = {

      "Authorization" : "Bearer $token"
    };


    print(body);
    // print(headers);

    try {
      var response =
          await http.post(url, body: body, headers: isPersonal ? headerPer  : headers).timeout(Duration(seconds: 30));
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
  Future<Map<String, dynamic>> getLGAs({String token, String state_id})async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/pos/lookups/$state_id/lga";
    var headers = {
      "Authorization" : "Bearer $token"
    };

    print(url);


    try {
      var response =
          await http.get(url, headers: headers).timeout(Duration(seconds: 30));
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
        List<LGA> localGovts = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){
          localGovts.add(LGA.fromJson(dat));
        });
        result['localGovts'] = localGovts;
      }
    } catch (error) {
      // print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> getRevenue({String token})async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/pos/lookup/revenue";
    var headers = {
      "Authorization" : "Bearer $token"
    };
    try {
      var response =
          await http.get(url, headers: headers).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      // print(statusCode);
      // print(response.body);
      print(jsonDecode(response.body)["token"]);
      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["error"];

        print("eeroror${result["message"]}");
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        List<Revenue> revenue = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){
          revenue.add(Revenue.fromJson(dat));
        });
        result['revenue'] = revenue;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> getSales({String token})  async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/pos/lookup/sales";
    var headers = {
      "Authorization" : "Bearer $token"
    };
    try {
      var response =
          await http.get(url, headers: headers).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;
      //
      // print(statusCode);
      // // print(response.body);
      // print(jsonDecode(response.body)["token"]);
      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
        result["statusCode"] = statusCode;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        List<Sales> sales = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){
          sales.add(Sales.fromJson(dat));
        });
        result['sales'] = sales;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> getStates({String token})async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/pos/lookup/state";
    var headers = {
      "Authorization" : "Bearer $token"
    };
    print(url);
    try {
      var response =
          await http.get(url, headers: headers).timeout(Duration(seconds: 30));
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
        List<States> states = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){
          states.add(States.fromJson(dat));
        });
        result['states'] = states;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> posApproved({String token,  business_uuid, bool isPersonal }) async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/pos/history/approved";
    var headers = {
      "business-uuid": "$business_uuid",
      "Authorization" : "Bearer $token"
    };
    var headerPer = {

      "Authorization" : "Bearer $token"
    };
    try {
      var response =
          await http.get(url, headers: isPersonal ? headerPer: headers).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      // print(statusCode);
      // print(response.body);
      // print(jsonDecode(response.body)["token"]);
      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
        result["statusCode"] = statusCode;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        List<PosHistoryModel> posPending = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){
          posPending.add(PosHistoryModel.fromJson(dat));
        });
        result['posPending'] = posPending;

      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> posPending({String token,  business_uuid, bool isPersonal }) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/pos/history/pending";
    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid": "$business_uuid",
    };


    var headerPer = {

      "Authorization" : "Bearer $token"
    };

    print(isPersonal);
    try {
      var response =
          await http.get(url, headers: isPersonal ? headerPer: headers).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      // print(statusCode);
      // print(response.body);
      // print(jsonDecode(response.body)["token"]);
      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
        result["statusCode"] = statusCode;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        List<PosHistoryModel> posPending = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){
          posPending.add(PosHistoryModel.fromJson(dat));
        });
        result['posPending'] = posPending;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

}
