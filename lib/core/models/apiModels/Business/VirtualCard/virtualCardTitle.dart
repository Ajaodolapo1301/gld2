
class VirtualCardTitle{
  String card_title;
  String id;
  VirtualCardTitle({this.card_title, this.id});

  factory VirtualCardTitle.fromJson(Map <String,  dynamic> json)=>VirtualCardTitle(
      card_title: json["title_name"],
      id: json["title_id"]

  );
}
