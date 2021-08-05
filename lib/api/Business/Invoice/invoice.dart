
import 'dart:convert';

import 'package:glade_v2/api/Business/AddBusiness/addBusiness.dart';
import 'package:glade_v2/core/models/apiModels/Business/Invoice/InvoiceHistory.dart';
import 'package:glade_v2/core/models/apiModels/Business/Invoice/invoice.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/VirtualcardCurrency.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/apiUrls/env.dart';
import 'package:http/http.dart' as http;


abstract class AbstractInvoice {
  Future<Map<String, dynamic>> invoice({String token, invoice_number, due_date, customer_name, customer_email, cust_address, vat_amount, invoice_note, custPhone,  List items, business_uuid, LoginState loginState, currency, bool ChargeUser,bool fundWallet});
  Future<Map<String, dynamic>> getCurrency({String token, });
  Future<Map<String, dynamic>> history({String token, business_uuid});
  Future<Map<String, dynamic>> generateInvoiceNum({String token, business_uuid});
}


class InvoiceImpl implements AbstractInvoice{
  @override
  Future<Map<String, dynamic>> getCurrency({String token}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/invoice/lookup/currency";

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
        List<VirtualCardCurrency> invoiceCurrency = [];
        (jsonDecode(response.body)['data'] as List).forEach((dat){
          invoiceCurrency.add(VirtualCardCurrency.fromJson(dat));
        });
        result['invoiceCurrency'] = invoiceCurrency;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> invoice({String token,cust_address, invoice_number, custPhone, due_date, customer_name, customer_email, vat_amount, invoice_note, List items, business_uuid, LoginState loginState, currency, bool ChargeUser,bool fundWallet}) async{
    Map<String, dynamic> result = {};
    final String url = "$core/invoice";

    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid": "$business_uuid"
    };
  //   "user_name": "Onuh Abah",
  //   "email": "abahonuh@gmail.com",
  //   "phone": "2348062550416",
  //   "address": "no 50 jakanda road",
  //   "invoice_no": "0000001",
  //   "currency": "NGN",
  //   "due_date": "2021-06-09",
  //   "vat": 2,
  //   "note": "",
  //   "items": [
  //   {
  //   "description": "core i12 laptop",
  //   "price": 250000,
  //   "qty": 2,
  //   "id": 1
  //   },
  //   {
  //   "description": "delivery charges",
  //   "price": 6000,
  //   "qty": 1,
  //   "id": 2
  //   }
  //   ]
  //   "edit_invoice": 1
  // }'

    var body = {
      "currency": currency?.trim(),
      // "user_name" : customer_name,
      "phone": custPhone.trim(),
      "invoice_no" : invoice_number?.trim(),
      "address": cust_address?.trim(),
      "due_date" : due_date?.trim(),
      "name" : customer_name?.trim(),
      "email" : customer_email?.trim(),
      "vat": vat_amount?.trim(),
      "note": invoice_note,
      "items":  jsonEncode(items),
      "charge_user": ChargeUser ? "1" : "0",
      "fund_wallet": fundWallet ? "1" :"0",
    };

    print(body);

    try {
      var response =
          await http.post(url,headers: headers, body: body ).timeout(Duration(seconds: 30));
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
        result["message"] = jsonDecode(response.body)["message"];
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> history({String token, business_uuid})  async{
    Map<String, dynamic> result = {};
    final String url = "$core/invoice";

    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid": "$business_uuid"
    };

print(url);
    try {
      var response =
          await http.get(url,headers: headers).timeout(Duration(seconds: 30));
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
        List<InvoiceHistory> invoiceHistory = [];
        (jsonDecode(response.body)['data'] as List).forEach((dat){
          invoiceHistory.add(InvoiceHistory.fromJson(dat));
        });
        result['invoiceHistory'] = invoiceHistory;

        // List<InvoiceItemsModel> items = [];
        // (jsonDecode(response.body)['data']["items"] as List).forEach((dat){
        //   items.add(InvoiceItemsModel.fromJson(dat));
        // });
        // result['invoiceitems'] = items;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> generateInvoiceNum({String token, business_uuid})async {
    Map<String, dynamic> result = {};
    final String url = "$core/invoice/counter";

    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid": "$business_uuid"
    };

    print(url);
    try {
      var response =
          await http.get(url,headers: headers).timeout(Duration(seconds: 30));
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
          var num = InvoiceNum.fromJson(jsonDecode(response.body));
          result["num"] = num;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }




}





