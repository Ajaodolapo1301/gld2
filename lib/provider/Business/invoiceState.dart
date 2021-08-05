

import 'package:flutter/cupertino.dart';
import 'package:glade_v2/api/Business/Invoice/invoice.dart';
import 'package:glade_v2/core/models/apiModels/Business/Invoice/InvoiceHistory.dart';
import 'package:glade_v2/core/models/apiModels/Business/Invoice/invoice.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/VirtualcardCurrency.dart';

import '../loginState.dart';

abstract class AbstractInvoiceViewModel {
  Future<Map<String, dynamic>> invoice({String token, cust_address, invoice_number, due_date, customer_name, customer_email, vat_amount, invoice_note, custPhone,  List items, business_uuid, LoginState loginState, currency, shipping_fee});
  Future<Map<String, dynamic>> getCurrency({String token});
  Future<Map<String, dynamic>> history({String token, business_uuid});
  Future<Map<String, dynamic>> generateInvoiceNum({String token, business_uuid});
}


class InvoiceState with ChangeNotifier implements AbstractInvoiceViewModel{

//currency
  List<VirtualCardCurrency> _currencies= [];
  List<VirtualCardCurrency> get currencies => _currencies;
  set currencies(List<VirtualCardCurrency> currencies1) {
    _currencies = currencies1;
    notifyListeners();
  }

//  History
  List<InvoiceHistory> _invoiceHistory= [];
  List<InvoiceHistory> get invoiceHistory => _invoiceHistory;
  set invoiceHistory(List<InvoiceHistory> invoiceHistory1) {
    _invoiceHistory = invoiceHistory1;
    notifyListeners();
  }



  @override
  Future<Map<String, dynamic>> getCurrency({String token}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await InvoiceImpl().getCurrency(token: token);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
          currencies = result["invoiceCurrency"];
        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> invoice({String token, cust_address, invoice_number, due_date, customer_name, customer_email, vat_amount, invoice_note, custPhone,  List items, business_uuid, LoginState loginState, currency, bool ChargeUser,bool fundWallet, shipping_fee}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await InvoiceImpl().invoice(token: token, invoice_note: invoice_note, invoice_number: invoice_number, customer_email: customer_email, customer_name: customer_name, vat_amount: vat_amount, items: items, due_date: due_date, business_uuid: business_uuid, currency: currency, custPhone: custPhone, loginState: loginState, ChargeUser: ChargeUser,   cust_address: cust_address, fundWallet: fundWallet, );
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){

        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> history({String token, business_uuid}) async {
    Map<String, dynamic> result = Map();

    try{
      result = await InvoiceImpl().history(token: token, business_uuid: business_uuid);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
          invoiceHistory = result["invoiceHistory"];
        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> generateInvoiceNum({String token, business_uuid}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await InvoiceImpl().generateInvoiceNum(token: token, business_uuid: business_uuid);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{


      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

}