

import 'package:flutter/cupertino.dart';
import 'package:glade_v2/api/Personal/Withdraw/withdraw.dart';

abstract class AbstractWithdrawViewModel {
  Future<Map<String, dynamic>> withdraw({String token, amount, remark});


}


class WithdrawalState with ChangeNotifier implements AbstractWithdrawViewModel{
  @override
  Future<Map<String, dynamic>> withdraw({String token, amount, remark}) async {
    Map<String, dynamic> result = Map();

    try{
      result = await WithdrawImpl().withdraw(token: token, amount: amount, remark: remark);
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