

class Balance {
  String balance;
  Balance({this.balance});
  factory Balance.fromJson(Map<String, dynamic> json)=>Balance(
      balance: json["balance"]
  );
}