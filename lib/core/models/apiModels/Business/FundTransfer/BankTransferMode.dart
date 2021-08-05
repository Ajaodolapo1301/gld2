

class BankTransferMode{
  String id;
  String mode;



  BankTransferMode({this.id, this.mode});

  factory BankTransferMode.fromJson(Map <String,  dynamic> json)=>BankTransferMode(
    id: json["id"],
    mode: json["mode"],
  );
}