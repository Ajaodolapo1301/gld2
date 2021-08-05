
class CountryList{
  int id;
  String name;
  String code;
  String currency;

  CountryList({this.name, this.id, this.currency, this.code});


  factory CountryList.fromJson(Map <String,  dynamic> json)=>CountryList(
    name: json['name'] ?? " ",
    id : json['id'] ?? " ",
    currency :json['currency']?? " ",
    code : json['code']?? " ",




  );
}


// class TransferMethod{
//   String name;
//   String code;
//   TransferMethod({this.name, this.code});
//
//
//   factory TransferMethod.fromJson(Map <String,  dynamic> json)=>TransferMethod(
//     name: json['name'] ?? " ",
//     code : json['code']?? " ",
//
//
//
//
//   );
// }


class MobileMoney{
  String name;
  String code;
  MobileMoney({this.name, this.code});


  factory MobileMoney.fromJson(Map <String,  dynamic> json)=>MobileMoney(
    name: json['name'] ?? " ",
    code : json['code']?? " ",




  );
}





class BankIntlList{

  int id ;
  String name;
  String code;
  BankIntlList({this.name, this.code, this.id = 0 });


  factory BankIntlList.fromJson(Map <String,  dynamic> json)=>BankIntlList(
    name: json['name'] ?? " ",
    code : json['code']?? " ",
    id: json['id'] ?? 0,




  );
}







class BankIntlBranchList{

  int id;
  String name;
  String code;
  BankIntlBranchList({this.name, this.code, this.id});


  factory BankIntlBranchList.fromJson(Map <String,  dynamic> json)=>BankIntlBranchList(
    name: json['branch_name'] ?? " ",
    code : json['branch_code']?? " ",
    id: json['id']?? " ",




  );
}




class TransferFee{
  var rate;
  var fee;
  String toCurrency;
  var toAmount;
 String fromCurrency;
 var fromAmount;
  TransferFee({ this.rate, this.toAmount, this.fromAmount, this.fromCurrency, this.toCurrency, this.fee});


  factory TransferFee.fromJson(Map <String, dynamic> json)=>TransferFee(

    rate : json['rate']?? " ",
    toCurrency: json["to"]['currency'],
    toAmount: json["to"]["amount"],
      fromCurrency: json["from"]['currency'],
      fromAmount: json["from"]["amount"],
      fee: json["fee"]




  );
}








