
class Budget{
  var  budget;
  var spent;
  var available;
String date_created;
String cycle;
String available_percentage;
Budget({this.available, this.budget, this.date_created, this.spent, this.cycle, this.available_percentage});


factory Budget.fromJson(Map <String, dynamic> json)=>Budget(
  budget: json["budget"],
  spent: json["spent"],
  available: json["available"],
  date_created: json["date_created"],
    cycle : json["cycle"],
  available_percentage: json["available_percentage"]
);
}



class Cycle{
  String  cycle_id;
  String cycle_name;


  Cycle({this.cycle_id, this.cycle_name, });


  factory Cycle.fromJson(Map <String, dynamic> json)=>Cycle(
      cycle_id: json["cycle_id"],
      cycle_name: json["cycle_name"],

  );
}



class ActionModel{
  String  action_id;
  String action_name;


  ActionModel({this.action_id, this.action_name, });


  factory ActionModel.fromJson(Map <String, dynamic> json)=>ActionModel(
    action_id: json["action_id"],
    action_name: json["action_name"],

  );
}