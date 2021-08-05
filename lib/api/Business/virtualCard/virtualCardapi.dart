import 'dart:convert';


import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/VirtualCardModel.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/VirtualTransaction.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/VirtualcardCurrency.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/virtualCardDesign.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/virtualCardList.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/virtualCardTitle.dart';
import 'package:glade_v2/utils/apiUrls/env.dart';
import 'package:http/http.dart' as http;
abstract class AbstractVcard {
  Future<Map<String, dynamic>> getListOfCard({String token, business_uuid,  bool isPersonal});
  Future<Map<String, dynamic>> createVcard({card_title, currency, amount, design_code, String token, business_uuid, bool isPersonal, country });
  Future<Map<String, dynamic>> getCardDetails({cardId, String token,  business_uuid,  bool isPersonal});
  Future<Map<String, dynamic>> fundCard({card_id, amount, String token, business_uuid, bool isPersonal});
  Future<Map<String, dynamic>> terminateCard({card_id, String token, business_uuid, bool isPersonal});
  Future<Map<String, dynamic>> unfreezeCard({card_id, String token, business_uuid, bool isPersonal});
  Future<Map<String, dynamic>> freezeCard({card_id, String token, business_uuid, bool isPersonal});
  Future<Map<String, dynamic>> withdraw({card_id, amount, String token, business_uuid, bool isPersonal});
  Future<Map<String, dynamic>> transactionList({card_id, String token, business_uuid, bool isPersonal});
  Future<Map<String, dynamic>> getCardTitles({String token});
  Future<Map<String, dynamic>> getCardDesigns({String token});
  Future<Map<String, dynamic>> getCardCurrencies({String token});
}



class VirtualCardImpl implements AbstractVcard{
  @override
  Future<Map<String, dynamic>> createVcard({card_title, currency, amount, design_code, String token,  business_uuid, bool isPersonal, country })async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/virtual-cards";
    var body = {
      "card_title": card_title.trim(),
      "currency": currency.trim(),
      "amount": amount.trim(),
      "country": country,
      "design_code": design_code.trim(),
    };

    print("my body$body");
    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" :  "$business_uuid"
    };

    var headersPer = {
      "Authorization" : "Bearer $token",

    };

    print(headers);
    try {
      var response = await http.post(url, body: body, headers: isPersonal ? headersPer: headers).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(statusCode);
      print(response.body);
      print(isPersonal);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
        result["statusCode"] = statusCode;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        // var virtualCard = VirtualCardModel.fromJson(json.decode(response.body)["data"]);
        // result['virtualCard'] = virtualCard;
          result["card_id"] = jsonDecode(response.body)["data"]["card_id"];


      }
    } catch (error) {
      print(error.toString());

    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> freezeCard({card_id, token, business_uuid, bool isPersonal}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/virtual-cards/$card_id/freeze";

    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" :  "$business_uuid"
    };

    var headersPer = {
      "Authorization" : "Bearer $token",

    };
    try {
      var response =
          await http.put(url, headers: isPersonal ? headersPer: headers ).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(statusCode);
      print(response.body);
      print(jsonDecode(response.body)["token"]);
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
  Future<Map<String, dynamic>> fundCard({card_id, amount, String token, business_uuid, bool isPersonal}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/virtual-cards/$card_id/fund";
    print(url);
    var body = {
      "amount": amount.trim(),

    };
    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" :  "$business_uuid"
    };

    var headersPer = {
      "Authorization" : "Bearer $token",

    };
    print("my body$body");

    try {
      var response =
          await http.post(url, body: body, headers: isPersonal? headersPer: headers).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(statusCode);
      print(response.body);
      print(jsonDecode(response.body)["token"]);
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
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> getCardCurrencies({String token})async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/virtual-cards/lookup/currencies";

    var headers = {
      "Authorization" : "Bearer $token"
    };


    try {
      var response =
          await http.get(url,headers: headers ).timeout(Duration(seconds: 30));
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
        List<VirtualCardCurrency> virtualCardCurrency = [];
        (jsonDecode(response.body)['data'] as List).forEach((dat){
          virtualCardCurrency.add(VirtualCardCurrency.fromJson(dat));
        });
        result['virtualCardCurrency'] = virtualCardCurrency;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> getCardDesigns({String token}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/virtual-cards/lookups/designs";

    var headers = {
      "Authorization" : "Bearer $token"
    };

    try {
      var response =
          await http.get(url, headers: headers ).timeout(Duration(seconds: 30));
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
        List<VirtualCardDesign> virtualCardDesign = [];
        (jsonDecode(response.body)['data'] as List).forEach((dat){
          virtualCardDesign.add(VirtualCardDesign.fromJson(dat));
        });
        result['virtualCardDesign'] = virtualCardDesign;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> getCardDetails({cardId, token, business_uuid,  bool isPersonal }) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/virtual-cards/$cardId";


    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" :  "$business_uuid"
    };

    var headersPer = {
      "Authorization" : "Bearer $token",

    };

    try {
      var response =
          await http.get(url, headers: isPersonal ? headersPer : headers).timeout(Duration(seconds: 30));
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
        print(json.decode(response.body)["error"]);
        var virtualDetails = VirtualCardModel.fromJson(json.decode(response.body)["data"]);

        result['virtualDetails'] = virtualDetails;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> getCardTitles({String token}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/virtual-cards/lookup/titles";

    var headers = {
      "Authorization" : "Bearer $token"
    };


    try {
      var response =
          await http.get(url, headers: headers).timeout(Duration(seconds: 30));
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
        List<VirtualCardTitle> virtualCardTitle = [];
        (jsonDecode(response.body)['data'] as List).forEach((dat){
          virtualCardTitle.add(VirtualCardTitle.fromJson(dat));
        });
        result['virtualCardTitle'] = virtualCardTitle;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> getListOfCard({String token, business_uuid,  bool isPersonal }) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/virtual-cards";

    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" :  "$business_uuid"
    };

    var headersPer = {
      "Authorization" : "Bearer $token",

    };
    print(isPersonal);
    try {
      var response =
          await http.get(url,headers: isPersonal ? headersPer : headers ).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(statusCode);
      print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["error"];
        result["statusCode"] = statusCode;
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;

        List<VirtualCardList> virtualCardList = [];
        (jsonDecode(response.body)['data'] as List).forEach((dat){
          virtualCardList.add(VirtualCardList.fromJson(dat));
        });
        result['virtualCardList'] = virtualCardList;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> terminateCard({card_id, token, business_uuid, bool isPersonal}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/virtual-cards/${card_id}/terminate";

    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" :  "$business_uuid"
    };

    var headersPer = {
      "Authorization" : "Bearer $token",

    };
    try {
      var response =
          await http.delete(url, headers: isPersonal ? headersPer : headers ).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(statusCode);
      print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
      result["statusCode"] = statusCode;
        print("eeroror${result["message"]}");
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
  Future<Map<String, dynamic>> transactionList({card_id, token, business_uuid, bool isPersonal}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/virtual-cards/$card_id/transactions";

    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" :  "$business_uuid"
    };

    var headersPer = {
      "Authorization" : "Bearer $token",

    };
    try {
      var response =
          await http.get(url, headers: isPersonal ? headersPer: headers).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(statusCode);
      print(response.body);
      print(jsonDecode(response.body)["token"]);
      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result["statusCode"] = statusCode;
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        List<VirtualCardTransaction> virtualCardTransaction = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){
          virtualCardTransaction.add(VirtualCardTransaction.fromJson(dat));
        });
        result['virtualCardTransaction'] = virtualCardTransaction;



      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> unfreezeCard({card_id, token, business_uuid, bool isPersonal}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/virtual-cards/$card_id/unfreeze";


    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" :  "$business_uuid"
    };

    var headersPer = {
      "Authorization" : "Bearer $token",

    };

    try {
      var response =
          await http.put(url, headers: isPersonal ? headersPer : headers).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(statusCode);
      print(response.body);
      print(jsonDecode(response.body)["token"]);
      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result["statusCode"] = statusCode;
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
  Future<Map<String, dynamic>> withdraw({card_id, amount, token, business_uuid, bool isPersonal}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/virtual-cards/$card_id/withdraw";


var body = {
  "amount" : amount.trim()

};



    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" :  "$business_uuid"
    };

    var headersPer = {
      "Authorization" : "Bearer $token",

    };
    try {
      var response =
          await http.post(url, body: body, headers: isPersonal ? headersPer : headers).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(statusCode);
      print(response.body);
      print(jsonDecode(response.body)["token"]);
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

}