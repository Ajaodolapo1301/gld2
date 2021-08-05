
class VirtualCardModel {
  String masked_pan;
  String card_id;
  String card_state;
  String balance;
  String createdAt;
  String card_title;

  String expiration;

  String currency;
  String design_code;

  String cvv;
  String card_type;
  String card_pan;
    bool is_active;


  VirtualCardModel ({this.balance, this.is_active, this.card_title, this.card_id, this.card_state, this.card_type, this.createdAt, this.currency, this.cvv, this.expiration, this.masked_pan, this.design_code, this.card_pan});


  factory VirtualCardModel.fromJson(Map <String,  dynamic> json)=>VirtualCardModel(
      card_title: json["card_title"],
      card_state: json["card_state"],
    card_id: json["card_id"],
    card_type: json["card_type"],
    createdAt: json["createdAt"],
    design_code: json["design_code"],
    masked_pan: json["masked_pan"],
    currency: json["currency"],
    cvv: json["cvv"],
    balance: json["amount"],
    card_pan: json["card_pan"],
      expiration: json["expiration"],
      is_active: json["is_active"]

  );
}


