import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/transactionHistory.dart';
import 'package:glade_v2/core/models/ui/TransferReceiptData.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/myUtils/myUtils.dart';

import 'package:http/http.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
// import 'package:gladepay_manager/models/transfer_report.dart' as TransferReport;
// import 'package:gladepay_manager/models/bills_transactions.dart' as BillsReport;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart' as Material;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

import 'color_utils.dart';


class ReceiptScreen {
//  String transactionType; //
//   TransferReport.Data transactionData;
    TransferHistory transferHistory;
 TransferReceiptData transferReceiptData;
 LoginState loginState;
    AirtimeData billsData;
BillsReceiptData billsReceiptData;
  // Data data;
  // ExpensesData expensesData;

  // String accountName;
  // String senderName;

  String breakString(String it, [int charPerLine]){
    String ref = "";
    for (int i = 0; i < it.length; i++) {
      if (i != 0 && i % ((charPerLine ?? 25) + 1) == 0) {
        ref += it[i] + "\n";
      } else {
        ref += it[i];
      }
    }
    return ref;
  }

  ReceiptScreen(
      {
        this.transferHistory,
        this.billsData,
        this.transferReceiptData,
        this.billsReceiptData,
        // this.data,
        this.loginState,
        // this.expensesData,


      }) {
    getImage();
    buildReceipt();

    if (this.transferReceiptData != null) {
      transferHistory = transferReceiptData.toTransactionData();

    }
    else if (this.billsReceiptData != null) {
      billsData = billsReceiptData.toBillsData();
    }

    if (this.transferHistory != null) {
      // if (accountName == null) {
      //   getAccountName(
      //       accNum: transactionData.accountnumber,
      //       bankcode: transactionData.bank)
      //       .then((data) {
      //     if (data.toString().isNotEmpty) {
      //       accountName = data["data"]["account_name"];
      //       Material.debugPrint(accountName);
      //     } else {
      //       accountName = "";
      //     }
      //   });
      // }
    }

    requestPermission();
  }

  requestPermission() async {
    Map<PermissionGroup, PermissionStatus> permissions =
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);
   Material.debugPrint("Permission: $permissions");
  }

  final headerStyle = TextStyle(fontSize: 17);
  final detailStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 17);

  final Document pdf = Document();

  var appDirectory = getApplicationDocumentsDirectory();

  final imageProvider = const Material.AssetImage("assets/images/receipt/logoC.png");
  final bgProvider = const Material.AssetImage("assets/images/receipt/favicon.png");
  final stampProvider = const Material.AssetImage("assets/images/receipt/stamp.png");

  PdfImage image;
  PdfImage bgImage;
  PdfImage stampImage;

  Page page;

  void getImage() async {
    image = await pdfImageFromImageProvider(
        pdf: pdf.document, image: imageProvider);
    bgImage =
    await pdfImageFromImageProvider(pdf: pdf.document, image: bgProvider);

    stampImage = await pdfImageFromImageProvider(
        pdf: pdf.document, image: stampProvider);
  }

  void printB() async {
    buildReceipt();
  }

  // void buildExpensesReceipt() async{
  //   print("Building expenses data");
  //   page = Page(
  //       pageFormat: PdfPageFormat.a4,
  //       build: (_){
  //         var disclaimerText = "Should this document be falsified or manipulated, GLADE INC. will not be held responsible. For any enquiries, please contact Glade's customer care team via email at support@glade.ng";
  //         return Stack(
  //           children: [
  //             Opacity(
  //               opacity: 0.15,
  //               child: Center(
  //                 child: Image(bgImage, height: 300, width: 300),
  //               ),
  //             ),
  //             Positioned(
  //               bottom: -5,
  //               right: 0,
  //               child: Container(
  //                 height: 90,
  //                 width: 90,
  //                 child: Center(child: Image(stampImage)),
  //               ),
  //             ),
  //             Column(
  //               children: [
  //                 Container(
  //                   height: 150,
  //                   width: 300,
  //                   child: Center(child: Image(image)),
  //                 ),
  //                 SizedBox(height: 5),
  //                 Center(
  //                   child: Text(
  //                     "Expenses Receipt",
  //                     style: TextStyle(
  //                       fontSize: 20,
  //                       color: PdfColor.fromHex("#0D3E53"),
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(height: 10),
  //                 Divider(color: PdfColor.fromHex("#D3D3D3")),
  //                 SizedBox(height: 20),
  //                 Row(children: [
  //                   Text(
  //                     "Transaction ID",
  //                     style: headerStyle,
  //                   ),
  //                   Spacer(),
  //                   SizedBox(width: 180),
  //                   Expanded(
  //                       child: Align(
  //                         alignment: Alignment.centerRight,
  //                         child:         Text(breakString(expensesData.txnRef.trim()), style: detailStyle),
  //                       )
  //                   )
  //                 ]),
  //                 SizedBox(height: 12),
  //                 Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
  //                   Text(
  //                     "Amount",
  //                     style: headerStyle,
  //                   ),
  //                   Text(
  //                       "NGN ${formatAmount("${expensesData.amount}")}",
  //                       style: detailStyle),
  //                 ]),
  //                 SizedBox(height: 12),
  //                 Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
  //                   Text(
  //                     "Type",
  //                     style: headerStyle,
  //                   ),
  //                   Text(expensesData.type, style: detailStyle),
  //                 ]),
  //                 SizedBox(height: 12),
  //                 Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
  //                   Text(
  //                     "Status",
  //                     style: headerStyle,
  //                   ),
  //                   Text(expensesData.status == "00" ? "Successful"  : expensesData.status == "02" ? "Pending": "Failed", style: detailStyle),
  //                 ]),
  //                 SizedBox(height: 12),
  //                 Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
  //                   Text(
  //                     "Remark",
  //                     style: headerStyle,
  //                   ),
  //                   Text(expensesData.remark, style: detailStyle),
  //                 ]),
  //                 SizedBox(height: 12),
  //                 Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
  //                   Text(
  //                     "Date",
  //                     style: headerStyle,
  //                   ),
  //                   Text(formatDate(expensesData.updatedAt), style: detailStyle),
  //                 ]),
  //                 SizedBox(height: 12),
  //                 SizedBox(height: 10),
  //                 Center(
  //                   child: Text(
  //                     "DISCLAIMER",
  //                     style: TextStyle(
  //                       color: PdfColor.fromHex("#858282"),
  //                       fontSize: 17,
  //                     ),
  //                   ),
  //                 ),
  //                 Divider(color: PdfColor.fromHex("#D3D3D3")),
  //                 Text(
  //                   disclaimerText,
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                     color: PdfColor.fromHex("#858282"),
  //                     fontSize: 12,
  //                   ),
  //                 ),
  //               ],
  //             )
  //           ],
  //         );
  //
  //       }
  //   );
  //
  // }

  // void buildInflowReceipt() async{
  //   page = Page(
  //       pageFormat: PdfPageFormat.a4,
  //       build: (_){
  //         var disclaimerText = "Should this document be falsified or manipulated, GLADE INC. will not be held responsible. For any enquiries, please contact Glade's customer care team via email at support@glade.ng";
  //         return Stack(
  //           children: [
  //             Opacity(
  //               opacity: 0.15,
  //               child: Center(
  //                 child: Image(bgImage, height: 300, width: 300),
  //               ),
  //             ),
  //             Positioned(
  //               bottom: -5,
  //               right: 0,
  //               child: Container(
  //                 height: 90,
  //                 width: 90,
  //                 child: Center(child: Image(stampImage)),
  //               ),
  //             ),
  //             Column(
  //               children: [
  //                 Container(
  //                   height: 150,
  //                   width: 300,
  //                   child: Center(child: Image(image)),
  //                 ),
  //                 SizedBox(height: 5),
  //                 Center(
  //                   child: Text(
  //                     "Payment Inflow Receipt",
  //                     style: TextStyle(
  //                       fontSize: 20,
  //                       color: PdfColor.fromHex("#0D3E53"),
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(height: 10),
  //                 Divider(color: PdfColor.fromHex("#D3D3D3")),
  //                 SizedBox(height: 20),
  //                 Row(children: [
  //                   Text(
  //                     "Transaction ID",
  //                     style: headerStyle,
  //                   ),
  //                   Spacer(),
  //                   SizedBox(width: 180),
  //                   Expanded(
  //                       child: Align(
  //                         alignment: Alignment.centerRight,
  //                         child:         Text(breakString(data.txnRef.trim()), style: detailStyle),
  //                       )
  //                   )
  //                 ]),
  //                 SizedBox(height: 12),
  //                 Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
  //                   Text(
  //                     "Amount",
  //                     style: headerStyle,
  //                   ),
  //                   Text(
  //                       "${data.currency} ${formatAmount("${data.value}")}",
  //                       style: detailStyle),
  //                 ]),
  //                 SizedBox(height: 12),
  //                 Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
  //                   Text(
  //                     "Customer Name",
  //                     style: headerStyle,
  //                   ),
  //                   Text(data.userFname + " "+data.userLname, style: detailStyle),
  //                 ]),
  //                 SizedBox(height: 12),
  //                 Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
  //                   Text(
  //                     "Payment Type",
  //                     style: headerStyle,
  //                   ),
  //                   Text(data.paymentType, style: detailStyle),
  //                 ]),
  //                 SizedBox(height: 12),
  //                 Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
  //                   Text(
  //                     "Status",
  //                     style: headerStyle,
  //                   ),
  //                   Text(data.status == "00" ? "Successful"  : data.status == "02" ? "Pending": "Failed", style: detailStyle),
  //                 ]),
  //                 SizedBox(height: 12),
  //                 Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
  //                   Text(
  //                     "Remark",
  //                     style: headerStyle,
  //                   ),
  //                   Text(data.remark, style: detailStyle),
  //                 ]),
  //                 SizedBox(height: 12),
  //                 Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
  //                   Text(
  //                     "Date",
  //                     style: headerStyle,
  //                   ),
  //                   Text(formatDate(data.updatedAt), style: detailStyle),
  //                 ]),
  //                 SizedBox(height: 12),
  //                 SizedBox(height: 10),
  //                 Center(
  //                   child: Text(
  //                     "DISCLAIMER",
  //                     style: TextStyle(
  //                       color: PdfColor.fromHex("#858282"),
  //                       fontSize: 17,
  //                     ),
  //                   ),
  //                 ),
  //                 Divider(color: PdfColor.fromHex("#D3D3D3")),
  //                 Text(
  //                   disclaimerText,
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                     color: PdfColor.fromHex("#858282"),
  //                     fontSize: 12,
  //                   ),
  //                 ),
  //               ],
  //             )
  //           ],
  //         );
  //
  //       }
  //   );
  // }

//  Widget build(Context context) {
  void buildReceipt() async {
    var color = headerColor;
    print("Doing started a;ready");

    // if(expensesData != null){
    //   buildExpensesReceipt();
    // }
    // else if(data != null){
    //   print("Doing this instead");
    //   buildInflowReceipt();
    // }
    // else
    //   {
      print("Doing this this instead");
      print("tr");
      page = Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          var disclaimerText = transferHistory != null
              ? "Your Transfer has been successful and the beneficiary's account will be credited. Should this document be falsified or manipulated, GLADE INC. will not be held responsible. For any enquiries, please contact Glade's customer care team via email at support@glade.ng"
              : "Your transaction was successful. Should this document be falsified or manipulated, GLADE INC. will not be held responsible. For any enquiries, please contact Glade's customer care team via email at support@glade.ng";
          return Stack(
            children: [
              Opacity(
                opacity: 0.15,
                child: Center(
                  child: Image(bgImage, height: 300, width: 300),
                ),
              ),
              Positioned(
                bottom: -5,
                right: 0,
                child: Container(
                  height: 90,
                  width: 90,
                  child: Center(child: Image(stampImage)),
                ),
              ),
              Column(
                children: [
                  Container(
                    height: 150,
                    width: 300,
                    child: Center(child: Image(image)),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Text(
                      "Transaction Receipt",
                      style: TextStyle(
                        fontSize: 20,
                        color: PdfColor.fromHex("#0D3E53"),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(color: PdfColor.fromHex("#D3D3D3")),
                  SizedBox(height: 20),
                  transferHistory != null ? buildTransactionReceipt()
                      : buildBillsReceipt(),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      "DISCLAIMER",
                      style: TextStyle(
                        color: PdfColor.fromHex("#858282"),
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Divider(color: PdfColor.fromHex("#D3D3D3")),
                  Text(
                    disclaimerText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PdfColor.fromHex("#858282"),
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            ],
          );
        },
      );

    // }
//    return null;

    pdf.addPage(page);
  }

  Widget buildTransactionReceipt() {
    // var bank;
    // if(transferHistory.bank == "Glade"){
    //   bank = transactionData.bank;
    // }else{
    //   bank = BanksSingleton().banks[BanksSingleton()
    //       .banks
    //       .indexWhere((element) => element['code'] == transactionData.bank)]
    //   ['name'];
    // }

    Material.debugPrint(
        "Transaction accountNumber: ${transferHistory.beneficiary_account}, accountName: ${transferHistory.beneficiary_name}"
            ", status:${transferHistory.status ?? false }, txf:${transferHistory.txn_ref }");
    return Column(children: [
      Row(children: [
        Text(
          "Transaction ID",
          style: headerStyle,
        ),
        Spacer(),
        // SizedBox(width: 180),
        Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child:         Text(breakString(transferHistory.txn_ref.trim()), style: detailStyle),
            )
        ),
        SizedBox(width: 120),
      ]),
      SizedBox(height: 12),
//      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//        Text(
//          "Order ID",
//          style: headerStyle,
//        ),
//        Text(transactionData.orderRef, style: detailStyle),
//      ]),
//      SizedBox(height: 12),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          "Amount",
          style: headerStyle,
        ),
        Text(
           " ${transferHistory.currency} ${transferHistory.value}" ?? "vl",
            style: detailStyle),
      ]),
      SizedBox(height: 12),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          "Sender Name",
          style: headerStyle,
        ),
        Text("${loginState.user.firstname} ${loginState.user.lastname} " ?? "name", style: detailStyle),
      ]),
      SizedBox(height: 12),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          "Account Number",
          style: headerStyle,
        ),
        Text(transferHistory.beneficiary_account ?? "acctn", style: detailStyle),
      ]),
      SizedBox(height: 12),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          "Account Name",
          style: headerStyle,
        ),
        Text(transferHistory.beneficiary_name, style: detailStyle),
      ]),
      SizedBox(height: 12),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          "Bank",
          style: headerStyle,
        ),
        Text(transferHistory.beneficiary_institution ??" bank", style: detailStyle),
      ]),
      SizedBox(height: 12),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          "Status",
          style: headerStyle,
        ),
        Text(transferHistory.status  ?? "ss", style: detailStyle),
      ]),
      SizedBox(height: 12),
      transferHistory.narration == "" ? SizedBox() :    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          "Remarks",
          style: headerStyle,
        ),
        Text(transferHistory.narration ?? "rem", style: detailStyle),
      ]),
      SizedBox(height: 12),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          "Date",
          style: headerStyle,
        ),
        Text(MyUtils.formatDate(transferHistory.created_at) ?? "date", style: detailStyle),
      ]),
      SizedBox(height: 12),
      transferHistory.narration == "" ? SizedBox() :     Row(children: [
        Text(
          "Narration",
          style: headerStyle,
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(left: 20),
            child: Text(
                transferHistory.narration ?? "nara",
                style: detailStyle),
          ),
        ),
      ]),
    ]);
  }

  Widget buildBillsReceipt() {
    Material.debugPrint(
        "id ${billsData.status}, amount: ${billsData.amount_charged}"
            ", ref:${billsData.bill_reference  }, txf:${billsData.txnRef }");
    return Column(children: [

      Row(children: [
        Text(
          "Transaction ID",
          style: headerStyle,
        ),
        Spacer(),
        // SizedBox(width: 178),
        Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child:         Text(breakString(billsData.txnRef.trim()), style: detailStyle),
            )
        ),
        SizedBox(width: 120),
      ]),
        // Expanded(
        //     child: Align(
        //       alignment: Alignment.centerRight,
        //       child:   Text(breakString(billsData.txnRef.trim()), style: detailStyle),
        //     )
        // )
      // ]),
      SizedBox(height: 12),
//      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//        Text(
//          "Order ID",
//          style: headerStyle,
//        ),
//        Text(billsData.orderRef, style: detailStyle),
//      ]),
//      SizedBox(height: 12),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          "Amount",
          style: headerStyle,
        ),
        Text(
            "NGN ${MyUtils.formatAmount(billsData.amount_charged)}",
            style: detailStyle),
      ]),
      SizedBox(height: 12),
      // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      //   Text(
      //     billsData.biller != null ? "Bills" : "Category" ?? "",
      //     style: headerStyle,
      //   ),
      //   Text(
      //     billsData.biller != null
      //         ? billsData.biller.name
      //         : billsData.category ?? "",
      //     style: detailStyle,
      //   ),
      // ]),
      billsData.bill_item_id != null
          ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          "Name" ?? "",
          style: headerStyle,
        ),
        Text(
          billsData.bill_name,
          style: detailStyle,
        ),
      ]) : SizedBox(),
      SizedBox(height: 12),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          "Status",
          style: headerStyle,
        ),
        Text(billsData.status ?? "", style: detailStyle),
      ]),
      SizedBox(height: 12),
      billsData.note == "" || billsData.note == null ? Container() :

      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          "Remarks",
          style: headerStyle,
        ),
        Text(billsData.note ?? "", style: detailStyle),
      ]),
      SizedBox(height: 12),

      billsData.token == "" || billsData.token == null ? Container() :   Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          "Token",
          style: headerStyle,
        ),
        Text(billsData.token ?? "", style: detailStyle),
      ]),
      SizedBox(height: 12),
      billsData.unit == "" || billsData.unit == null ? Container() :
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          "Unit",
          style: headerStyle,
        ),
        Text("${billsData.unit} units" ?? "", style: detailStyle),
      ]),
      SizedBox(height: 12),




      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          "Date",
          style: headerStyle,
        ),
        Text(MyUtils.formatDate(billsData.createdAt), style: detailStyle),
      ]),
      SizedBox(height: 12),
    ]);
  }

  Future<bool> downloadTransactionPdf() async {
//    pdf.addPage(page);

    if (transferHistory.beneficiary_name != null) {
      Directory output = await getApplicationDocumentsDirectory();
      Material.debugPrint(output.path);
      File file ;
    if(Platform.isIOS){
       file = File("${output.path}/${transferHistory.txn_ref.replaceAll("|", "_")}.pdf");
    }
       file = File(
          "/storage/emulated/0/Download/${transferHistory.txn_ref.replaceAll("|", "\|")}.pdf");
      await file.writeAsBytes(pdf.save());
//      Material.debugPrint("File saved");

      print(file);
      return true;
    }
    // else {
    //   await getAccountName(
    //       accNum: transactionData.accountnumber,
    //       bankcode: transactionData.bank)
    //       .then((d) {
    //     print(d);
    //     accountName = d["data"]["account_name"];
    //     downloadTransactionPdf();
    //   });
    // }

    return false;

//    return true;
  }

//   Future<bool> downloadBillsPdf() async {
//     Directory output = await getApplicationDocumentsDirectory();
//     Material.debugPrint(output.path);
//
// //    final file = File("${output.path}/${transactionData.txnRef.replaceAll("|", "_")}.pdf");
//     final file = File(
//         "/storage/emulated/0/Download/${billsData.txnRef.replaceAll("|", "\|")}.pdf");
//     await file.writeAsBytes(pdf.save());
// //      Material.debugPrint("File saved");
//     return true;
//   }



  sharePdf() async {
    // wait for name to load
    if (transferHistory != null) {
      await Printing.sharePdf(
        bytes: pdf.save(),
        filename: "${transferHistory.txn_ref.replaceAll("|", "\|")}.pdf",
      );
    }
    else {
      await Printing.sharePdf(
        bytes: pdf.save(),
        filename: "${billsData.txnRef.replaceAll("|", "\|")}.pdf",
      );
    }
  }

  printPdf() async {
    // wait for name to load
    buildReceipt();
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  void saveImage() async {
    Material.debugPrint("Save image");
    final filename = "logoC.png";
    var bytes = await rootBundle.load("assets/images/logoC.png");
    final buffer = bytes.buffer;
    final path = await getApplicationDocumentsDirectory();
    Material.debugPrint("Path: ${path.path}");
    File("${path.path}/$filename").writeAsBytes(
        buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
    Material.debugPrint("Save image");
  }
}









