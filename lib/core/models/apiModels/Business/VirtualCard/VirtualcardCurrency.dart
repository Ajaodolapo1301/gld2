



class VirtualCardCurrency{
 String currency_id;
     String country;
 String symbol;
 String country_code;


 VirtualCardCurrency({this.country, this.currency_id, this.symbol, this.country_code});


 factory VirtualCardCurrency.fromJson(Map <String,  dynamic> json)=>VirtualCardCurrency(
    country: json["country"],
   country_code: json["country_code"],
   currency_id: json["currency_id"],
   symbol: json["symbol"]

 );


}