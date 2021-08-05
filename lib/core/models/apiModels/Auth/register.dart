


class Register1{
  String user_uuid;
  String masked_email;
  String masked_phone;

  Register1({this.masked_email, this.masked_phone, this.user_uuid});

 factory Register1.fromJson(Map<String, dynamic> json)=> Register1(
  user_uuid: json["user_uuid"],
    masked_email: json["masked_email"],
    masked_phone: json["masked_phone"]
  );
}



