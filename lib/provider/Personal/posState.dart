

import 'package:flutter/cupertino.dart';
import 'package:glade_v2/api/Personal/POS/pos.dart';
import 'package:glade_v2/core/models/apiModels/Personal/GoLive/StateAndLGA.dart' ;
import 'package:glade_v2/core/models/apiModels/Personal/POS/pos.dart';

abstract class AbstractPOSViewModel {
  Future<Map<String, dynamic>> getRevenue({String token, });
  Future<Map<String, dynamic>> getSales({String token, });
  Future<Map<String, dynamic>> getStates({String token,});
  Future<Map<String, dynamic>> getLGAs({String token,  String state_id});
  Future<Map<String, dynamic>> POS({String token, revenue_id, sales_id, delivery_address, state, lga, additional_note, quantity, business_uuid, bool isPersonal });
  Future<Map<String, dynamic>> posPending({String token, business_uuid, bool isPersonal });
  Future<Map<String, dynamic>> posApproved({String token, business_uuid, bool isPersonal });
}



class POSState with ChangeNotifier implements AbstractPOSViewModel{



  List<LGA> _lga= [];
  List<LGA> get lga => _lga;
  set lga(List<LGA> lga1) {
    _lga = lga1;
    notifyListeners();
  }


  List<States> _states= [];
  List<States> get states => _states;
  set states(List<States> states1) {
    _states = states1;
    notifyListeners();
  }





  List<Revenue> _revenue = [];
  List<Revenue> get revenue => _revenue;
  set revenue(List<Revenue> revenue1) {
    _revenue = revenue1;
    notifyListeners();
  }


  List<Sales> _sales= [];
  List<Sales> get sales => _sales;
  set sales(List<Sales> sales1) {
    _sales = sales1;
    notifyListeners();
  }






  @override
  Future<Map<String, dynamic>> POS({String token, revenue_id, sales_id, delivery_address, state, lga, additional_note, quantity, business_uuid, bool isPersonal})async {
    Map<String, dynamic> result = Map();

    try{
      result = await POSimpl().POS(token: token, revenue_id: revenue_id, state: state, sales_id: sales_id, lga: lga, additional_note: additional_note, delivery_address: delivery_address, quantity: quantity, business_uuid: business_uuid, isPersonal: isPersonal );
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
  Future<Map<String, dynamic>> getLGAs({String token, String state_id})async {
    Map<String, dynamic> result = Map();

    try{
      result = await POSimpl().getLGAs(token: token, state_id: state_id, );
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
          lga = result["localGovts"];
        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> getRevenue({String token})async {
    Map<String, dynamic> result = Map();

    try{
      result = await POSimpl().getRevenue(token: token);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
      revenue = result["revenue"];
        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> getSales({String token}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await POSimpl().getSales(token: token, );
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
          sales = result["sales"];
        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> getStates({String token})async {
    Map<String, dynamic> result = Map();

    try{
      result = await POSimpl().getStates(token: token,  );
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
      states = result["states"];
        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> posApproved({String token, business_uuid, bool isPersonal}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await POSimpl().posApproved(token: token, business_uuid: business_uuid, isPersonal: isPersonal );
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
          // states = result["states"];
        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> posPending({String token, business_uuid, bool isPersonal}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await POSimpl().posPending(token: token,business_uuid: business_uuid, isPersonal: isPersonal );
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
          // states = result["states"];
        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

}