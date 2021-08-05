
class BillsType {
 String type_name;
String type_id;

BillsType({this.type_id, this.type_name});
  factory BillsType.fromJson(Map<String, dynamic> json) => BillsType(
  type_id: json["type_id"],
    type_name: json["type_name"]
  );
  }
