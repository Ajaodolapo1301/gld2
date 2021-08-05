


import 'dart:convert';
import 'dart:developer';


import 'package:glade_v2/core/models/apiModels/AirtimeAndBills/airtimeAndBills.dart';
import 'package:glade_v2/core/models/ui/TransferReceiptData.dart';
import 'package:glade_v2/utils/apiUrls/env.dart';
import 'package:http/http.dart' as http;
abstract class AbstractAirtimeAndBills {
  Future<Map<String, dynamic>> getBills({String token});

  Future<Map<String, dynamic>> getBeneficairies({String token, type});
  Future<Map<String, dynamic>> gethistory({String token, business_uuid, bool isPersonal, start_date, end_date,});
 
 
  Future<Map<String, dynamic>> fetchmetername({String token, meter_number, paycode});
  Future<Map<String, dynamic>> fetchinternetService({String token, paycode, account_number});
  Future<Map<String, dynamic>> fetchCableName({String token, String card_iuc_number, paycode, amount});
 
 
 
  Future<Map<String, dynamic>> airtime({String token, paycode, reference, amount, save_beneficiary, bool isPersonal, business_uuid});
  Future<Map<String, dynamic>> internet({String token, paycode, reference, account_name,  amount, save_beneficiary, bool isPersonal, business_uuid});
  Future<Map<String, dynamic>> cable({String token, paycode, reference, cable_name, amount, save_beneficiary, bool isPersonal, business_uuid});
  Future<Map<String, dynamic>> electricy({String token, paycode, reference, meter_number_details, amount, save_beneficiary, bool isPersonal, business_uuid});

}



class BillImpl implements AbstractAirtimeAndBills {
  @override
  Future<Map<String, dynamic>> getBills({String token}) async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/bills/lookup/all";

    var header = {
      "Authorization": "Bearer $token",
      // "accept": "application/json",
      "content-type": "application/json",
//   "MID": pref.getString("current_mid"),
// "KEY": pref.getString("current_key"),
    };

    var body = {
//    body: json.encode({"action": "pull", "source": "internal"}));
    };


    print(url);
    try {
      var response = await http.get(url, headers: header).timeout(
          Duration(seconds: 30));
      int statusCode = response.statusCode;

      // print(statusCode);
      // log(response.body);
      if (statusCode != 200 && statusCode != 500) {
        result["statusCode"] = statusCode;
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        var bills = BillsInfo.fromJson(jsonDecode(response.body));
        result["bills"] = bills;
      }
    } catch (error) {
      // print(error.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> getBeneficairies({String token, type})async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/bills/$type/beneficiaries";
    // ""
    // "$start_date/$end_date/$page_index/$page_size";
    var headers = {
      "Authorization" : "Bearer $token",

    };

    var headersPer = {
      "Authorization" : "Bearer $token",

    };
    // print(url);
    try {
      var response = await http.get(url, headers: headers).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;
    // print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["statusCode"] = statusCode;
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;

      } else if (statusCode == 500) {

        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        List<BeneficiaryAirtime> beneficiary = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){

          beneficiary.add(BeneficiaryAirtime.fromJson(dat));
        });

        result['beneficiaryAirtime'] = beneficiary;
      }
    } catch (error) {


    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> gethistory({String token,  business_uuid, bool isPersonal, start_date, end_date,}) async {
    Map<String, dynamic> result = {};
    // final String url = "${Env.testing}/bills/history";
    // ""
    // "$start_date/$end_date/$page_index/$page_size";

    String url ;
    if(start_date == null && end_date == null){
      url  =  "${Env.testing}/bills/history";
    }else{
      url  =  "${Env.testing}/bills/history?start=$start_date&end=$end_date";
    }
print(url);
    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" :  "$business_uuid"
    };

    var headersPer = {
      "Authorization" : "Bearer $token",

    };
    try {
      var response = await http.get(url, headers: isPersonal ? headersPer : headers).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(statusCode);
      print(jsonDecode(response.body));

      if (statusCode != 200 && statusCode != 500) {
        result["statusCode"] = statusCode;
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;

      } else if (statusCode == 500) {

        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;

        List<AirtimeData> billsHistory = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){

          billsHistory.add(AirtimeData.fromJson(dat));



        });
        result['billsHistory'] = billsHistory;


      }
    } catch (error) {
      // print(error.toString());
      result["message"] = error.toString();
    }
    print(result);
    return result;
  }


  @override
  Future<Map<String, dynamic>> fetchCableName(
      {String token, String card_iuc_number, paycode, amount}) async {
    Map<String, dynamic> result = {};
    final String url = "${Env
        .testing}/bills/lookup/cable-tv/${card_iuc_number}/${paycode}/${amount}";

    var header = {
      "Authorization": "Bearer $token",

    };
    try {
      var response = await http.get(url, headers: header).timeout(
          Duration(seconds: 30));
      int statusCode = response.statusCode;

      // print(statusCode);
      // print(response.body);
      if (statusCode != 200 && statusCode != 500) {
        result["statusCode"] = statusCode;
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        var cable = Cable.fromJson(jsonDecode(response.body)["data"]);
        result["cable"] = cable;
      }
    } catch (error) {
      print(error.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> airtime(
      {String token, reference, paycode, amount, save_beneficiary, bool isPersonal, business_uuid}) async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/bills/airtime";

    var header = {
      "Authorization": "Bearer $token",
      // "content-Type" :"application/json",
    };

    var body = {
      "paycode": paycode,
      "reference": reference,
      "amount": amount,

      "save_beneficiary": save_beneficiary ? "1" : "0"
    };
    print(body);
    try {
      var response = await http.post(
          url, body: body, headers: header).timeout(
          Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(response.body);
      if (statusCode != 200 && statusCode != 500) {
        result["statusCode"] = statusCode;
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        var data = AirtimeData.fromJson(jsonDecode(response.body)["data"]);
      result["data"] = data;
      }
    } catch (error) {
      print(error.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> fetchinternetService({String token, paycode, account_number}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/bills/lookups/internet/$account_number/$paycode";

    var header = {
      "Authorization": "Bearer $token",

    };
    try {
      var response = await http.get(url, headers: header).timeout(
          Duration(seconds: 30));
      int statusCode = response.statusCode;

      // print(statusCode);
      print(response.body);
      if (statusCode != 200 && statusCode != 500) {
        result["statusCode"] = statusCode;
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
      }
    } catch (error) {
      print(error.toString());
    }
    return result;
  }


  @override
  Future<Map<String, dynamic>> fetchmetername({String token, paycode ,meter_number})async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/bills/lookup/meter/$meter_number/$paycode";

    var header ={
      "Authorization" : "Bearer $token",

    };

    print(url);
    try {
      var response = await http.get(url, headers: header).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      // print(statusCode);
      print(response.body);
      if (statusCode != 200 && statusCode != 500) {
        result["statusCode"] = statusCode;
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        var meter = Meter.fromJson(jsonDecode(response.body)["data"]);
        result["meter"] = meter;

      }
    } catch (error) {
      print(error.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> cable({String token, paycode, reference, cable_name,  amount, save_beneficiary, bool isPersonal, business_uuid})async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/bills/cable-tv";

    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" :  "$business_uuid"
    };

    var headersPer = {
      "Authorization" : "Bearer $token",

    };
    var body = {
      "paycode": paycode,
      "reference": reference,
      "amount": amount,
      "reference_data": cable_name,
      "save_beneficiary": save_beneficiary ? "1" : "0"
    };
    print(body);
    try {
      var response = await http.post(
          url, body: jsonEncode(body), headers: isPersonal ? headersPer : headers).timeout(
          Duration(seconds: 30));
      int statusCode = response.statusCode;

      // print(statusCode);
      // print(response.body);
      if (statusCode != 200 && statusCode != 500) {
        result["statusCode"] = statusCode;
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        var data = AirtimeData.fromJson(jsonDecode(response.body)["data"]);
        result["data"] = data;
      }
    } catch (error) {
      print(error.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> electricy({String token, paycode, reference,  meter_number_details, amount, save_beneficiary, bool isPersonal, business_uuid}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/bills/electricity";

    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" :  "$business_uuid"
    };

    var headersPer = {
      "Authorization" : "Bearer $token",

    };

    var body = {
      "paycode": paycode,
      "reference": reference,
      "amount": amount,
      "reference_data": meter_number_details,
      "save_beneficiary": save_beneficiary ? "1" : "0"
    };
    print(body);

    print(url);
    try {
      var response = await http.post(
          url, body: body,headers: isPersonal ? headersPer : headers).timeout(
          Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(statusCode);
      print(jsonDecode(response.body)["data"]);

      // print(jsonDecode(response.body)["data"]["token"]);
      // print(jsonDecode(response.body)["data"]["units"]);
      if (statusCode != 200 && statusCode != 500) {
        result["statusCode"] = statusCode;
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        var data = AirtimeData.fromJson(jsonDecode(response.body)["data"]);
        print(data.unit);
        print(data.token);
        result["data"] = data;
      }
    } catch (error) {
      print(error.toString());
    }
    print(result);

    return result;
  }

  @override
  Future<Map<String, dynamic>> internet({String token,  paycode, reference, account_name, amount, save_beneficiary, bool isPersonal, business_uuid}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/bills/internet";
    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" :  "$business_uuid"
    };

    var headersPer = {
      "Authorization" : "Bearer $token",

    };

    var body = {
      "paycode": paycode,
      "reference": reference,
      "amount": amount,
      "reference_data": account_name,
      "save_beneficiary": save_beneficiary ? "1" : "0"
    };
    print(body);
    try {
      var response = await http.post(url, body: body,  headers: isPersonal ? headersPer : headers).timeout(
          Duration(seconds: 30));
      int statusCode = response.statusCode;

      // print(statusCode);
      print(response.body);
      if (statusCode != 200 && statusCode != 500) {
        result["statusCode"] = statusCode;
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        var data = AirtimeData.fromJson(jsonDecode(response.body)["data"]);
        result["data"] = data;
      }
    } catch (error) {

    }
    return result;
  }

  }








