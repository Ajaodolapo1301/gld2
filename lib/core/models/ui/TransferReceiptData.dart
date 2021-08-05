import 'dart:convert';

import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/transactionHistory.dart';



class TransferReceiptData {
  // for printing receipt immediately after a transaction

  int transactionId;
  String orderId;
  String amount;
  String accountNumber;
  String accountName;
  String status;
  String remarks;
  String date;
  String currency;
  String narration;
  String bank;
  String txn_ref;
  String created_at;
  TransferReceiptData(
      {this.transactionId,
        this.orderId,
        this.amount,
        this.accountNumber,
        this.accountName,
        this.status,
        this.remarks,
        this.currency,
        this.date,
        this.narration,
        this.bank,
        this.txn_ref,
        this.created_at
      });

  TransferHistory  toTransactionData() {
    // returns a class of Transaction Data to be used in printing receipt
    // this process removes the step of fetching account name again - long sha
    return TransferHistory(
        id: transactionId,
        order_ref: orderId,
        value: amount.split(" ").last,
        currency: currency, // empty because currency follows amount,
        beneficiary_name: accountName,
        beneficiary_account: accountNumber,
        beneficiary_institution: bank,
        status: status,
        txn_ref: txn_ref,
        remark: remarks,
        narration: narration,
        created_at: date
    );
  }




}

// "data":{"id":268,"owner_uuid":"03db7273-b683-404c-8b10-6a0b4e0625da","transfer_type":"external","txn_ref":"Glade|FT|1620388436|60952a54508279|41078714","order_ref":"Glade|FT|1620388436|60952a5413635463823562U","currency":"NGN","value":"17.13","calculatedfee":"16.13","beneficiary_account":"0690000033","beneficiary_institution":"11319374","beneficiary_name":"dev kev","narration":"","remark":"Transfer Queued Successfully","status":"awaiting_verification","method":"bank","destination":"foreign","provider":"flutterwave","provider_ref":"191501","log_ref":null,"created_at":"2021-05-07 11:53:56","updated_at":"2021-05-07 11:54:01"}}






class Biller {
  String name;
  String reference;
  String ref;

  Biller({this.name, this.reference, this.ref});

  @override
  String toString() {
    super.toString();
    return "Name: $name; reference: $reference; ref: $ref";
  }

  Biller.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    reference = json['reference'];
    ref = json['ref'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['reference'] = this.reference;
    data['ref'] = this.ref;
    return data;
  }
}



// class MetaInfo {
//   var units;
//   var token;
//
//   MetaInfo({this.token, this.units});
//
//   MetaInfo.fromJson(Map<String, dynamic> json){
//     print("jsosnosiss $json");
//         // if(json["units"] != null ){
//           units = json["units"] ?? "" ;
//           token = json["token"] ?? " ";
//         // }
//
//
//
//   }
// }


class BillsReceiptData {
  String unit;
  String electricityToken;
  int transactionId;
  String orderId;
  String amount;
  Biller biller;
  String status;
  String remarks;
  String date;
  String bill_reference;
  String txn_ref;
int  bill_item_id;
String bill_name;

  BillsReceiptData(
      {this.transactionId,
        this.orderId,
        this.amount,
        this.biller,
        this.status,
        this.bill_reference,
        this.txn_ref,
        this.electricityToken,
        this.unit,
        this.remarks,
        this.date,
        this.bill_item_id,
        this.bill_name
      });

  AirtimeData toBillsData() {
    return AirtimeData(
        unit: unit,
        token: electricityToken,
        txnRef:  txn_ref,
        orderRef: orderId,
        amount_charged: amount,
        biller: biller,
        status: status,
        note: remarks,
        bill_reference: bill_reference,
        createdAt: date,
        id: transactionId,
      bill_name: bill_name,
      bill_item_id: bill_item_id
    );
  }
}
class AirtimeData {
  var unit;
  String bill_name;
  String token;
  int id;
  String amount;
  String cardCharges;
  String serviceFee;
  String total;
  String currentBalance;
  String discountType;
  var discount;
  String service;
  String mid;
  String orderRef;
  String txnRef;
  String txnInfo;
  String txnDate;
  int isFraud;
  String status;
  int chargeStatus;
  int revertDone;
  String revertRef;
  String note;
  String responseData;
  String createdAt;
  String updatedAt;
  String date;
  String time;
  Biller biller;
  String category;
  String name;
  String amount_charged;
String bill_reference;
  int bill_item_id;
  // MetaInfo metaInfo;

  AirtimeData(
      {

        this.unit,
        this.bill_reference,
        this.token,
        this.id,
        this.amount,
        this.cardCharges,
        this.serviceFee,
        this.total,
        this.currentBalance,
        this.discountType,
        this.discount,
        this.service,
        this.mid,
        this.orderRef,
        this.txnRef,
        this.txnInfo,
        this.txnDate,
        this.isFraud,
        this.status,
        this.chargeStatus,
        this.revertDone,
        this.revertRef,
        this.note,
        this.responseData,
        this.createdAt,
        this.updatedAt,
        this.date,
        this.time,
        this.category,
        this.name,
        this.biller,
        this.bill_item_id,
        this.amount_charged,
        this.bill_name
        // this.metaInfo
      });

  AirtimeData.fromJson(Map<String, dynamic> json) {
        id = json['id'];
        bill_name = json["bill_name"];
    bill_item_id = json["bill_item_id"];
    category = json['category'];
    name = json['name'];
      unit = json["units"];
      token = json["token"];
    amount = json['amount'];
    cardCharges = json['card_charges'];
    serviceFee = json['service_fee'];
    total = json['total'];
    currentBalance = json['currentBalance'];
    discountType = json['discount_type'];
    discount = json['discount'];
    service = json['service'];
    mid = json['mid'];
    orderRef = json['orderRef'];
    txnRef = json['txn_ref'];
    txnInfo = json['txnInfo'];
    txnDate = json['txnDate'];
    isFraud = json['is_fraud'];
    status = json['status'];
    chargeStatus = json['charge_status'];
    revertDone = json['revertDone'];
    revertRef = json['revertRef'];
    note = json['note'];
    responseData = json['responseData'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    date = json['date'];
    time = json['time'];
    amount_charged = json["amount_charged"];
    bill_reference = json["bill_reference"];
    biller = json['biller'] != null ? new Biller.fromJson(json['biller']) : null;
    // if(json["meta_info"] != null){
    //   print("got here");
      // print(json["meta_info"]["provider"]);
  // if( json["meta_info"]["provider"] == "buypower"){
// print("ddddd");
//    // //  if(jsonDecode(json["meta_info"]["response"]["HTTP_CODE"]) == 200){
//    // //    print("njhv");
//    // // // metaInfo = MetaInfo.fromJson(jsonDecode(json["meta_info"]["response"]["BODY"]));
//    // //     }
//    // //  print("not here");
//    // //
//     }
//     }

   }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
    data['name'] = this.name;
    data['amount'] = this.amount;
    data['card_charges'] = this.cardCharges;
    data['service_fee'] = this.serviceFee;
    data['total'] = this.total;
    data['currentBalance'] = this.currentBalance;
    data['discount_type'] = this.discountType;
    data['discount'] = this.discount;
    data['service'] = this.service;
    data['mid'] = this.mid;
    data['orderRef'] = this.orderRef;
    data['txn_ref'] = this.txnRef;
    data['txnInfo'] = this.txnInfo;
    data['txnDate'] = this.txnDate;
    data['is_fraud'] = this.isFraud;
    data['status'] = this.status;
    data['charge_status'] = this.chargeStatus;
    data['revertDone'] = this.revertDone;
    data['revertRef'] = this.revertRef;
    data['note'] = this.note;
    data['responseData'] = this.responseData;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['date'] = this.date;
    data['time'] = this.time;
    data["amount_charged"] = this.amount_charged;
    data["bill_name"] = this.bill_name;
    if (this.biller != null) {
      data['biller'] = this.biller.toJson();
    }
    return data;
  }
}