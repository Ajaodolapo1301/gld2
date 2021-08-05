
class BulkTransfer {
  String account_name;
  String account_number;
  String bank_code;
  String amount;
 String narration;
  bool save_beneficiary;


  BulkTransfer({this.account_name, this.bank_code, this.account_number, this.narration, this.amount, this.save_beneficiary});
}
