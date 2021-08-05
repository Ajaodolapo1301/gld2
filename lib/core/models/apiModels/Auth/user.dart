

import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType()
class User{

  @HiveField(0)
  bool is_email_verified;


  @HiveField(1)
  String email;

  @HiveField(2)
  String token;

  @HiveField(3)
  String phone;


  @HiveField(4)
  bool preferredPhone;



  @HiveField(5)
  var bvn;



  @HiveField(6)
  String compliance_status;


  @HiveField(7)
  bool hasBusinessAccount;



  @HiveField(8)
  bool hasPassCode;


  @HiveField(9)
  String accountNum;



  @HiveField(10)
  String bank_name;


  @HiveField(11)
  String availableBalance;


  @HiveField(12)
  String ledgerBalance;



  @HiveField(13)
  String firstname;


  @HiveField(14)
  String lastname;

  @HiveField(15)
  bool is_phone_verified;


  @HiveField(16)
  var business_message;

  @HiveField(17)
  String business_uuid;

  @HiveField(18)
  String business_name;

  @HiveField(19)
  var mid;

  @HiveField(20)
  String key;

  @HiveField(21)
  String referral_code;

  @HiveField(22)
  bool is_bvn_matched;

  @HiveField(23)
  String currency;


  @HiveField(24)
  String user_uuid;



  User({this.bvn, this.email, this.hasBusinessAccount, this.accountNum, this.hasPassCode, this.compliance_status, this.phone, this.preferredPhone, this.token, this.is_email_verified, this.availableBalance, this.bank_name, this.ledgerBalance, this.firstname, this.lastname, this.is_phone_verified,
  this.business_message, this.business_uuid, this.business_name, this.mid, this.key, this.referral_code, this.is_bvn_matched, this.currency, this.user_uuid
});






   User.fromJson(Map <String,  dynamic> json){
     token = json["data"]['token'] ?? " ";

     is_email_verified =  json['data']['is_email_verified'];
     email = json['data']["user"]['email']?? "";

     user_uuid = json['data']["user"]['uuid']?? "";

     phone = json['data']['phone']?? "";
     hasBusinessAccount= json["data"]["has_business_account"] ?? "";
     hasPassCode= json["data"]["has_passcode"] ?? "";
     compliance_status= json["data"]["compliance_status"];
     accountNum = json["data"]["account"]["account_number"];
     currency =  json["data"]["account"]["currency"];
     ledgerBalance =  json["data"]["account"]["ledger_balance"] ?? "";
     availableBalance = json["data"]["account"]["available_balance"] ?? "";
     bank_name = json["data"]["account"]["bank_name"] ?? "";
     firstname = json["data"]["user"]["first_name"] ?? " ";
     referral_code = json["data"]["user"]["referral_code"];
     lastname = json["data"]["user"]["last_name"] ?? "";
     is_phone_verified = json["data"]["is_phone_verified"] ;
     is_bvn_matched = json["data"]["is_bvn_matched"];
        // if(json["data"]["user"]["bvn"]){
          bvn = json["data"]["user"]["bvn"];
        // }
          if (json["data"]["business"] != null  ) {
            if(json ["data"]["business"]["business_uuid"] != null ){
              business_uuid = json["data"]["business"]["business_uuid"];
              business_name = json["data"]["business"]["business_name"];
              mid = json["data"]["business"]["credentials"]["mid"];
              // key = json["data"]["business"]["credentials"]["key"];

            }else{
              business_message = json["data"]["business"]["message"];
            }
          }



   }



  User.fromJson2(Map <String,  dynamic> json){
    is_email_verified =  json['data']['is_email_verified'];
    email = json['data']["user"]['email']?? "";
    phone = json['data']['phone']?? "";

    user_uuid = json['data']["user"]['uuid']?? "";
    hasBusinessAccount= json["data"]["has_business_account"] ?? "";
    hasPassCode= json["data"]["has_passcode"] ?? "";
    compliance_status= json["data"]["compliance_status"];
    accountNum = json["data"]["account"]["account_number"];
    ledgerBalance =  json["data"]["account"]["ledger_balance"] ?? "";
    currency =  json["data"]["account"]["currency"];
    availableBalance = json["data"]["account"]["available_balance"] ?? "";
    bank_name = json["data"]["account"]["bank_name"] ?? "";
    firstname = json["data"]["user"]["first_name"] ?? " ";
    lastname = json["data"]["user"]["last_name"] ?? "";
    referral_code = json["data"]["user"]["referral_code"];
    is_phone_verified = json["data"]["is_phone_verified"] ;


    if (json["data"]["business"] != null  ) {
      if(json ["data"]["business"]["business_uuid"] != null ){
        business_uuid = json["data"]["business"]["business_uuid"];
        business_name = json["data"]["business"]["business_name"];
        mid = json["data"]["business"]["credentials"]["mid"];
        key = json["data"]["business"]["credentials"]["key"];
      }else{
        business_message = json["data"]["business"]["message"];
      }
    }
    // if (json["data"]["business"] != null || json ["data"]["business"]["message"] != null ) {
    //   business_message = json["data"]["business"]["message"];
    // }

    // if (json["data"]["business"] != null || json["data"]["business"]["business_name"]) {
    //
    // }


  }





  }






