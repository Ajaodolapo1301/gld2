
import 'package:flutter/cupertino.dart';
import 'package:glade_v2/api/Personal/ReserveFund/reserve.dart';
import 'package:glade_v2/core/models/apiModels/Personal/ReserveFund/reserve.dart';

abstract class AbstractReserveViewModel {
  Future<Map<String, dynamic>> getstashType({String token,  });
  Future<Map<String, dynamic>> getReserves({String token});
  Future<Map<String, dynamic>> CreateReserves({String token, title, amount, description, stash_type, start_date, end_date});

  Future<Map<String, dynamic>> fundReserve({String token, reserve_id, amount});
  Future<Map<String, dynamic>> withdrawReserve({String token, reserve_id, amount, remark});
  Future<Map<String, dynamic>> disableReserve({String token, reserve_id });
  Future<Map<String, dynamic>> getReserveDetails({String token, id});
  Future<Map<String, dynamic>> enableReserve({String token, reserve_id });
  Future<Map<String, dynamic>> transactionListDetails({String token, reserve_id });

}

class ReserveState with ChangeNotifier implements AbstractReserveViewModel{


  List<StashType> _stashType= [];
  List<StashType> get stashType => _stashType;
  set stashType(List<StashType> stashType1) {
    _stashType = stashType1;
    notifyListeners();
  }



  List<Reserve> _reserve= [];
  List<Reserve> get reserve => _reserve;
  set reserve(List<Reserve> reserve1) {
    _reserve = reserve1;
    notifyListeners();
  }


  @override
  Future<Map<String, dynamic>> CreateReserves({String token, title, amount, description, stash_type,start_date, end_date }) async{
    Map<String, dynamic> result = Map();

    try{
      result = await ReserveImpl().CreateReserves(token: token, title: title, amount: amount, description: description,  stash_type: stash_type ,end_date: end_date, start_date: start_date);
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
  Future<Map<String, dynamic>> disableReserve({String token, reserve_id}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await ReserveImpl().disableReserve(token: token, reserve_id: reserve_id );
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
  Future<Map<String, dynamic>> fundReserve({String token, reserve_id, amount}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await ReserveImpl().fundReserve(token: token, reserve_id: reserve_id, amount: amount);
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
  Future<Map<String, dynamic>> getReserves({String token})async{
    Map<String, dynamic> result = Map();

    try{
      result = await ReserveImpl().getReserves(token: token);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
          reserve = result["reserve"];
        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> getstashType({String token})async {
    Map<String, dynamic> result = Map();

    try{
      result = await ReserveImpl().getstashType(token: token);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
          stashType = result["stashType"];
        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> withdrawReserve({String token, reserve_id, amount, remark}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await ReserveImpl().withdrawReserve(token: token, reserve_id: reserve_id, amount: amount, remark: remark);
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
  Future<Map<String, dynamic>> getReserveDetails({String token, id}) async {
    Map<String, dynamic> result = Map();

    try{
      result = await ReserveImpl().getReserveDetails(token: token, id: id );
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
  Future<Map<String, dynamic>> enableReserve({String token, reserve_id}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await ReserveImpl().enableReserve(token: token, reserve_id: reserve_id );
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
  Future<Map<String, dynamic>> transactionListDetails({String token, reserve_id}) {
    // TODO: implement transactionListDetails
    throw UnimplementedError();
  }

}