


import 'package:flutter/cupertino.dart';
import 'package:glade_v2/api/Business/IncreaseLimit/increaseLimit.dart';
import 'package:glade_v2/core/models/apiModels/Business/increaseLimit/billsType.dart';
import 'package:glade_v2/core/models/apiModels/Business/increaseLimit/limits.dart';

abstract class AbstractIncreaseLimitViewModel {
  Future<Map<String, dynamic>> getLimits({String token});
  Future<Map<String, dynamic>> getBillTypes({String token});
  Future<Map<String, dynamic>> limit({String token, limit_id, bill_type_name, bill_image, reason_for_inncrease});
}


class IncreaseLimitState with ChangeNotifier implements AbstractIncreaseLimitViewModel{


  List<BillsType> _billsType= [];
  List<BillsType> get billsType => _billsType;
  set billsType(List<BillsType> billsType1) {
    _billsType = billsType1;
    notifyListeners();
  }

//  Countries
  List<Limit> _limitList= [];
  List<Limit> get limitList  => _limitList;
  set limitList(List<Limit> limit1) {
    _limitList = limit1;
    notifyListeners();
  }




  @override
  Future<Map<String, dynamic>> getBillTypes({String token}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await IncreaseLimitImpl().getBillTypes(token: token);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
            billsType = result["billsType"];
          }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> getLimits({String token}) async {
    Map<String, dynamic> result = Map();

    try{
      result = await IncreaseLimitImpl().getLimits(token: token);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
          limitList = result["limit"];
        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> limit({String token, limit_id, bill_type_name, bill_image, reason_for_inncrease}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await IncreaseLimitImpl().limit(token: token, limit_id: limit_id, bill_image: bill_image, reason_for_inncrease: reason_for_inncrease, bill_type_name: bill_type_name);
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

}