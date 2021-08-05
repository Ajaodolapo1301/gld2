

class BankModel{
  String bank_code;
  String bank_name;



  BankModel({this.bank_name, this.bank_code, });

  factory BankModel.fromJson(Map <String,  dynamic> json)=>BankModel(
    bank_code: json["bank_code"],
    bank_name: json["bank_name"],



  );
}



class BankBVNModel{
  String bank_code;
  String bank_name;
  String bank_longcode;
  String currency;


  BankBVNModel({this.bank_name, this.bank_code, this.currency, this.bank_longcode});

  factory BankBVNModel.fromJson(Map <String,  dynamic> json)=>BankBVNModel(
      bank_code: json["bank_code"],
      bank_name: json["bank_name"],
      bank_longcode: json["bank_longcode"],
      currency: json["currency"]


  );
}