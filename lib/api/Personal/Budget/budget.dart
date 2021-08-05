
import 'dart:convert';

import 'package:glade_v2/core/models/apiModels/Personal/Budget/budget.dart';
import 'package:glade_v2/utils/apiUrls/env.dart';
import 'package:http/http.dart' as http;
abstract class AbstractBudget {
  Future<Map<String, dynamic>> getBudget({String token,});
  Future<Map<String, dynamic>> budget({String token, amount, cycle_id, action_id});
  Future<Map<String, dynamic>> deleteBudget({String token,});

  Future<Map<String, dynamic>> getCycle({String token, });
  Future<Map<String, dynamic>> getAction({String token});
  Future<Map<String, dynamic>> updateBudget({String token, amount, cycle_id, action_id});
}


class BudgetImpl implements AbstractBudget{
  @override
  Future<Map<String, dynamic>> budget({String token, amount, cycle_id, action_id})async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/budget";

    var body = {
      "amount": amount.trim(),
      "cycle_id": cycle_id.trim(),
      "action_id": amount.trim(),

    };

    print("my body$body");
    var headers = {
      "Authorization" : "Bearer $token"
    };
    try {
      var response = await http.post(url, body: body, headers: headers).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(statusCode);
      print(response.body);
      print(jsonDecode(response.body)["token"]);
      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["error"];
        result['error'] = true;
      } else if (statusCode == 500) {
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
  Future<Map<String, dynamic>> deleteBudget({String token}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/budget";
    var headers = {
      "Authorization" : "Bearer $token"
    };
    try {
      var response = await http.delete(url,headers: headers).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(statusCode);
      print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["error"];
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
  Future<Map<String, dynamic>> getAction({String token})async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/budget/lookup/actions";
    var headers = {
      "Authorization" : "Bearer $token"
    };
    try {
      var response = await http.get(url,headers: headers).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(statusCode);
      print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["error"];
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        List<ActionModel> actions = [];
        (jsonDecode(response.body)['data'] as List).forEach((dat){
          actions.add(ActionModel.fromJson(dat));
        });
        result['actions'] = actions;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> getBudget({String token}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/budget";
    var headers = {
      "Authorization" : "Bearer $token"
    };
    try {
      var response = await http.get(url,headers: headers).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(statusCode);
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
          var budget = Budget.fromJson(jsonDecode(response.body)["data"]);
        result['budgets'] = budget;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> getCycle({String token})async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/budget/lookup/cycle";
    var headers = {
      "Authorization" : "Bearer $token"
    };
    try {
      var response = await http.get(url,headers: headers).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(statusCode);
      print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["error"];
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        List<Cycle> cycle = [];
        (jsonDecode(response.body)['data'] as List).forEach((dat){
          cycle.add(Cycle.fromJson(dat));
        });
        result['cycle'] = cycle;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> updateBudget({String token, amount, cycle_id, action_id})async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/budget";
    var headers = {
      "Authorization" : "Bearer $token"
    };
    var body = {
      "amount": amount.trim(),
      "cycle": cycle_id.trim(),
      "action": action_id.trim(),

    };


    print("BudgetBoday $body");
    try {
      var response = await http.put(url,headers: headers, body: body).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(statusCode);
      print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["error"];
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

}

