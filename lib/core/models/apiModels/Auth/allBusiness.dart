

    class AllBusiness {
      String business_name;




      String business_uuid;


      String business_email;

      String contact_email;

      String status;

      String business_category;

      String contact_phone;

      String business_address;

      String country;



      String state;


      AllBusiness({this.business_uuid, this.business_address, this.business_category, this.business_email, this.business_name, this.contact_email, this.contact_phone, this.country, this.state,
      });
      factory AllBusiness.fromJson(Map <String,  dynamic> json)=>AllBusiness(
          business_name: json['business_name'] ?? "",
          business_uuid: json['business_uuid']?? "",
          business_email : json['business_email']?? "",
          contact_email : json['contact_email']?? "",
          business_category: json["business_category"] ?? "",
          contact_phone: json["contact_phone"] ?? "",
          business_address: json["business_address"],
          country: json["country"] ?? "",
          state: json["state"] ?? "",



      );

    }


    class CountryModel{
    String country_code;
    String country_name;
    String currency;
    String symbol;
    CountryModel({this.country_code, this.currency, this.country_name, this.symbol});
    factory CountryModel.fromJson(Map <String,  dynamic> json)=>CountryModel(
      country_code: json['country_code'] ?? "",
      country_name: json['country_name']?? "",
      currency : json['currency']?? "",
      symbol : json['symbol']?? "",




    );
    }