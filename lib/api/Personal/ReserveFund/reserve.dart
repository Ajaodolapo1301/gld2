import 'package:glade_v2/core/models/apiModels/Personal/ReserveFund/reserve.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:glade_v2/utils/apiUrls/env.dart';


abstract class AbstractReserve {
  Future<Map<String, dynamic>> getstashType({String token,  });
  Future<Map<String, dynamic>> getReserves({String token});
  Future<Map<String, dynamic>> getReserveDetails({String token, id});
  Future<Map<String, dynamic>> CreateReserves({String token, title, amount, description, stash_type, start_date, end_date});
  Future<Map<String, dynamic>> UpdateReserves({String token, reserve_id,  title, amount, description, stash_type,  end_date});
  Future<Map<String, dynamic>> fundReserve({String token, reserve_id, amount});
  Future<Map<String, dynamic>> withdrawReserve({String token, reserve_id, amount, remark});
  Future<Map<String, dynamic>> disableReserve({String token, reserve_id });
  Future<Map<String, dynamic>> enableReserve({String token, reserve_id });
  Future<Map<String, dynamic>> transactionListDetails({String token, reserve_id });
}


class ReserveImpl implements AbstractReserve{



  @override
  Future<Map<String, dynamic>> getstashType({String token})  async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/reserve/lookup/stash-types";

    var headers = {
      "Authorization" : "Bearer $token"
    };


    try {
      var response =
          await http.get(url,headers: headers,  ).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      // print(statusCode);
      // print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
      result["statusCode"] = statusCode;
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        List<StashType> stashType = [];
        (jsonDecode(response.body)['data'] as List).forEach((dat){
          stashType.add(StashType.fromJson(dat));
        });
        result['stashType'] = stashType;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> getReserves({String token})  async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/reserve";

    var headers = {
      "Authorization" : "Bearer $token"
    };


    try {
      var response =
          await http.get(url,headers: headers,  ).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      // print(statusCode);
      // print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];

        result['error'] = true;
        result["statusCode"]  =statusCode;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        List<Reserve> reserve = [];
        (jsonDecode(response.body)['data'] as List).forEach((dat){
          reserve.add(Reserve.fromJson(dat));
        });
        result['reserve'] = reserve;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> CreateReserves({String token, title, amount, description, stash_type, start_date, end_date }) async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/reserve";

    var headers = {
      "Authorization" : "Bearer $token"
    };
  var body = {
    "title" :title,
//    "amount" : amount,
    "description" : description,
    "stash_type" :  stash_type,
    "stash_amount" : amount,
    "start_date": start_date,
    "end_date" : end_date
  };

  print(body);
    try {
      var response =
          await http.post(url,body: body, headers: headers,  ).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      // print(statusCode);
      // print(response.body);

      if (statusCode != 201 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result["statusCode"] = statusCode;
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;

      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> disableReserve({String token, reserve_id})  async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/reserve/$reserve_id/disable";

    var headers = {
      "Authorization" : "Bearer $token"
    };


    try {
      var response =
          await http.put(url, headers: headers,  ).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      // print(statusCode);
      // print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result["statusCode"] = statusCode;
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;

      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> fundReserve({String token, reserve_id, amount}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/reserve/$reserve_id/fund";

    var headers = {
      "Authorization" : "Bearer $token"
    };



    var body = {
    "amount" : amount,
      "funding_type" : "manual"
    };


    try {
      var response =
          await http.put(url, body: body, headers: headers,  ).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      // print(statusCode);
      // print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result["statusCode"] = statusCode;
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
  Future<Map<String, dynamic>> withdrawReserve({String token, reserve_id, amount, remark}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/reserve/$reserve_id/withdraw";

    var headers = {
      "Authorization" : "Bearer $token"
    };

    var body = {
      "amount" : amount,
      "remark" : remark

    };
    try {
      var response =
          await http.put(url, body: body, headers: headers,  ).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      // print(statusCode);
      // print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result["statusCode"] = statusCode;
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
  Future<Map<String, dynamic>> getReserveDetails({String token, id}) async {
    Map<String, dynamic> result = {};

    final String url = "${Env.testing}/reserve/$id/";

    var headers = {
      "Authorization" : "Bearer $token"
    };


    try {
      var response =
          await http.get(url, headers: headers,  ).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

//      print("na me $statusCode");
//       print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result["statusCode"] = statusCode;
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
      var res = ReserveDetails.fromJson(jsonDecode(response.body)["data"]);
        result["reserveDetails"] = res;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> UpdateReserves({String token, reserve_id, title, amount, description, stash_type, end_date}) {
    // TODO: implement UpdateReserves
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> enableReserve({String token, reserve_id}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/reserve/$reserve_id/enable";

    var headers = {
      "Authorization" : "Bearer $token"
    };


    try {
      var response =
          await http.put(url, headers: headers,  ).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(statusCode);
      print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result["statusCode"] = statusCode;
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;

      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> transactionListDetails({String token, reserve_id}) {
    // TODO: implement transactionListDetails
    throw UnimplementedError();
  }

}
