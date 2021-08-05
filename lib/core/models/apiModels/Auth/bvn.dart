class BVNModel{
  String  firstname;
  String  lastname;
  String  dob;
  String  bvn;
  String  phone;



  BVNModel({this.bvn, this.dob, this.firstname, this.lastname, this.phone});
  BVNModel.fromJson(Map<String, dynamic> json) {
    bvn = json['bvn'];
    lastname = json['last_name'];
    firstname = json["first_name"];
    dob = json["formatted_dob"];
    phone = json["mobile"];
  }

}