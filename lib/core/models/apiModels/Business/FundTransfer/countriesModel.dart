

import 'package:flutter/cupertino.dart';

class CountriesModel{
  String code;
  String name;
  String currency;
  String symbol;
  String id;
  bool has_branch;


  CountriesModel({this.currency, this.id, this.symbol, this.code, this.name, this.has_branch});

  factory CountriesModel.fromJson(Map <String,  dynamic> json)=>CountriesModel(
      code: json["code"],
      name: json["name"],
    currency: json["currency"],
    symbol: json["symbol"],
    has_branch: json["has_branch"]



  );
}



