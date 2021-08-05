
class AccountName {
  String accountName;


  AccountName({this.accountName});
factory  AccountName.fromJson(Map <String, dynamic> json)=>AccountName(
      accountName: json["account_name"]
      );
}


