class Limit{
 String limit_id;
 String limit_name;

     String limit_amount;


    Limit({this.limit_amount, this.limit_id, this.limit_name});

    factory Limit.fromJson( Map<String,dynamic > json)=> Limit(
      limit_amount: json["limit_amount"],
      limit_id: json["limit_id"],
      limit_name: json["limit_name"]
    );

}