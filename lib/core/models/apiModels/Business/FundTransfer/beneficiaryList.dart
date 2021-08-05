class BeneficiaryList {
 String account_name;
 String account_number;
 String bank_code;
String  bank_name;

BeneficiaryList({this.account_number, this.bank_code, this.bank_name, this.account_name});

 factory BeneficiaryList.fromJson(Map <String,  dynamic> json)=>BeneficiaryList(
   account_name: json["account_name"],
   account_number: json["account_number"],
   bank_code: json["bank_code"],
   bank_name: json["bank_name"],
 );
}