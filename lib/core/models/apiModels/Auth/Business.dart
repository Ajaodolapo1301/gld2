

import 'package:hive/hive.dart';

  part 'Business.g.dart';

@HiveType()
class Business {
  @HiveField(0)
  String business_name;



  @HiveField(1)
  String business_uuid;

  @HiveField(2)
  String business_email;

  @HiveField(3)
  String contact_email;


  @HiveField(4)
  String status;



  @HiveField(5)
  String business_category;



  @HiveField(6)
  String contact_phone;


  @HiveField(7)
  String business_address;



  @HiveField(8)
  String country;


  @HiveField(9)
  String state;

  @HiveField(10)
  String account_number;


  @HiveField(11)
  String bank_name;



  @HiveField(12)
  String available_balance;


  @HiveField(13)
  String ledger_balance;


  @HiveField(14)
  String compliance_status;


  @HiveField(15)
  String currency;







  Business({this.business_uuid, this.business_address, this.business_category, this.business_email, this.business_name, this.contact_email, this.contact_phone, this.country, this.state, this.status,
  this.account_number, this.available_balance, this.bank_name, this.compliance_status, this.ledger_balance, this.currency

  });


  factory Business.fromJson(Map <String,  dynamic> json)=>Business(
      business_name: json["business"]['business_name'] ?? "",
      business_uuid: json["business"]['business_uuid']?? "",
      business_email : json["business"]['business_email']?? "",
      contact_email : json["business"]['contact_email']?? "",
      status: json["business"]["status"] ?? "",
      business_category: json["business"]["business_category"] ?? "",
      contact_phone: json["business"]["contact_phone"] ?? "",
      business_address: json["business"]["business_address"],
      country: json["business"]["country"] ?? "",
      state: json["business"]["state"] ?? "",
      account_number: json["account"]["account_number"],
      bank_name: json['account']["bank_name"],
      available_balance: json["account"]["available_balance"],
      ledger_balance: json["account"]["ledger_balance"],
      currency: json["account"]["currency"],
      compliance_status: json["compliance_status"]


  );

}