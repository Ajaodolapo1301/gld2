import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:glade_v2/api/Business/AddBusiness/addBusiness.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/BankTransferMode.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/bankModel.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/beneficiaryList.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/countriesModel.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/fetchAccountName.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/internationalFundModel.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/transactionHistory.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/transferMethod.dart';
import 'package:glade_v2/utils/apiUrls/env.dart';
import 'package:http/http.dart' as http;



abstract class AbstractFundTransfer {
  Future<Map<String, dynamic>> getTransactionList({start_date, end_date, page_index, page_size, String token, business_uuid, bool isPersonal});
  Future<Map<String, dynamic>> gladeToGlade({account_number, amount, narration, bool save_beneficiary,String token, business_uuid, bool isPersonal});
  Future<Map<String, dynamic>> gladeToOtherBank({bank_code, account_number, account_name, amount, narration, save_beneficiary, String token, bank_name, business_uuid,  bool isPersonal});
  Future<Map<String, dynamic>> internationalTransfer({currency_code, business_uuid, bool isPersonal, beneficiary_bank_branch,  currency, bank_code, beneficiary_account_number, beneficiary_name, amount, narration, bool save_beneficiary, String token});
  Future<Map<String, dynamic>> getMode({String token});

  Future<Map<String, dynamic>> FetchAcountNameInternal({String token, accoutNum, mode,business_uuid, bool isPersonal });
  Future<Map<String, dynamic>> FetchAcountNameExternal({String token, accoutNum, mode, bankCode });
  Future<Map<String, dynamic>> FetchAcountNameInternational({String token, accoutNum, mode, countryCode, BankCode });

  Future<Map<String, dynamic>> getCountries({String token, business_uuid, bool isPersonal});
  Future<Map<String, dynamic>> getTransferMethod({String token, country_code, business_uuid,  bool isPersonal});
  Future<Map<String, dynamic>> getBanks({String token, mode});
  Future<Map<String, dynamic>> getBanksInternational({String token, country_code, business_uuid, method_id, bool isPersonal});

  Future<Map<String, dynamic>> getMobileInternational({String token, country_code, business_uuid, method_id, bool isPersonal});
  Future<Map<String, dynamic>> getBankBranchInternational({String token, country_code, bank_id, business_uuid,  bool isPersonal});
  Future<Map<String, dynamic>> transferFee({String token, amount, source_currency, destination_currency, business_uuid,  bool isPersonal});


  Future<Map<String, dynamic>> bulkTransferExternal({List bulkItem,  String token});
  Future<Map<String, dynamic>> beneficiaryList({String token, business_uuid, bool isPersonal, mode});

}




class FundTransferImpl implements AbstractFundTransfer{

  @override
  Future<Map<String, dynamic>> bulkTransferExternal({ List bulkItem, String token})async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/transfers/external/bulk";
    // var body = {
    //   "bank_code" : bulkItem,
    //   // "account_name": account_name.trim(),
    //   // "account_number" : account_number.trim(),
    //   // "amount": amount.trim(),
    //   // "narration" : narration.trim(),
    //   // "save_beneficiary" : save_beneficiary,
    // };


    var headers = {
      "Authorization" : "Bearer $token",
      "content-Type":  "application/json"
    };

    print(bulkItem);
    print(url);

    try {
      var response =
          await http.post(url, body: jsonEncode(bulkItem), headers: headers).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(statusCode);
      print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result["statusCode"] = statusCode;
        result['error'] = true;
      } else if (statusCode == 500) {
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;

        result["message"] = jsonDecode(response.body)["message"];
        // List<BankModel> bankList = [];
        //
        // (jsonDecode(response.body)['data'] as List).forEach((dat){
        //   bankList.add(BankModel.fromJson(dat));
        // });
        // result['bankList'] = bankList;
      }
    } catch (error) {
      // print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> getBanks({String token, mode}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/transfers/lookup/banks/$mode";
    var headers = {
      "Authorization" : "Bearer $token"
    };
    // print(url);
    try {
      var response =
          await http.get(url, headers: headers).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      // print(statusCode);
      // print(response.body);
      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["error"];
        result["statusCode"] = statusCode;

        result['error'] = true;
      } else if (statusCode == 500) {

        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        List<BankModel> bankList = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){
          bankList.add(BankModel.fromJson(dat));
        });
        result['bankList'] = bankList;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> getCountries({String token, business_uuid, bool isPersonal}) async{
    Map<String, dynamic> result = {};
    final String url =
        // "${core}transfers/foreign/countries";
        "${Env.testing}/transfers/lookup/international/countries";

    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" :  "$business_uuid"
    };

    var headersPer = {
      "Authorization" : "Bearer $token",

    };
    print(url);
    print(headers);
    try {
      var response = await http.get(url, headers: isPersonal ? headersPer : headers).timeout(Duration(minutes: 1));
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
        List<CountriesModel> countriesList = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){
          countriesList.add(CountriesModel.fromJson(dat));
        });
        result['countriesList'] = countriesList;
      }
    } catch (error) {

      // result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> getMode({String token}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/transfers/lookup/modes";
    var headers = {
      "Authorization" : "Bearer $token"
    };
    try {
      var response = await http.get(url, headers: headers).timeout(Duration(minutes:1));
      int statusCode = response.statusCode;

      // print(statusCode);
      // print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["error"];
        result['error'] = true;
        result["statusCode"] = statusCode;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        List<BankTransferMode> bankTransferMode = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){
          bankTransferMode.add(BankTransferMode.fromJson(dat));
        });
        result['bankTransferMode'] = bankTransferMode;
      }
    } catch (error) {
      // print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> getTransactionList({start_date, end_date, page_index, page_size, String token, business_uuid, bool isPersonal}) async{
    Map<String, dynamic> result = {};
     String url ;
    if(start_date == null && end_date == null){
      url  = "${Env.testing}/transfers/history";
    }else{
      url  =  "${Env.testing}/transfers/history?date_from=$start_date&date_to=$end_date";
    }
    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" :  "$business_uuid",
    "business_uuid" :  "$business_uuid"
    };

    var headersPer = {
      "Authorization" : "Bearer $token",

    };


    try {
      var response = await http.get(url, headers: isPersonal ? headersPer : headers).timeout(Duration(minutes : 1));
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
        List<TransferHistory> transferHistoryList = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){
          transferHistoryList.add(TransferHistory.fromJson(dat));
        });
        result['transferHistoryList'] = transferHistoryList;
      }
    } catch (error) {
      // print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> getTransferMethod({String token, country_code, business_uuid,  bool isPersonal}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/transfers/lookup/international/$country_code/methods";
    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" :  "$business_uuid"
    };

    var headersPer = {
      "Authorization" : "Bearer $token",

    };

    print(url);
    try {
      var response = await http.get(url, headers: isPersonal ? headersPer : headers).timeout(Duration(minutes: 1));
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
        List<TransferMethod> transferMethod = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){
          transferMethod.add(TransferMethod.fromJson(dat));
        });
        result['transferMethod'] = transferMethod;
      }
    } catch (error) {
      // print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> gladeToGlade({ account_number, amount, narration, bool save_beneficiary, String token, business_uuid, bool isPersonal})async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/transfers/internal";

    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" :  "$business_uuid"
    };

    var headersPer = {
      "Authorization" : "Bearer $token",

    };
    var body = {
      // "account_name": account_name.trim(),
      "account_number" : account_number.trim(),
      "amount": amount.trim(),
      "narration" : narration.trim(),
      "save_beneficiary" : save_beneficiary ? "1" : "0",
    };
    // print(body);
    // print(isPersonal);
    try {
      var response = await http.post(url, body: body, headers: isPersonal ? headersPer : headers).timeout(Duration(minutes: 1));
      int statusCode = response.statusCode;

      // print(statusCode);
      // print(response.body);
      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result["statusCode"] = statusCode;
        result['error'] = true;
      } else if (statusCode == 500) {
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        var transferHistory = TransferHistory.fromJson(jsonDecode(response.body)["data"]);
        result["transferhistory"] = transferHistory;
      }
    } catch (error) {
      // print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> gladeToOtherBank({bank_code, account_number, account_name, amount, narration, save_beneficiary, String token, bank_name,business_uuid,  bool isPersonal }) async{
    Map<String, dynamic> result = {};

    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" :  "$business_uuid"
    };

    var headersPer = {
      "Authorization" : "Bearer $token",

    };

    final String url = "${Env.testing}/transfers/external";
    // var headers = {
    //   "Authorization" : "Bearer $token"
    // };
    var body = {
        "beneficiary_bank_name" : bank_name.trim(),
      "beneficiary_bank" : bank_code.trim(),
      "beneficiary_account_name": account_name.trim() ,
      // account_name.trim(),
      "beneficiary_account_number" : account_number.trim(),
      "amount": amount.trim(),
      "narration" :   narration.trim(),
      "save_beneficiary" : save_beneficiary ? "1 " : "0",
    };

    print(body);
    try {
      var response = await http.post(url, body: body, headers: isPersonal ? headersPer : headers).timeout(Duration(minutes: 1));
      int statusCode = response.statusCode;

      // print(statusCode);
      // print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result["statusCode"] = statusCode;
        result['error'] = true;
      } else if (statusCode == 500) {
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        var transferHistory = TransferHistory.fromJson(jsonDecode(response.body)["data"]);
        result["transferhistory"] = transferHistory;
      }
    } catch (error) {
      // print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> internationalTransfer({currency_code, business_uuid, bool isPersonal, beneficiary_bank_branch,  currency, bank_code, beneficiary_account_number, beneficiary_name, amount, narration, bool save_beneficiary, String token})async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/transfers/international";
    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" :  "$business_uuid"
    };

    var headersPer = {
      "Authorization" : "Bearer $token",

    };



    var body = {
      "currency_code": currency_code.trim(),
      "beneficiary_bank" : bank_code.trim(),
      "beneficiary_name": beneficiary_name.trim(),
      "beneficiary_account_number" : beneficiary_account_number.trim(),
      "amount": amount.trim(),
      "narration" : narration ?? "",
      "save_beneficiary" : save_beneficiary ? "1" :"0",
      "beneficiary_bank_branch": beneficiary_bank_branch
    };

// print(body);
// print(url);
// print(headersPer);
    try {
      var response = await http.post(url, body: body, headers: isPersonal ? headersPer : headers).timeout(Duration(minutes: 1));
      int statusCode = response.statusCode;

      print(statusCode);
      print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
        result["statusCode"] = statusCode;
        result['error'] = true;
      } else if (statusCode == 500) {
        result["message"] = "Internal Server Error";
      } else {
       result["error"] = false;
var transferHistory = TransferHistory.fromJson(jsonDecode(response.body)["data"]);
result["transferhistory"] = transferHistory;
      }
    } catch (error) {
      // print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> beneficiaryList({String token, business_uuid, bool isPersonal, mode})async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/transfers/lookup/beneficiaries/$mode";

    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" :  "$business_uuid"
    };

    var headersPer = {
      "Authorization" : "Bearer $token",

    };

// print(url);
    try {
      var response = await http.get(url, headers: isPersonal ? headersPer : headers).timeout(Duration(minutes: 1));
      int statusCode = response.statusCode;

      // print(statusCode);
      print(response.body);
      print(jsonDecode(response.body)["token"]);
      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
        result["statusCode"] = statusCode;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        List<BeneficiaryList> beneficiaryList = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){
          beneficiaryList.add(BeneficiaryList.fromJson(dat));
        });
        result['beneficiaryList'] = beneficiaryList;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> FetchAcountNameInternal({String token, accoutNum, mode,business_uuid, bool isPersonal }) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/transfers/lookup/account/$mode/$accoutNum";

    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" :  "$business_uuid"
    };

    var headersPer = {
      "Authorization" : "Bearer $token",

    };
    // print(url);
    try {
      var response = await http.get(url, headers: isPersonal ? headersPer : headers).timeout(Duration(minutes: 1));
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
        var accountname = AccountName.fromJson(jsonDecode(response.body)["data"]);

        print(accountname);
         result["accountName"] = accountname;
      }
    } catch (error) {
      // print(error.toString());

    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> FetchAcountNameExternal({String token, accoutNum, mode, bankCode}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/transfers/lookup/account/external_local/$accoutNum?bank_code=$bankCode";

    var headers = {
      "Authorization" : "Bearer $token"
    };
    // print(url);
    try {
      var response = await http.get(url, headers: headers).timeout(Duration(minutes: 1));
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
        var accountname = AccountName.fromJson(jsonDecode(response.body)["data"]);
        result["accountName"] = accountname;
      }
    } catch (error) {
      // print(error.toString());
      // result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> FetchAcountNameInternational({String token, accoutNum, mode, countryCode, BankCode})async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/lookup/account/international/$mode/$accoutNum/$BankCode/$countryCode";

    var headers = {
      "Authorization" : "Bearer $token"
    };
    try {
      var response = await http.get(url, headers: headers).timeout(Duration(minutes: 1));
      int statusCode = response.statusCode;

      // print(statusCode);
      // print(response.body);
      // print(jsonDecode(response.body)["token"]);
      if (statusCode != 200 && statusCode != 500) {
        result["statusCode"] = statusCode;
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        var accountname = AccountName.fromJson(jsonDecode(response.body));
        result["accountName"] = accountname;
      }
    } catch (error) {
      // print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> transferFee({String token, amount, source_currency, destination_currency, business_uuid,  bool isPersonal}) async{
    Map<String, dynamic> result = {};
    final String url =

        "${Env.testing}/transfers/lookup/international/rate?amount=$amount&source_currency=$source_currency&destination_currency=$destination_currency";

    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" :  "$business_uuid"
    };

    var headersPer = {
      "Authorization" : "Bearer $token",

    };
//     print(url);
// print(headersPer);
    try {
      var response = await http.get(url, headers: isPersonal ? headersPer : headers).timeout(Duration(minutes: 1));
      int statusCode = response.statusCode;

      // print(statusCode);
      print(" transfe${jsonDecode(response.body)}");

      if (statusCode != 200 && statusCode != 500) {
        result["statusCode"] = statusCode;
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
      var transferFee =  TransferFee.fromJson(jsonDecode(response.body)["data"]);

      result["transferFee"] = transferFee;
      }
    } catch (error) {


    }
print("res $result");
    return result;
  }

  @override
  Future<Map<String, dynamic>> getBankBranchInternational({String token, country_code, business_uuid,  bool isPersonal, bank_id}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/transfers/lookup/international/$country_code/$bank_id/branches";

    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" :  "$business_uuid"
    };

    var headersPer = {
      "Authorization" : "Bearer $token",

    };
    print(url);
    try {
      var response = await http.get(url, headers: isPersonal ? headersPer : headers).timeout(Duration(minutes: 1));
      int statusCode = response.statusCode;
      //
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
        List<BankIntlBranchList> bankIntlBranchList = [];
        (jsonDecode(response.body)['data'] as List).forEach((dat){
          bankIntlBranchList.add(BankIntlBranchList.fromJson(dat));
        });
        result['bankIntlBranchList'] = bankIntlBranchList;
      }
    } catch (error) {
      // print(error.toString());

    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> getBanksInternational({String token, country_code, method_id, business_uuid,  bool isPersonal})async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/transfers/lookup/international/$country_code/$method_id/banks";

    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" :  "$business_uuid"
    };

    var headersPer = {
      "Authorization" : "Bearer $token",

    };
    print(url);
    try {
      var response = await http.get(url, headers: isPersonal ? headersPer : headers).timeout(Duration(minutes: 1));
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
        List<BankIntlList> bankIntlList = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){
          bankIntlList.add(BankIntlList.fromJson(dat));
        });
        result['bankIntlList'] = bankIntlList;
      }
    } catch (error) {
      // print(error.toString());

    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> getMobileInternational({String token, country_code, business_uuid, method_id, bool isPersonal}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/transfers/lookup/international/$country_code/$method_id/banks";

    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" :  "$business_uuid"
    };

    var headersPer = {
      "Authorization" : "Bearer $token",

    };
    print(url);
    try {
      var response = await http.get(url, headers: isPersonal ? headersPer : headers).timeout(Duration(minutes: 1));
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
        List<MobileMoney> mobileMoney = [];
        (jsonDecode(response.body)['data'] as List).forEach((dat){
          mobileMoney.add(MobileMoney.fromJson(dat));
        });
        result['mobileMoney'] = mobileMoney;
      }
    } catch (error) {

    }

    return result;
  }

}



