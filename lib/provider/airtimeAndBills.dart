
import 'package:flutter/material.dart';
import 'package:glade_v2/api/AirtimeAndBills/airtimeAndbills.dart';
import 'package:glade_v2/core/models/apiModels/AirtimeAndBills/airtimeAndBills.dart';

class AirtimeAndBillsState extends AbstractAirtimeAndBillsViewModel with ChangeNotifier {


  @override
  Future<Map<String, dynamic>> getBills({token}) async{
    Map<String, dynamic> result = Map();
    try{

      result = await BillImpl().getBills(token: token);
      // print(result);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){

        }
      }
    }catch(e){

    }


    return result;
  }

  @override
  Future<Map<String, dynamic>> fetchCableName({String token, String card_iuc_number, paycode, amount}) async{
    Map<String, dynamic> result = Map();
    try{

      result = await BillImpl().fetchCableName(token: token, card_iuc_number: card_iuc_number, paycode: paycode, amount: amount);
      // print(result);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){

        }
      }
    }catch(e){

    }


    return result;
  }

  @override
  Future<Map<String, dynamic>> airtime({String token, paycode, reference, amount,  save_beneficiary,  bool isPersonal, business_uuid})async {
    Map<String, dynamic> result = Map();
    try{

      result = await BillImpl().airtime(token: token, amount: amount, paycode: paycode, reference: reference,   save_beneficiary: save_beneficiary, isPersonal: isPersonal, business_uuid: business_uuid );
      // print(result);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){

        }
      }
    }catch(e){

    }

    // print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic>> fetchmetername({String token, meter_number, paycode})async {
    Map<String, dynamic> result = Map();
    try{

      result = await BillImpl().fetchmetername(token: token, meter_number: meter_number, paycode: paycode );
      // print(result);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){

        }
      }
    }catch(e){

    }


    return result;
  }

  @override
  Future<Map<String, dynamic>> cable({String token, paycode, reference, amount,cable_name,  save_beneficiary,  bool isPersonal, business_uuid})async {
    Map<String, dynamic> result = Map();
    try{

      result = await BillImpl().cable(token: token, amount: amount, paycode: paycode, reference: reference, cable_name:cable_name , save_beneficiary: save_beneficiary, isPersonal: isPersonal, business_uuid: business_uuid);
      // print(result);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){

        }
      }
    }catch(e){

    }


    return result;
  }

  @override
  Future<Map<String, dynamic>> electricy({String token, paycode, reference, amount, meter_number_details,  save_beneficiary,  bool isPersonal, business_uuid}) async{
    Map<String, dynamic> result = Map();
    try{

      result = await BillImpl().electricy(token: token, amount: amount, paycode: paycode,reference: reference,  meter_number_details: meter_number_details, save_beneficiary: save_beneficiary, isPersonal: isPersonal, business_uuid: business_uuid);
      // print(result);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){

        }
      }
    }catch(e){

    }


    return result;
  }

  @override
  Future<Map<String, dynamic>> fetchinternetService({String token, paycode, account_number})async {
    Map<String, dynamic> result = Map();
    try{

      result = await BillImpl().fetchinternetService(token: token, account_number: account_number, paycode: paycode );
      // print(result);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){

        }
      }
    }catch(e){

    }


    return result;
  }

  @override
  Future<Map<String, dynamic>> internet({String token,paycode, reference, amount, account_name,save_beneficiary,  bool isPersonal, business_uuid})async {
    Map<String, dynamic> result = Map();
    try{

      result = await BillImpl().internet(token: token, amount: amount, paycode: paycode,reference: reference,  account_name: account_name, save_beneficiary: save_beneficiary, isPersonal: isPersonal, business_uuid: business_uuid);
      // print(result);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){

        }
      }
    }catch(e){

    }


    return result;
  }

  @override
  Future<Map<String, dynamic>> gethistory({String token, business_uuid, bool isPersonal, start_date, end_date,}) async{
    Map<String, dynamic> result = Map();
    try{

      result = await BillImpl().gethistory(token: token, business_uuid: business_uuid, isPersonal: isPersonal, start_date: start_date, end_date: end_date );
      // print(result);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){

        }
      }
    }catch(e){

    }


    return result;
  }

  @override
  Future<Map<String, dynamic>> getBeneficairies({String token, type})async {
    Map<String, dynamic> result = Map();
    try{

      result = await BillImpl().getBeneficairies(token: token,type: type );
      // print(result);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){

        }
      }
    }catch(e){

    }


    return result;
  }
  }




abstract class AbstractAirtimeAndBillsViewModel {
  Future<Map<String, dynamic>> fetchmetername({String token, paycode, meter_number});
  Future<Map<String, dynamic>> getBills({token});
  Future<Map<String, dynamic>> getBeneficairies({String token, type});
  Future<Map<String, dynamic>> gethistory({String token, business_uuid, bool isPersonal});
  Future<Map<String, dynamic>> fetchCableName({String token, String card_iuc_number, paycode, amount});
  Future<Map<String, dynamic>> airtime({String token, paycode, reference, amount, save_beneficiary,  bool isPersonal, business_uuid});
  Future<Map<String, dynamic>> fetchinternetService({String token, paycode, account_number});
  Future<Map<String, dynamic>> internet({String token, paycode, reference, amount, account_name,  save_beneficiary, bool isPersonal, business_uuid});
  Future<Map<String, dynamic>> cable({String token, paycode, reference, cable_name,  amount, save_beneficiary, bool isPersonal, business_uuid});
  Future<Map<String, dynamic>> electricy({String token, paycode, reference,  amount, meter_number_details,  save_beneficiary,  bool isPersonal, business_uuid});

}