
class VirtualCardDesign{
  String design_name;
  int design_id;
  int design_code;


  VirtualCardDesign({this.design_name, this.design_id, this.design_code});

  factory VirtualCardDesign.fromJson(Map <String,  dynamic> json)=>VirtualCardDesign(
      design_name: json["design_name"],
      design_id: json["design_id"],
    design_code: json["design_code"]

  );
}