

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:glade_v2/api/Business/AddBusiness/addBusiness.dart';
import 'package:glade_v2/core/models/apiModels/Business/PaymentLink/paymentLinkhistory.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/VirtualcardCurrency.dart';
import 'package:glade_v2/core/models/apiModels/paymentLink/paymentLink.dart';
import 'package:glade_v2/utils/apiUrls/env.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';











abstract class AbstractPaymentLink {
  Future<Map<String, dynamic>> paymentLink({String token, business_uuid,  image, state, title, description,  amount, quantity, currency, bool is_fixed, type,  bool show_quantity, bool accept_number, bool payer_bears_fees, custom_link, custom_message, frequency, redirect_url, frequency_value, bool is_ticket, ticket_data, List event_data, ticket_currency });
  Future<Map<String, dynamic>> paymentLinkHistory({String token, business_uuid});
  Future<Map<String, dynamic>> paymentLinkCurrency({String token});
  Future<Map<String, dynamic>> deleteLink({String token, link_id, business_uuid});
  Future<Map<String, dynamic>> getAvailableLink({String token, link, business_uuid});
 Future<Map<String, dynamic>> getAPaymentLink({String token, logo_image, link_name, description, link_url, amount, amount_type, thankyou_note, bool accept_quantity, bool charge_bearer, link_id});

}






class PaymentLinkImpl implements AbstractPaymentLink{
  @override
  Future<Map<String, dynamic>> getAPaymentLink({String token, logo_image, link_name, description, link_url, amount, amount_type, thankyou_note, bool accept_quantity, bool charge_bearer, link_id}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/payment/links/$link_id";

    var headers = {
      "Authorization" : "Bearer $token"
    };


    try {
      var response =
          await http.put(url,headers: headers, body: "body" ).timeout(Duration(seconds: 30));
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
        result["message"] = jsonDecode(response.body)["message"];
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> paymentLink({String token, business_uuid,  image, state, title, description,  amount, quantity, currency, bool is_fixed, type,  bool show_quantity, bool accept_number, bool payer_bears_fees, custom_link, custom_message, frequency, redirect_url, frequency_value, bool is_ticket, ticket_data, List event_data, ticket_currency  }) async{
    Dio dio = new Dio();
    Map<String, dynamic> result = {};
    final String url = "${core}/payments/link/save";
        // "${Env.testing}/payment/links";


    var formData = FormData.fromMap({
      "image" : image!= null ? await MultipartFile.fromFile(image.path, filename: image.path.split("/").last, contentType:  MediaType("application", "png"),) : "",
    "title": title,
    "state": state,
    "description":description,
    "amount":amount,
    "quantity": quantity,
    "currency":currency,
    "type":type,
    "frequency": frequency,
    "frequency_value":frequency_value,
    "is_fixed":is_fixed,
    "show_quantity":show_quantity,
    "accept_number":accept_number,
    "payer_bears_fees": payer_bears_fees ? "1" : "0",
    "custom_link":custom_link,
    "delete_image": false,
    "redirect_url":redirect_url,
    "custom_message": custom_message,
    // notification_email:null
    // extra_fields:
    "is_ticket": is_ticket,
    "ticket_data[]": ticket_data,
   " event_data[]":event_data,
    "ticket_currency": ticket_data
    });
    //
    print(formData.fields);
    print(formData.files);
    print( {
      "authorization": "Bearer $token",
      // "Content-type" : "application/json",
    });
    try{
      var resp =  await dio.post(url, data: formData,  options:  Options(
        headers: {
          "authorization": "Bearer $token",
          "content-type" :
          // "application/json",
          "multipart/form-data",
          "business-uuid" : "$business_uuid"

        },

      ) ,
        onSendProgress: (int sent, int total) {
          print("sent${sent.toString()}" + " total${total.toString()}");
        },
      ).whenComplete(() {
        print("complete:");
      }).catchError((onError) {
        print("error:${onError.toString()}");
      });


      print(resp);
      int statusCode = resp.statusCode;
      print("data obj ${resp.data}");
      // print(resp.statusCode);
      if (statusCode != 200 && statusCode != 500) {
        result["message"] = resp.data["message"];
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        result["message"] = resp.data["message"];
      }
    } catch (error) {
      print("from here ${error.toString()}");

    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> paymentLinkHistory({String token, business_uuid}) async{
    Map<String, dynamic> result = {};
    // final String url = "${Env.testing}/payment/links/history";
    final String url = "https://core-test.glade.ng/payments/link";
    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" : "$business_uuid"
    };

    try {
      var response =
          await http.get(url,headers: headers ).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(statusCode);
      log(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
        result["statusCode"] = statusCode;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        List<PaymentLinkItem> paymentLinkHistory = [];
        (jsonDecode(response.body)['data']["links"] as List).forEach((dat){
          paymentLinkHistory.add(PaymentLinkItem.fromJson(dat));
        });
        result['paymentLinkHistory'] = paymentLinkHistory;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> paymentLinkCurrency({String token}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/invoice/lookup/currency";

    var headers = {
      "Authorization" : "Bearer $token"
    };

    // print(url);

    try {
      var response =
          await http.get(url,headers: headers,  ).timeout(Duration(seconds: 30));
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
        List<PaymentLinkCurrency> paymentCurrency = [];
        (jsonDecode(response.body)['data'] as List).forEach((dat){
          paymentCurrency.add(PaymentLinkCurrency.fromJson(dat));
        });
        result['paymentCurrency'] = paymentCurrency;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> deleteLink({String token, link_id, business_uuid})async {
    Map<String, dynamic> result = {};
    final String url ="https://core-test.glade.ng/payments/link/remove/$link_id";
    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" : "$business_uuid"
    };

    try {
      var response =
          await http.delete(url,headers: headers ).timeout(Duration(seconds: 30));
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
        result["message"] = jsonDecode(response.body)["message"];
      }
    } catch (error) {

    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> getAvailableLink({String token, link, business_uuid})async {
    Map<String, dynamic> result = {};
    final String url ="https://core-test.glade.ng/payments/link/geturl/$link";

    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" : "$business_uuid"
    };


    try {
      var response =
          await http.get(url,headers: headers ).timeout(Duration(seconds: 30));
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
        result["message"] = jsonDecode(response.body)["data"]["exists"];
      }
    } catch (error) {

    }

    return result;
  }

}
// https://pay.glade.ng/KuIBcN0hus1620125355Qew