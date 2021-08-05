class InvoiceHistory {
  String email;
  String due_date;
  String status;
String   txn_ref;
  List<InvoiceItems> items;
  String created_at;
  String total_value;
  String currency;
String invoice_no;
var vat;
String phone;
String address;
  InvoiceHistory({this.email, this.due_date, this.status, this.txn_ref, this.currency,this.invoice_no,

    this.items, this.created_at, this.total_value, this.vat, this.address, this.phone});


  InvoiceHistory.fromJson(Map <String, dynamic> json){
email = json["invoice"]["email"];
due_date = json["invoice"]["due_date"];
status = json["invoice"]["status"];
txn_ref = json["invoice"]["txn_ref"];
created_at = json["invoice"]["created_at"];
total_value = json["invoice"]["total_value"];
currency = json["invoice"]["currency"];
invoice_no = json["invoice"]["invoice_no"];
phone = json["invoice"]["phone"];
vat = json["invoice"]["vat"];
address = json["invoice"]["address"];
if (json['items'] != null) {
  items = new List<InvoiceItems>();
  json['items'].forEach((v) {

    items.add(new InvoiceItems.fromJson(v));
  });
}

  }





}



class InvoiceNum{
  String invoice_no;

  InvoiceNum({this.invoice_no});
  InvoiceNum.fromJson(Map <String, dynamic> json){
    invoice_no = json["data"]["invoice_no"];
  }

}


class InvoiceItems{
  int id;
  var invoice_id;
  String description;
  String unit_cost;
  var quantity;
  var total_cost;
  String created_at;

  InvoiceItems({this.id, this.quantity, this.created_at, this.description, this.invoice_id, this.total_cost, this.unit_cost});

  InvoiceItems.fromJson(Map <String, dynamic> json){
    id = json["id"];
    invoice_id = json["invoice_id"];
    description = json["description"];
    unit_cost = json["unit_cost"];
    quantity = json["quantity"];
    total_cost = json["total_cost"];
    created_at = json["created_at"];
    unit_cost = json["unit_cost"];


  }

}