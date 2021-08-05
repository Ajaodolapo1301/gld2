

class CreditHistory{
 int id;
  String   amount;
 String status;
 String created_at;
String type;
String details;


CreditHistory({this.amount, this.created_at,  this.status, this.type, this.id, this.details, });

factory  CreditHistory.fromJson(Map<String, dynamic> json)=> CreditHistory(
  id: json["id"],
    status: json["status"],
  details: json["details"],
  created_at: json["created_at"],
  amount: json["amount"],
 type: json["type"]
);
}


