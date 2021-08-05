
class TransferHistory{
  String transfer_type;
  int id;
  String txn_ref;
  String order_ref;
  String currency;
String value;
String beneficiary_account;
String beneficiary_name;
String beneficiary_institution;
String created_at;
String remark;
String narration;
  String status;
  TransferHistory({this.txn_ref, this.remark,  this.transfer_type, this.value, this.order_ref, this.created_at, this.narration, this.beneficiary_account, this.beneficiary_institution, this.beneficiary_name, this.currency, this.id, this.status,});

  factory TransferHistory.fromJson(Map <String,  dynamic> json)=>TransferHistory(
    txn_ref: json["txn_ref"],
    transfer_type: json["transfer_type"],
    value: json["value"],
    order_ref: json["order_ref"],
    created_at: json["created_at"],
    narration: json["narration"],
    beneficiary_account: json["beneficiary_account"],
    beneficiary_institution: json["beneficiary_institution"],
    beneficiary_name: json["beneficiary_name"],
    id: json["id"],
    status: json["status"],
    currency: json["currency"],
    remark: json["remark"]

  );
}


