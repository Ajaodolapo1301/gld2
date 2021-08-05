


class VirtualCardList{
  String masked_pan;

  int card_id;
int card_status;
  String  created_at;
  VirtualCardList({this.masked_pan, this.card_id, this.card_status, this.created_at});

  factory VirtualCardList.fromJson(Map <String,  dynamic> json)=>VirtualCardList(
      card_status: json["card_status"],

      masked_pan: json["masked_pan"],
      created_at: json["created_at"],
      card_id: json["card_id"]

  );
}