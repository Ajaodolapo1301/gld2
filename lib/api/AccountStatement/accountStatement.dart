import 'dart:convert';


import 'package:glade_v2/utils/apiUrls/env.dart';
import 'package:http/http.dart'as http;
abstract class AbstractAccountStatement {
  Future<Map<String, dynamic>> getAccountStatement({String token, business_uuid, bool isPersonal, from_date, to_date});


}


class AccountStatementImpl implements AbstractAccountStatement{
  @override
  Future<Map<String, dynamic>> getAccountStatement({String token,  business_uuid, bool isPersonal, from_date, to_date}) async {

    Map<String, dynamic> result = {};
     String url ;

    if(from_date == null && to_date == null){
      url  =  "${Env.testing}/statement";
    }else{
      url  =  "${Env.testing}/statement?date_from=$from_date&date_to=$to_date";
    }

    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" :  "$business_uuid",
    "business_uuid" :  "$business_uuid"
    };

    var headersPer = {
      "Authorization" : "Bearer $token",

    };


    print(url);
    print(" isSaluling $isPersonal");
    print(isPersonal ?  headersPer : headers);
    try {
      var response =
          await http.get(url,  headers: isPersonal ? headersPer : headers).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      // print(statusCode);
      print(jsonDecode(response.body));
      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
        result["statusCode"] = statusCode;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;

        var details = StatementDetails.fromJson(jsonDecode(response.body)["data"]["details"]);
        List<Statement> statement = [];
        (jsonDecode(response.body)['data']["statement"] as List).forEach((dat){
          statement.add(Statement.fromJson(dat));
        });

        result["details"] = details;
        result['statement'] = statement;

      }
    } catch (error) {
      // print(error.toString());

    }
// print(result);
    return result;

  }

}


class Statement{
  String txn_type;
  String  value;
  String  narration;
  String txn_date;
  String  txn_ref;
  String balance_after;
  String  createdAt;

  Statement({this.narration, this.txn_date, this.txn_ref, this.txn_type, this.value, this.balance_after, this.createdAt});
  factory Statement.fromJson(Map<String, dynamic> json)=> Statement(
      value: json["value"],
      txn_date: json["txn_date"],
      narration: json["narration"],
      txn_ref: json["txn_ref"],
      txn_type: json["txn_type"],
      balance_after: json["balance_after"],
      createdAt : json["created_at"]

  );


}

class StatementDetails{
  String account_name;
  String account_number;
  String opening_balance;
  String closing_balance;

  StatementDetails({this.account_name, this.account_number, this.closing_balance, this.opening_balance});
  factory StatementDetails.fromJson(Map<String, dynamic> json)=> StatementDetails(
      account_name: json["account_name"],
      account_number: json["account_number"],
      opening_balance: json["opening_balance"],
      closing_balance: json["closing_balance"],


  );

}

