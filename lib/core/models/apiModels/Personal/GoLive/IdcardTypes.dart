
class IdCardTypes{
  int type_id;
 String type_name;

 IdCardTypes({this.type_id, this.type_name});

 factory IdCardTypes.fromJson (Map<String, dynamic> json) =>IdCardTypes(
   type_id: json["type_id"],
   type_name: json["type_name"]
 );
}