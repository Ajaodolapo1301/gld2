import 'dart:convert';

class BillsInfo {
  Data data;

  BillsInfo({this.data});

  BillsInfo.fromJson(Map<String, dynamic> json) {

    data = json['data'] != null ?  Data.fromJson(json['data']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }

  @override
  String toString() {
    super.toString();
    return "data: $data";
  }
}





class Data {
  List<Categories> categories;
  List<Bills> bills;
  List<Items> items;

  Data({this.categories,
    this.bills,
    this.items
  });

  Data.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = new List<Categories>();
      json['categories'].forEach((v) {

        categories.add(new Categories.fromJson(v));
      });
    }
    if (json['bills'] != null) {
      bills = new List<Bills>();
      json['bills'].forEach((v) {

        bills.add(new Bills.fromJson(v));
      });
    }
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {

        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    if (this.bills != null) {
      data['bills'] = this.bills.map((v) => v.toJson()).toList();
    }
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
  //
  // @override
  // String toString() {
  //   super.toString();
  //   return "bills: $bills, categories: $categories";
  // }

}

class Categories {
  int id;
  String category_title;
  var parent_category_id;
  String category_code;

  Categories({this.category_code, this.category_title, this.id, this.parent_category_id});

  Categories.fromJson(Map<String, dynamic> json) {
    category_title = json['category_title'];
    category_code = json['category_code'];
    parent_category_id = json["parent_category_id"];
      id = json["id"];
  }

  @override
  String toString() {
    super.toString();
    return "category_title: $category_title, category_code: $category_code";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_title'] = this.category_title;
    data['category_code'] = this.category_code;
    data["parent_category_id"] = this.parent_category_id;
    data["id"] = this.id;
    return data;
  }
}

class Bills {
  int id;
  String name;
  String reference;
  String category_id;

  Bills({this.id, this.name, this.reference, this.category_id});

  @override
  String toString() {
    super.toString();
    return "ID: $id Name: $name Reference: $reference Category: $category_id";
  }

  Bills.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    reference = json['reference'];
    category_id = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['reference'] = this.reference;
    data['category_id'] = this.category_id;
    return data;
  }
}

class Items {
  String  title;
  int billsId;
  var base_amount;
  var custom_amount;
  var dedicated_fee_id;
  String paycode;
  int requires_name_enquiry;
 var isaddon;
  var keycode;




  Items(
      {this.title,
        this.billsId,
        this.base_amount,
        this.custom_amount,
        this.dedicated_fee_id,
        this.paycode,
        this.isaddon,
        this.keycode,
        this.requires_name_enquiry,

      });


  Items.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    billsId = json['bill_id'];
    base_amount = json['base_amount'];
    custom_amount = json['custom_amount'];
    dedicated_fee_id = json['dedicated_fee_id'];
    paycode = json['paycode'];
    requires_name_enquiry = json['requires_name_enquiry'];
   isaddon =json["is_addon"];
   keycode = json["keycode"];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['bill_id'] = this.billsId;
    data['base_amount'] = this.base_amount;
    data['custom_amount'] = this.custom_amount;
    data['dedicated_fee_id'] = this.dedicated_fee_id;
    data['paycode'] = this.paycode;
    data["keycode"] = this.keycode;
    data['requires_name_enquiry'] = this.requires_name_enquiry;
    data['is_addon'] = this.isaddon;
    return data;
  }
  @override
  String toString() {
    super.toString();
    return "Name: $title billsId: $billsId Amount: $base_amount Discount: $custom_amount Fee: $dedicated_fee_id PayCode: $paycode requireNameQuery: $requires_name_enquiry ";
  }

}

class Cable {
  String decoder_number;
  String decoder_name;
  Cable({this.decoder_name, this.decoder_number});

  factory Cable.fromJson(Map<String, dynamic> json)=>Cable(
    decoder_name: json["customer_name"],
    decoder_number: json["card_iuc_number"]
  );
}



class Meter {
  String custName;

  Meter({this.custName});

  factory Meter.fromJson(Map<String, dynamic> json)=>Meter(
      custName: json["custName"],

  );
}


class AirtimeModel {
  String id;
  String txn_ref;
  String bill_reference;
  String amount_charged;
  String status;
  String remark;
  String electricitytoken;


  AirtimeModel({this.id, this.amount_charged, this.bill_reference, this.remark, this.status, this.txn_ref, this.electricitytoken});
  factory AirtimeModel.fromJson(Map<String, dynamic> json)=>AirtimeModel(
      id: json["id"],
      txn_ref: json["txn_ref"],
      bill_reference: json["bill_reference"],
      amount_charged: json["amount_charged"],
    status: json["status"],
    remark: json["remark"]
  );

}

//
// {"id":1,"bill_id":1,"title":"TopUp","reference":"2348062550416","owner_uuid":"03db7273-b683-404c-8b10-6a0b4e0625da",
//
// "created_at":"2021-05-07 10:41:55","updated_at":"2021-05-07 10:41:55"}
// "id":1,"bill_id":1,"title":"TopUp","reference":"2348062550416","owner_uuid":"03db7273-b683-404c-8b10-6a0b4e0625da","created_at":"2021-05-07 10:41:55","updated_at":"2021-05-07 10:41:55","name":"MTN Prepaid Topup","category_id":"2","bill_item_id":1}
class BeneficiaryAirtime{
  var id;
  var bill_item_id;
  var category_id;
  var bill_id;
  String title;
  String reference;
  String owner_uuid;
  String created_at;
  String paycode;
  String reference_data;

  BeneficiaryAirtime({this.id, this.bill_id, this.bill_item_id, this.category_id, this.created_at, this.owner_uuid, this.reference, this.title, this.paycode, this.reference_data});
  factory BeneficiaryAirtime.fromJson(Map<String, dynamic> json)=>BeneficiaryAirtime(
      id: json["id"],
      bill_item_id: json["bill_item_id"],
      bill_id: json["bill_id"],
      created_at: json["created_at"],
      category_id: json["category_id"],
      reference: json["reference"],
      paycode:json['paycode'],
    title: json["title"],
    owner_uuid: json["owner_uuid"],
      reference_data: json["reference_data"]

  );
}


