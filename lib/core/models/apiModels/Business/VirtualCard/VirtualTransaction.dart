
class VirtualCardTransaction{
  String transaction_message;
  String created_at;
  var amount;
  String transaction_type;
  String product;
String currency;
  VirtualCardTransaction({this.transaction_message, this.currency, this.created_at, this.amount, this.transaction_type, this.product});

  factory VirtualCardTransaction.fromJson(Map <String,  dynamic> json)=>VirtualCardTransaction(
      transaction_message: json["title_name"],
      created_at: json["created_at"],
    amount:  json["amount"],
    transaction_type: json["transaction_type"],
    product: json["product"],
      currency :json["currency"]

  );
}