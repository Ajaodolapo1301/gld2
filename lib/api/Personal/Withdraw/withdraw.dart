


import 'dart:convert';

import 'package:glade_v2/utils/apiUrls/env.dart';
  import 'package:http/http.dart'  as http;
abstract class AbstractWithdraw {
  Future<Map<String, dynamic>> withdraw({String token, amount, remark});


}




class WithdrawImpl implements AbstractWithdraw{
  @override
  Future<Map<String, dynamic>> withdraw({String token, amount, remark}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/withdraw";

    try {
      var response =
          await http.post(url).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(statusCode);
      print(response.body);
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
        result["message"] = jsonDecode(response.body)["message"];
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

}