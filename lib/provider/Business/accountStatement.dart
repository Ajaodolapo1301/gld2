



import 'package:flutter/cupertino.dart';
import 'package:glade_v2/api/AccountStatement/accountStatement.dart';

abstract class AbstractAccountStatementViewModel {
  Future<Map<String, dynamic>> getAccountStatement({String token, to_date, from_date, business_uuid, bool isPersonal});
}



class AccountStatementState with ChangeNotifier implements AbstractAccountStatementViewModel{


  @override
  Future<Map<String, dynamic>> getAccountStatement({String token, business_uuid, bool isPersonal, to_date, from_date,}) async{
    Map<String, dynamic> result = Map();
    try{
      result = await AccountStatementImpl().getAccountStatement(token: token, business_uuid: business_uuid, isPersonal: isPersonal, from_date: from_date, to_date: to_date);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occurred, Please  check your internet connection and try again';
      }else{


      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

}