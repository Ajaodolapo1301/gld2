

import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/bankModel.dart';

class BanksSingleton{
  static final BanksSingleton _banksSingleton = BanksSingleton._createInstance();

  BanksSingleton._createInstance();

  factory BanksSingleton(){
    return _banksSingleton;
  }

  List banks = [];


}