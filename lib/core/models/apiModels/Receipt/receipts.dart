


// class TransferReceiptData {
//   // for printing receipt immediately after a transaction
//
//   String transactionId;
//   String orderId;
//   String amount;
//   String accountNumber;
//   String accountName;
//   String status;
//   String remarks;
//   String date;
//   String narration;
//   String bank;
//
//   TransferReceiptData(
//       {this.transactionId,
//         this.orderId,
//         this.amount,
//         this.accountNumber,
//         this.accountName,
//         this.status,
//         this.remarks,
//         this.date,  this.narration, this.bank});
//
// //  Data  toTransactionData() {
// //    // returns a class of Transaction Data to be used in printing receipt
// //    // this process removes the step of fetching account name again - long sha
// //    return Data(
// //        txnRef: transactionId,
// //        reference: orderId,
// //        amount: amount.split(" ").last,
// //        currency: "NGN", // empty because currency follows amount,
// //        senderName: accountName,
// //        accountnumber: accountNumber,
// //        accountName: accountName,
// //        status: status,
// //        remark: remarks,
// //        bank: bank,
// //        narration: narration,
// //        createdAt: date);
// //  }
// }