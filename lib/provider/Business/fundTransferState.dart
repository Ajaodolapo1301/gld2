import 'package:flutter/cupertino.dart';
import 'package:glade_v2/api/Business/FundTransfer/fundTransfer.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/BankTransferMode.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/bankModel.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/beneficiaryList.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/countriesModel.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/transactionHistory.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/transferMethod.dart';

abstract class AbstractFundTransferViewModel {
  Future<Map<String, dynamic>> getTransactionList({start_date, end_date, page_index, page_size, String token, business_uuid, bool isPersonal});
  Future<Map<String, dynamic>> gladeToGlade({account_number, amount, narration, bool save_beneficiary ,String token, business_uuid, bool isPersonal});
  Future<Map<String, dynamic>> gladeToOtherBank({bank_code, account_number, account_name, amount, narration, save_beneficiary, String token, business_uuid,  bool isPersonal});
  Future<Map<String, dynamic>> internationalTransfer({currency_code, business_uuid, bool isPersonal, beneficiary_bank_branch,  currency, bank_code, beneficiary_account_number, beneficiary_name, amount, narration, bool save_beneficiary, String token});
  Future<Map<String, dynamic>> getMode({String token});
  Future<Map<String, dynamic>> FetchAcountNameInternal({String token, accoutNum, mode, });
  Future<Map<String, dynamic>> FetchAcountNameExternal({String token, accoutNum, mode, bankCode });
  Future<Map<String, dynamic>> getMobileInternational({String token, country_code, business_uuid, method_id, bool isPersonal});
  Future<Map<String, dynamic>> FetchAcountNameInternational({String token, accoutNum, mode, countryCode, BankCode });
  Future<Map<String, dynamic>> getCountries({String token,  business_uuid, bool isPersonal});
  Future<Map<String, dynamic>> getTransferMethod({String token, country_code, business_uuid,  bool isPersonal});
  Future<Map<String, dynamic>> getBanks({String token, mode});
  Future<Map<String, dynamic>> getBankBranchInternational({String token, country_code, bank_id, business_uuid,  bool isPersonal});
  Future<Map<String, dynamic>> bulkTransferExternal({List bulkItem,  String token});
  Future<Map<String, dynamic>> beneficiariesList({String token, business_uuid, bool isPersonal, mode});
  Future<Map<String, dynamic>> getBanksInternational({String token, country_code, business_uuid,method_id,  bool isPersonal});
  Future<Map<String, dynamic>> transferFee({String token, amount, source_currency, destination_currency, business_uuid,  bool isPersonal});
}

class FundTransferState  with ChangeNotifier implements AbstractFundTransferViewModel {

//  banksLists
  List<BankModel> _bankList= [];
  List<BankModel> get bankList => _bankList;
  set bankList(List<BankModel> bankList1) {
    _bankList = bankList1;
    notifyListeners();
  }

//  Countries
  List<CountriesModel> _countriesList= [];
  List<CountriesModel> get countriesList  => _countriesList;
  set countriesList(List<CountriesModel> countriesList1) {
    _countriesList = countriesList1;
    notifyListeners();
  }

  // Transfer mode
  List<BankTransferMode> _bankTransferMode= [];
  List<BankTransferMode> get bankTransferMode  => _bankTransferMode;
  set bankTransferMode(List<BankTransferMode> bankTransferMode1 ) {
    _bankTransferMode = bankTransferMode1;
    notifyListeners();
  }


  // Transaction List
  List<TransferHistory> _transferHistory= [];
  List<TransferHistory> get transferHistory  => _transferHistory;
  set transferHistory(List<TransferHistory> transferHistory1 ) {
    _transferHistory = transferHistory1;
    notifyListeners();
  }

  // Transfer Method
  List<TransferMethod> _transferMethod= [];
  List<TransferMethod> get transferMethod  => _transferMethod;
  set transferMethod(List<TransferMethod> transferMethod1 ) {
    _transferMethod = transferMethod1;
    notifyListeners();
  }


  List<BeneficiaryList> _beneficiaryList= [];
  List<BeneficiaryList> get beneficiaryList  => _beneficiaryList;
  set beneficiaryList(List<BeneficiaryList> beneficiaryList1 ) {
    _beneficiaryList = beneficiaryList1;
    notifyListeners();
  }




  @override
  Future<Map<String, dynamic>> beneficiariesList({String token, business_uuid, bool isPersonal, mode})async {
    Map<String, dynamic> result = Map();

    try{
      result = await FundTransferImpl().beneficiaryList(token: token, business_uuid:business_uuid, isPersonal: isPersonal, mode: mode );
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
          beneficiaryList = result["beneficiaryList"];
        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> bulkTransferExternal({ List bulkItem, String token}) async {
    Map<String, dynamic> result = Map();

    try{
      result = await FundTransferImpl().bulkTransferExternal(token: token, bulkItem: bulkItem);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
          // bankList = result["bankList"];

        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> getBanks({String token, mode}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await FundTransferImpl().getBanks(token: token, mode: mode);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
          bankList = result["bankList"];

        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> getCountries({String token,  business_uuid, bool isPersonal}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await FundTransferImpl().getCountries(token: token, business_uuid: business_uuid, isPersonal: isPersonal);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occurred, ';
      }else{
        if(result['error'] == false){
          countriesList = result["countriesList"];

        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> getMode({String token}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await FundTransferImpl().getMode(token: token);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occurred, Please  check your internet connection and try again';
      }else{
       if( result['error'] == false){
         bankTransferMode = result["bankTransferMode"];

       }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> getTransactionList({start_date, end_date, page_index, page_size, String token, business_uuid, bool isPersonal}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await FundTransferImpl().getTransactionList(token: token, isPersonal: isPersonal, business_uuid: business_uuid, start_date: start_date, end_date: end_date, );
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occurred, Please  check your internet connection and try again';
      }else{
if(result['error'] == false){

  transferHistory = result["transferHistoryList"];
}

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> getTransferMethod({String token,country_code, business_uuid,  bool isPersonal}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await FundTransferImpl().getTransferMethod(token: token, country_code: country_code, business_uuid: business_uuid, isPersonal: isPersonal);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occurred, Please  check your internet connection and try again';
      }else{
      if ( result['error'] == false){
        transferMethod = result["transferMethod"];
       }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> gladeToGlade({ account_number, amount, narration, bool save_beneficiary, String token, business_uuid, bool isPersonal}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await FundTransferImpl().gladeToGlade(token: token, amount: amount, account_number: account_number, narration: narration, save_beneficiary: save_beneficiary, business_uuid: business_uuid, isPersonal: isPersonal);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occurred, Please  check your internet connection and try again';
      }else  {


      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> gladeToOtherBank({bank_code, account_number, account_name, amount, narration, save_beneficiary, String token, bank_name, business_uuid,  bool isPersonal})async {
    Map<String, dynamic> result = Map();

    try{
      result = await FundTransferImpl().gladeToOtherBank(token: token, amount: amount, account_name: account_name, account_number: account_number, narration: narration, save_beneficiary: save_beneficiary, bank_code: bank_code, bank_name: bank_name, business_uuid: business_uuid,  isPersonal: isPersonal);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occurred, Please  check your internet connection and try again';
      }else if  (result["error"] == false) {


      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> internationalTransfer({currency_code, business_uuid, bool isPersonal, beneficiary_bank_branch,  currency, bank_code, beneficiary_account_number, beneficiary_name, amount, narration, bool save_beneficiary, String token}) async {
    Map<String, dynamic> result = Map();

    try{
      result = await FundTransferImpl().internationalTransfer(bank_code: bank_code, currency_code: currency_code, currency: currency, token: token, amount: amount, beneficiary_name: beneficiary_name, beneficiary_account_number: beneficiary_account_number, narration: narration, save_beneficiary: save_beneficiary, beneficiary_bank_branch: beneficiary_bank_branch, isPersonal: isPersonal, business_uuid: business_uuid);
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
  Future<Map<String, dynamic>> FetchAcountNameExternal({String token, accoutNum, mode, bankCode}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await FundTransferImpl().FetchAcountNameExternal(token: token, accoutNum: accoutNum, bankCode: bankCode, mode: mode);
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
  Future<Map<String, dynamic>> FetchAcountNameInternal({String token, accoutNum, mode , business_uuid, bool isPersonal}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await FundTransferImpl().FetchAcountNameInternal(token: token, accoutNum: accoutNum, mode: mode, business_uuid: business_uuid, isPersonal: isPersonal);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occurred, Please  check your internet connection and try again';
      }else if(result["error"] == false){


      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> FetchAcountNameInternational({String token, accoutNum, mode, countryCode, BankCode}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await FundTransferImpl().FetchAcountNameInternational(token: token, accoutNum: accoutNum, mode: mode, countryCode: countryCode, BankCode: BankCode);
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
  Future<Map<String, dynamic>> getBanksInternational({String token, country_code, business_uuid, bool isPersonal, method_id})async {
    Map<String, dynamic> result = Map();

    try{
      result = await FundTransferImpl().getBanksInternational(token: token,country_code: country_code, method_id: method_id, business_uuid: business_uuid, isPersonal: isPersonal);
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
  Future<Map<String, dynamic>> getBankBranchInternational({String token, country_code, bank_id, business_uuid, bool isPersonal}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await FundTransferImpl().getBankBranchInternational(token: token,country_code: country_code,bank_id: bank_id, business_uuid: business_uuid, isPersonal: isPersonal);
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
  Future<Map<String, dynamic>> getMobileInternational({String token, country_code, business_uuid, method_id, bool isPersonal})async {
    Map<String, dynamic> result = Map();

    try{
      result = await FundTransferImpl().getMobileInternational(token: token,country_code: country_code, method_id: method_id, business_uuid: business_uuid, isPersonal: isPersonal);
        print("Mobile moneeeeey$result ");
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
  Future<Map<String, dynamic>> transferFee({String token, amount, source_currency, destination_currency, business_uuid, bool isPersonal}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await FundTransferImpl().transferFee(token: token,source_currency: source_currency, destination_currency: destination_currency, business_uuid: business_uuid, isPersonal: isPersonal, amount: amount);
print(result);
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