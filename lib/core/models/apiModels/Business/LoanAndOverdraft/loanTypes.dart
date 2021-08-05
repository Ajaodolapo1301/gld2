class CreditTypes{
 String credit_type_id;
String credit_type_name;



 CreditTypes({this.credit_type_name, this.credit_type_id});
 factory CreditTypes.fromJson (Map<String, dynamic>json)=> CreditTypes(
     credit_type_name: json["credit_type_name"],
     credit_type_id: json["credit_type_id"]

 );
}