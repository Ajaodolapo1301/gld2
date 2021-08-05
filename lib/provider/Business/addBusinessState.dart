

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:glade_v2/api/Business/AddBusiness/addBusiness.dart';
import 'package:glade_v2/core/models/apiModels/Auth/Business.dart';
import 'package:glade_v2/core/models/apiModels/Auth/allBusiness.dart';
import 'package:glade_v2/core/models/apiModels/Auth/balance.dart';
import 'package:glade_v2/pages/personal/go_live/go_live_personal_page.dart';
import 'package:hive/hive.dart';

abstract class AbstractAddBusinessViewModel {
  Future<Map<String, dynamic>> addBusiness({businessCategory, businessName, businessDesc, country, state, businessAddress, buinessWebsite,businessEmail, token, makeDefault});
  Future<Map<String, dynamic>> addBusinessCompliance({ FileClass CAC, FileClass Tin, FileClass utitltyBill, FileClass DIrectorForm ,rcOrBN, utiltyType, tinNumber, token, registeredName});
  Future<Map<String, dynamic>> getAllBusiness({token});
  Future<Map<String, dynamic>> getBusiness({token,business_uuid});
  Future<Map<String, dynamic>> fetchCountry({token});
  Future<Map<String, dynamic>> setDefault({token,business_uuid});
  Future<Map<String, dynamic>> fetchBusinesscategory({token});
  Future<Map<String, dynamic>> fetchBillTypes({token});
  Future<Map<String, dynamic>> getBalance({token, business_uuid});
  Future<Map<String, dynamic>> RegisterBusiness({company_name, company_name_two, company_name_three, company_address, company_email, company_description, company_objective, registration_type, share_capital, per_capital_share, directors, File documents, token});

}



class BusinessState with ChangeNotifier implements AbstractAddBusinessViewModel{


  Business _business;
  Box box;

  Business get business => _business;
  set business(Business value) {
    _business = value;
    notifyListeners();
  }

  BusinessState(Business value) {
    box = Hive.box("business");
    if (value != null) {
      business = value;
    }
  }
  List<CountryModel> _countryModel= [];
  List<CountryModel> get countryModel => _countryModel;
  set countryModel(List<CountryModel> countryModel1) {
    _countryModel = countryModel1;
    notifyListeners();
  }

  List<String> _businesscat= [];
  List<String> get businesscat => _businesscat;
  set businesscat(List<String> String) {
    _businesscat = String;
    notifyListeners();
  }

  List<String> _utilityBills= [];
  List<String> get utilityBills => _utilityBills;
  set utilityBills(List<String> String) {
    _utilityBills = String;
    notifyListeners();
  }



  @override
  Future<Map<String, dynamic>> addBusiness({businessCategory, businessName, businessDesc, country, state, businessAddress, buinessWebsite, businessEmail,  token, makeDefault})  async{
    Map<String, dynamic> result = Map();

    try{
      result = await AddBusinessImpl().addBusiness(token: token, buinessWebsite: buinessWebsite, businessAddress: businessAddress, businessCategory: businessCategory, businessName: businessName, businessDesc: businessDesc, country: country,  businessEmail:businessEmail, state: state, makeDefault: makeDefault);
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

  @override
  Future<Map<String, dynamic>> addBusinessCompliance({FileClass CAC, FileClass Tin, FileClass utitltyBill, FileClass DIrectorForm, rcOrBN, utiltyType, tinNumber, token, registeredName, business_uuid})async {
    Map<String, dynamic> result = Map();

    try{
      result = await AddBusinessImpl().addBusinessCompliance(token: token, Tin: Tin, utiltyType: utiltyType, DIrectorForm: DIrectorForm, rcOrBN: rcOrBN, tinNumber: tinNumber, registeredName: registeredName, utitltyBill: utitltyBill, CAC: CAC, business_uuid: business_uuid,  );
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

  @override
  Future<Map<String, dynamic>> getAllBusiness({token}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await AddBusinessImpl().getAllBusiness(token: token);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occurred, Please  check your internet connection and try again';
      }else{
       // box.put('business', result['business']);
       // business = result['business'];

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> getBusiness({token, business_uuid}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await AddBusinessImpl().getBusiness(token: token, business_uuid: business_uuid);

      print(result["singleBusiness"]);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occurred, Please  check your internet connection and try again';
      }else if(result["error"] == false){
       box.put('business', result['singleBusiness']);
       business = result['singleBusiness'];
      }else{

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> setDefault({token, business_uuid})  async{
    Map<String, dynamic> result = Map();

    try{
      result = await AddBusinessImpl().setDefault(token: token, business_uuid: business_uuid);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occurred, Please  check your internet connection and try again';
      }else if(result["error"] == false){
        // box.put('business', result['business']);
        business = result['business'];

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> fetchCountry({token})async {
    Map<String, dynamic> result = Map();

    try{
      result = await AddBusinessImpl().fetchCountry(token: token);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occurred, Please  check your internet connection and try again';
      }else if(result["error"] == false){
        // box.put('business', result['business']);
        countryModel = result['countryModel'];

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> fetchBusinesscategory({token})async {
    Map<String, dynamic> result = Map();

    try{
      result = await AddBusinessImpl().fetchBusinesscategory(token: token);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occurred, Please  check your internet connection and try again';
      }else if(result["error"] == false){
        // box.put('business', result['business']);
        businesscat = result['businessCategories'];

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> fetchBillTypes({token}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await AddBusinessImpl().fetchBillTypes(token: token);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occurred, Please  check your internet connection and try again';
      }else if(result["error"] == false){
        // box.put('business', result['business']);
        utilityBills = result['utilityBills'];

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> getBalance({token, business_uuid})async {
    Map<String, dynamic> result = Map();
    try {
      result = await AddBusinessImpl().getBalance(token: token, business_uuid: business_uuid);


      if (result['error'] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      } else if (result['error'] == true) {
        result['error'] = true;
        result['message'] = result["message"];
      }
    } catch (error) {
//      print(error.toString());
      result['error'] = true;
      result['message'] = result["message"];
    }

    if (result['error'] == false) {
      Balance balance = result['balance'];

      business.available_balance = balance.balance;

      // user.availableBalance = user1.availableBalance;
      notifyListeners();
    }
//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic>> RegisterBusiness({company_name, company_name_two, company_name_three, company_address, company_email, company_description, company_objective, registration_type, share_capital, per_capital_share, directors, File documents, token})async {
    Map<String, dynamic> result = Map();

    try{
      result = await AddBusinessImpl().RegisterBusiness(token: token, company_name: company_name, company_name_two: company_name_two, company_name_three: company_name_three, company_address: company_address, company_email: company_email, company_description: company_description, company_objective: company_objective,  registration_type: registration_type, share_capital: share_capital,per_capital_share: per_capital_share, directors: directors, documents: documents,   );
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