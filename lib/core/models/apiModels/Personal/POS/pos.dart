
import 'dart:convert';

class Revenue {
 String revenue_id;
 String revenue_amount;


 Revenue({this.revenue_amount, this.revenue_id});

 factory Revenue.fromJson(Map <String, dynamic> json)=> Revenue(
   revenue_amount: json["revenue_amount"],
   revenue_id: json["revenue_id"],
 );
}




class Sales {
  String sales_id;
  String sales_range;


  Sales({this.sales_id, this.sales_range});

  factory Sales.fromJson(Map <String, dynamic> json)=> Sales(
    sales_id: json["sales_id"],
    sales_range: json["sales_range"],
  );
}


// {"owner_uuid":"03db7273-b683-404c-8b10-6a0b4e0625da","request_type":"personal","address":"The delivery address field is required.","state_id":12,"city_id":55,"comment":"The additional note field is required.","status":"pending","quantity_requested":1,"monthly_revenue":"Above NGN 1,000,000","daily_sales":"Above 1000 sales"}

class PosHistoryModel {
  String request_type;
  String status;
  int quantity_requested;
  String monthly_revenue;


  PosHistoryModel(
      {this.request_type, this.status, this.monthly_revenue, this.quantity_requested});

  factory PosHistoryModel.fromJson(Map <String, dynamic> json) =>
      PosHistoryModel(
        request_type: json["request_type"],
        quantity_requested: json["quantity_requested"],
        monthly_revenue: json["monthly_revenue"],
        status: json["status"],
      );
}
//
//
//}
//
//
//
//class LGA{
//  String lga_id;
//  String  lga_name;
//
//
//  LGA({this.lga_id, this.lga_name});
//  factory LGA.fromJson(Map <String,  dynamic> json) => LGA(
//    lga_id: json["lga_id"],
//
//    lga_name: json["lga_name"],
//  );
//


//}