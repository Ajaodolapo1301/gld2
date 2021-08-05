

import 'package:glade_v2/core/models/apiModels/AirtimeAndBills/airtimeAndBills.dart';

class BillsSingleton{
  static final BillsSingleton _billsSingleton = BillsSingleton._createInstance();

  BillsSingleton._createInstance();

  factory BillsSingleton(){
    return _billsSingleton;
  }

  BillsInfo billsInfo;
  List categories = [];

}