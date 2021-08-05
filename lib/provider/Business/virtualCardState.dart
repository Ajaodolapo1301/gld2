


import 'package:flutter/cupertino.dart';
import 'package:glade_v2/api/Business/virtualCard/virtualCardapi.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/VirtualTransaction.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/VirtualcardCurrency.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/virtualCardDesign.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/virtualCardList.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/virtualCardTitle.dart';

abstract class AbstractVcardViewModel {
  Future<Map<String, dynamic>> getListOfCard({String token, business_uuid,  bool isPersonal});
  Future<Map<String, dynamic>> createVcard({card_title, currency, amount, design_code, String token,  business_uuid, bool isPersonal, country });
  Future<Map<String, dynamic>> getCardDetails({cardId, String token,  business_uuid,  bool isPersonal});
  Future<Map<String, dynamic>> fundCard({card_id, amount, String token,  business_uuid,  bool isPersonal});
  Future<Map<String, dynamic>> terminateCard({card_id, String token,  business_uuid,  bool isPersonal});
  Future<Map<String, dynamic>> unfreezeCard({card_id, String token,  business_uuid,  bool isPersonal});
  Future<Map<String, dynamic>> freezeCard({card_id, String token,  business_uuid,  bool isPersonal});
  Future<Map<String, dynamic>> withdraw({card_id, amount, String token,  business_uuid,  bool isPersonal});
  Future<Map<String, dynamic>> transactionList({card_id, String token,  business_uuid,  bool isPersonal});
  Future<Map<String, dynamic>> getCardTitles({String token});
  Future<Map<String, dynamic>> getCardDesigns({String token});
  Future<Map<String, dynamic>> getCardCurrencies({String token});
}


class VirtualCardState with ChangeNotifier implements AbstractVcardViewModel{


//currency
  List<VirtualCardCurrency> _currencies= [];
  List<VirtualCardCurrency> get currencies => _currencies;
  set currencies(List<VirtualCardCurrency> currencies1) {
    _currencies = currencies1;
    notifyListeners();
  }



//title
  List<VirtualCardTitle> _virtualCardTitle= [];
  List<VirtualCardTitle> get virtualCardTitle => _virtualCardTitle;
  set virtualCardTitle(List<VirtualCardTitle> virtualCardTitle1) {
    _virtualCardTitle = virtualCardTitle1;
    notifyListeners();
  }





//design
List<VirtualCardDesign> _virtualCardDesign= [];
  List<VirtualCardDesign> get virtualCardDesign => _virtualCardDesign;
  set virtualCardDesign(List<VirtualCardDesign> virtualCardDesign1) {
    _virtualCardDesign = virtualCardDesign1;
    notifyListeners();
  }



  //List of Cards
  List<VirtualCardList> _virtualCardList= [];
  List<VirtualCardList> get virtualCardList => _virtualCardList;
  set virtualCardList(List<VirtualCardList> virtualCardList1) {
    _virtualCardList = virtualCardList1;
    notifyListeners();
  }

  //card transaction
  List<VirtualCardTransaction> _virtualCardTransaction= [];
  List<VirtualCardTransaction> get virtualCardTransaction => _virtualCardTransaction;
  set virtualCardTransaction(List<VirtualCardTransaction> virtualCardTransaction1) {
    _virtualCardTransaction = virtualCardTransaction1;
    notifyListeners();
  }




  @override
  Future<Map<String, dynamic>> createVcard({card_title, currency, amount, design_code, String token,  business_uuid, bool isPersonal, country}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await VirtualCardImpl().createVcard(token: token, currency: currency, amount: amount, design_code: design_code, card_title: card_title, business_uuid: business_uuid, isPersonal: isPersonal, country: country);
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
  Future<Map<String, dynamic>> freezeCard({card_id, String token,business_uuid, bool isPersonal }) async{
    Map<String, dynamic> result = Map();

    try{
      result = await VirtualCardImpl().freezeCard(token: token, card_id: card_id, business_uuid: business_uuid, isPersonal: isPersonal);
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
  Future<Map<String, dynamic>> fundCard({card_id, amount, String token, business_uuid, bool isPersonal})async {
    Map<String, dynamic> result = Map();

    try{
      result = await VirtualCardImpl().fundCard(token: token, card_id: card_id, amount: amount, business_uuid: business_uuid, isPersonal: isPersonal);
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
  Future<Map<String, dynamic>> getCardCurrencies({String token})async {
    Map<String, dynamic> result = Map();

    try{
      result = await VirtualCardImpl().getCardCurrencies(token: token);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
    currencies = result["virtualCardCurrency"];

        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> getCardDesigns({String token}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await VirtualCardImpl().getCardDesigns(token: token);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
          virtualCardDesign = result["virtualCardDesign"];

        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> getCardDetails({cardId, String token,  business_uuid,  bool isPersonal}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await VirtualCardImpl().getCardDetails(token: token,cardId: cardId, isPersonal: isPersonal, business_uuid: business_uuid);
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
  Future<Map<String, dynamic>> getCardTitles({String token}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await VirtualCardImpl().getCardTitles(token: token);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
          virtualCardTitle  = result["virtualCardTitle"];

        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> getListOfCard({String token, business_uuid,  bool isPersonal})async {
    Map<String, dynamic> result = Map();

    try{
      result = await VirtualCardImpl().getListOfCard(token: token, business_uuid: business_uuid, isPersonal: isPersonal);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
          virtualCardList  = result["virtualCardList"];

        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> terminateCard({card_id, String token, business_uuid, bool isPersonal})async {
    Map<String, dynamic> result = Map();

    try{
      result = await VirtualCardImpl().terminateCard(token: token,card_id: card_id, business_uuid: business_uuid, isPersonal: isPersonal);
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
  Future<Map<String, dynamic>> transactionList({card_id, String token, business_uuid, bool isPersonal}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await VirtualCardImpl().transactionList(token: token, card_id: card_id, business_uuid: business_uuid, isPersonal: isPersonal);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
          virtualCardTransaction = result["virtualCardTransaction"];

        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }







  @override
  Future<Map<String, dynamic>> unfreezeCard({card_id, String token, business_uuid, bool isPersonal}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await VirtualCardImpl().unfreezeCard(token: token, card_id: card_id, business_uuid: business_uuid, isPersonal: isPersonal);
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
  Future<Map<String, dynamic>> withdraw({card_id, amount, String token, business_uuid, bool isPersonal})async {
    Map<String, dynamic> result = Map();

    try{
      result = await VirtualCardImpl().withdraw(token: token, amount: amount, card_id: card_id, business_uuid: business_uuid, isPersonal: isPersonal);
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