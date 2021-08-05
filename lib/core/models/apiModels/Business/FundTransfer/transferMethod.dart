
class TransferMethod{
  String code;
  String name;



  TransferMethod({this.code, this.name});

  factory TransferMethod.fromJson(Map <String,  dynamic> json)=>TransferMethod(
    code: json["code"],
    name: json["name"],
  );
}