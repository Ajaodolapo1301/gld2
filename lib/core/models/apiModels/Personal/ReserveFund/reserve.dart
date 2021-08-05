



import 'package:glade_v2/utils/constants/constants.dart';

class StashType{
String stash_type_id;
 String   stash_type_name;

 StashType({this.stash_type_id, this.stash_type_name});

 factory StashType. fromJson(Map <String, dynamic> json) =>StashType(
      stash_type_id: json["stash_type_id"],
    stash_type_name: json["stash_type_name"]
    );

}


class Reserve{
  int id;
  String title;
  String  amount;
  String description;
  int stash_type;
  String stash_amount;
  int reserve_status;

  Reserve({this.title, this.amount, this.description, this.reserve_status, this.stash_amount, this.stash_type, this.id});

  factory Reserve.fromJson(Map <String, dynamic> json) =>Reserve(
      id: json["id"],
      stash_type: json["stash_type"],
      stash_amount: json["stash_amount"],
      title: json['title'],
    amount: json["amount"],
    reserve_status: json["reserve_status"],
    description: json["description"]
  );
}


class ReserveDetails{
  int id;
  String title;
  String  amount;
  String description;
  int stash_type;
  String stash_amount;
  int reserve_status;
  String start_date;
  String end_date;
  int retry;

  ReserveDetails({this.title, this.amount, this.description, this.reserve_status, this.stash_amount, this.stash_type, this.id, this.start_date, this.end_date, this.retry});
  factory ReserveDetails.fromJson(Map <String, dynamic> json) =>ReserveDetails(
      id: json["id"],
      stash_type: json["stash_type"],
      stash_amount: json["stash_amount"],
      title: json['title'],
      amount: json["amount"],
      reserve_status: json["reserve_status"],
      description: json["description"],
      start_date: json["start_date"],
      end_date: json["end_date"],
      retry: json["retry"]
  );
}
