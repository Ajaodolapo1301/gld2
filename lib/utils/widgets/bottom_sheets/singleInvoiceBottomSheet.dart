





import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glade_v2/api/AccountStatement/accountStatement.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/transactionHistory.dart';
import 'package:glade_v2/core/models/apiModels/Business/Invoice/InvoiceHistory.dart';
import 'package:glade_v2/core/models/ui/TransferReceiptData.dart';
import 'package:glade_v2/pages/business/invoices/tabs/history_tab.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/utils/myUtils/myUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/styles/receipt.dart';
import 'package:overlay_support/overlay_support.dart';

import '../custom_button.dart';

class SingleInvoiceBottomSheet extends StatefulWidget {
  final Color textColor;
  final InvoiceHistory invoiceHistory;
  final TransferReceiptData transferReceiptData;
  InvoiceItemExternal invoiceItem;
  ReceiptScreen receiptScreen;
  BusinessState businessState;
  SingleInvoiceBottomSheet({Key key, this.textColor, this.invoiceHistory, this.receiptScreen,this.businessState, this.transferReceiptData
  }) : super(key: key){
    invoiceItem = InvoiceItemExternal(item: invoiceHistory, businessState: businessState );
  }

  @override
  _SingleInvoiceBottomSheetState createState() => _SingleInvoiceBottomSheetState();
}

class _SingleInvoiceBottomSheetState extends State<SingleInvoiceBottomSheet> {


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              pop(context);
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: lightBlue,
                    border: Border.all(color: borderBlue.withOpacity(0.1))),
                child: Icon(
                  Icons.close,
                  size: 20,
                  color: blue,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            MyUtils.formatDate(widget.invoiceHistory.created_at ),
            style: TextStyle(color: blue, fontSize: 12),
          ),
          SizedBox(height: 10),
          Text(
            "${widget.invoiceHistory.currency} ${widget.invoiceHistory.total_value}",
            style: TextStyle(
              color: widget.textColor ?? barGreen,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width /1.4 ,
                child: Text(
                  widget.invoiceHistory.txn_ref ?? "",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: blue),
                ),
              ),

              SizedBox(width: 5),
              // GestureDetector(
              //   onTap: (){
              //     Clipboard.setData(
              //       new ClipboardData(
              //           text: widget.statement.txn_ref
              //       ),
              //     );
              //     toast("Copied to Clipboard");
              //   },
              //   child: Icon(
              //     Icons.file_copy_rounded,
              //     color: cyan,
              //     size: 15,
              //   ),
              // ),
            ],
          ),
          SizedBox(height: 15),
          Divider(),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  onPressed: () {
                    widget.invoiceItem.printPdf();
                  },
                  color: cyan,
                  text: "Download",
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: CustomButton(
                  onPressed: () {
                    widget.invoiceItem.sharePdf();
                  },
                  color: blue,
                  text: "Share",
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            "Download or share receipt",
            style: TextStyle(color: blue.withOpacity(0.5)),
          )
        ],
      ),
    );
  }
}










