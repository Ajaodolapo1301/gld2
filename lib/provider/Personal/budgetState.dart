
import 'package:flutter/cupertino.dart';
import 'package:glade_v2/api/Personal/Budget/budget.dart';
import 'package:glade_v2/core/models/apiModels/Personal/Budget/budget.dart';

abstract class AbstractBudgetViewModel {
  Future<Map<String, dynamic>> getBudget({String token,});
  Future<Map<String, dynamic>> budget({String token, amount, cycle_id, action_id});
  Future<Map<String, dynamic>> deleteBudget({String token,});

  Future<Map<String, dynamic>> getCycle({String token, });
  Future<Map<String, dynamic>> getAction({String token});
  Future<Map<String, dynamic>> updateBudget({String token, amount, cycle_id, action_id});
}


class BudgetState with ChangeNotifier implements AbstractBudgetViewModel{






  List<Cycle> _cycle= [];
  List<Cycle> get cycle => _cycle;
  set cycle(List<Cycle> cycle1) {
    _cycle = cycle1;
    notifyListeners();
  }

//  BudgetList
  List<Budget> _budgetList= [];
  List<Budget> get budgetList  => _budgetList;
  set budgetList(List<Budget> budget1) {
    _budgetList = budget1;
    notifyListeners();
  }


  //  BudgetList
  List<ActionModel> _actionList= [];
  List<ActionModel> get actionList  => _actionList;
  set actionList(List<ActionModel> actionList1) {
    _actionList = actionList1;
    notifyListeners();
  }




  @override
  Future<Map<String, dynamic>> budget({String token, amount, cycle_id, action_id}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await BudgetImpl().budget(token: token, amount: amount, cycle_id: cycle_id, action_id: action_id);
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
  Future<Map<String, dynamic>> deleteBudget({String token}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await BudgetImpl().deleteBudget(token: token);
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
  Future<Map<String, dynamic>> getAction({String token}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await BudgetImpl().getAction(token: token);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
      actionList = result["actions"];
        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> getBudget({String token})async {
    Map<String, dynamic> result = Map();

    try{
      result = await BudgetImpl().getBudget(token: token);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
          // budgetList = result["budgets"];
        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> getCycle({String token}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await BudgetImpl().getCycle(token: token);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
      cycle = result["cycle"];
        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> updateBudget({String token, amount, cycle_id, action_id}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await BudgetImpl().updateBudget(token: token, action_id: action_id, cycle_id: cycle_id, amount: amount);
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
