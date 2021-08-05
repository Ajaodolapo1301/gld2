
import 'package:flutter/cupertino.dart';
import 'package:glade_v2/api/Business/LoanAndOverDraft/loanAndOverdraft.dart';
import 'package:glade_v2/core/models/apiModels/Business/LoanAndOverdraft/loanHistory.dart';
import 'package:glade_v2/core/models/apiModels/Business/LoanAndOverdraft/loanTypes.dart';

abstract class AbstractLoanAndOverdraftViewModel {
  Future <Map<String, dynamic>> getLoanHistory({String token, business_uuid});
  Future <Map<String, dynamic>> applyLoan({String token, type_id, amount, reason, guarantor_name, guarantor_phone, guarantor_email, guarantor_address, business_uuid});

  Future <Map<String, dynamic>> addNote({String token,narration, credit_id, business_uuid});
  Future <Map<String, dynamic>> cancelLoan({String token,reason, credit_id, business_uuid});
  Future <Map<String, dynamic>> creditTypes({String token, business_uuid});
  Future <Map<String, dynamic>> getNote({String token, credit_id, business_uuid});


}


class LoanAndOverdraftState with ChangeNotifier implements AbstractLoanAndOverdraftViewModel{


  List<CreditHistory> _loanHistory= [];
  List<CreditHistory> get loanHistory => _loanHistory;
  set loanHistory(List<CreditHistory> loanHistory1) {
    _loanHistory = loanHistory1;
    notifyListeners();
  }


  List<CreditTypes> _loanTypesList= [];
  List<CreditTypes> get loanTypesList => _loanTypesList;
  set loanTypesList(List<CreditTypes> loanTypesList1) {
    _loanTypesList = loanTypesList1;
    notifyListeners();
  }



  @override
  Future<Map<String, dynamic>> addNote({String token, narration, credit_id, business_uuid})  async{
    Map<String, dynamic> result = Map();

    try{
      result = await LoanAndOverdraftImpl().addNote(token: token, narration: narration, credit_id: credit_id, business_uuid: business_uuid);
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
  Future<Map<String, dynamic>> applyLoan({String token, type_id, amount, reason, guarantor_name, guarantor_phone, guarantor_email, guarantor_address,business_uuid }) async{
    Map<String, dynamic> result = Map();

    try{
      result = await LoanAndOverdraftImpl().      applyLoan(token: token, type_id: type_id, amount: amount, reason: reason, guarantor_name: guarantor_name, guarantor_address: guarantor_address, guarantor_email: guarantor_email, guarantor_phone: guarantor_phone, business_uuid: business_uuid);
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
  Future<Map<String, dynamic>> cancelLoan({String token, reason, credit_id, business_uuid}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await LoanAndOverdraftImpl().cancelLoan(token: token, business_uuid: business_uuid, credit_id: credit_id, reason: reason );
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
  Future<Map<String, dynamic>> getLoanHistory({String token, business_uuid})async {
    Map<String, dynamic> result = Map();

    try{
      result = await LoanAndOverdraftImpl().getLoanHistory(token: token, business_uuid: business_uuid  );
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
          loanHistory = result["creditHistory"];
        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> creditTypes({String token, business_uuid})async {
    Map<String, dynamic> result = Map();

    try{
      result = await LoanAndOverdraftImpl().creditTypes(token: token, business_uuid: business_uuid  );
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
          loanTypesList = result["loanTypes"];
        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> getNote({String token, credit_id, business_uuid}) async {
    Map<String, dynamic> result = Map();

    try{
      result = await LoanAndOverdraftImpl().getNote(token: token, credit_id: credit_id, business_uuid: business_uuid  );
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