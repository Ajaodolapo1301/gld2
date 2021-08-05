
class SavedCard{
  String masked_pan;
  String card_id;
  String name_on_card ;

  String created_at;

  String card_type;


  SavedCard({this.masked_pan, this.created_at, this.card_id, this.name_on_card, this.card_type});

  factory SavedCard.fromJson(Map <String,  dynamic> json)=>SavedCard(
      masked_pan: json["masked_pan"],
      created_at: json["created_at"],
      card_id:  json["card_id"],
      name_on_card: json["name_on_card"],
      card_type: json["card_type"]

  );
}



