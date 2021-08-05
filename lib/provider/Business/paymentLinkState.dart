

import 'package:flutter/cupertino.dart';
import 'package:glade_v2/api/Business/PaymentLink/paymentLink.dart';
import 'package:glade_v2/core/models/apiModels/Business/PaymentLink/paymentLinkhistory.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/VirtualcardCurrency.dart';
import 'package:glade_v2/pages/settings/change_font_size_page.dart';

abstract class AbstractPaymentLinkViewModel {
  Future<Map<String, dynamic>> paymentLink({String token, business_uuid,  image, state, title, description,  amount, quantity, currency, bool is_fixed, type,  bool show_quantity, bool accept_number, bool payer_bears_fees, custom_link, custom_message, frequency, redirect_url, frequency_value, bool is_ticket, ticket_data, List event_data, ticket_currency });
  Future<Map<String, dynamic>> paymentLinkHistory({String token, business_uuid});
  Future<Map<String, dynamic>> paymentLinkCurrency({String token});
  Future<Map<String, dynamic>> deleteLink({String token, link_id, business_uuid});
  Future<Map<String, dynamic>> getAPaymentLink({String token, logo_image, link_name, description, link_url, amount, amount_type, thankyou_note, bool accept_quantity, bool charge_bearer, link_id});
  Future<Map<String, dynamic>> getAvailableLink({String token, link, business_uuid});
}


class PaymentLinkState with ChangeNotifier implements AbstractPaymentLinkViewModel{

  //  Currency
  List<PaymentLinkCurrency> _currencies= [];
  List<PaymentLinkCurrency> get currencies => _currencies;
  set currencies(List<PaymentLinkCurrency> currencies1) {
    _currencies = currencies1;
    notifyListeners();
  }

//  Countries
  List<PaymentLinkHistory> _paymentLinkHistoryList= [];
  List<PaymentLinkHistory> get paymentLinkHistoryList  => _paymentLinkHistoryList;
  set paymentLinkHistoryList(List<PaymentLinkHistory> paymentLinkHistory1) {
    _paymentLinkHistoryList = paymentLinkHistory1;
    notifyListeners();
  }



  @override
  Future<Map<String, dynamic>> deleteLink({String token, link_id, business_uuid}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await PaymentLinkImpl().deleteLink(token: token, link_id: link_id, business_uuid: business_uuid);
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
  Future<Map<String, dynamic>> getAPaymentLink({String token, logo_image, link_name, description, link_url, amount, amount_type, thankyou_note, bool accept_quantity, bool charge_bearer, link_id}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await PaymentLinkImpl().getAPaymentLink(token: token, logo_image: logo_image, link_name: link_name, description: description, link_url: link_url, amount: amount, amount_type: amount_type, thankyou_note: thankyou_note, accept_quantity: accept_quantity, charge_bearer: charge_bearer,link_id: link_id);
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
  Future<Map<String, dynamic>> paymentLinkCurrency({String token}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await PaymentLinkImpl().paymentLinkCurrency(token: token);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
      currencies = result["paymentCurrency"];

        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> paymentLinkHistory({String token, business_uuid}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await PaymentLinkImpl().paymentLinkHistory(token: token, business_uuid: business_uuid);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
          // paymentLinkHistoryList = result["paymentLinkHistory"];

        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> paymentLink({String token, business_uuid, image, state, title, description, amount, quantity, currency, bool is_fixed,
    type, bool show_quantity, bool accept_number, bool payer_bears_fees, custom_link, custom_message,
    frequency, redirect_url, frequency_value, bool is_ticket, ticket_data, List event_data, ticket_currency}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await PaymentLinkImpl().paymentLink(token: token, business_uuid: business_uuid, image: image != null ? image : null , state: state, title: title,
          description: description, amount: amount, quantity: quantity, currency: currency, is_fixed: is_fixed, type: type, show_quantity: show_quantity, accept_number: accept_number, payer_bears_fees: payer_bears_fees, custom_link: custom_link, custom_message:
        custom_message, frequency: frequency, frequency_value: frequency_value, is_ticket: is_ticket, ticket_data: ticket_data, event_data: event_data, ticket_currency: ticket_currency, redirect_url: redirect_url,  );
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured';
      }else{
        if(result['error'] == false){
          // paymentLinkHistoryList = result["paymentLinkHistory"];

        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> getAvailableLink({String token, link, business_uuid}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await PaymentLinkImpl().getAvailableLink(token: token, business_uuid: business_uuid, link: link);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
          // paymentLinkHistoryList = result["paymentLinkHistory"];

        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

}