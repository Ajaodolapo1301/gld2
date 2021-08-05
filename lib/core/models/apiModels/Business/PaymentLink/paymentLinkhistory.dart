

class PaymentLinkHistory{
 String link_url;
String title;
String amount;
String created_at;

PaymentLinkHistory({this.created_at, this.amount, this.title, this.link_url});

factory PaymentLinkHistory.fromJson (Map<String, dynamic> json) => PaymentLinkHistory(
    title: json["title"],
    link_url: json['paycode'],
  amount: json["amount"],
  created_at: json["created_at"]
);
}



class PaymentLinkCurrency{
 var currency_id;
 String country;
 String symbol;
 String country_code;
String currency;

 PaymentLinkCurrency({this.country, this.currency_id, this.symbol, this.country_code, this.currency});


 factory PaymentLinkCurrency.fromJson(Map <String,  dynamic> json)=>PaymentLinkCurrency(
     country: json["country"],
     country_code: json["country_code"],
     currency_id: json["currency_id"],
     symbol: json["symbol"],
  currency: json["currency"]

 );


}