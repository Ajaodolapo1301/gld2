import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/transactionHistory.dart';
import 'package:glade_v2/core/models/ui/TransferReceiptData.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/myUtils/myUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/styles/receipt.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class SingleFundTransfer extends StatefulWidget {
  final Color textColor;
  final TransferHistory transferHistory;
  final TransferReceiptData transferReceiptData;
  const SingleFundTransfer(
      {Key key, this.textColor, this.transferHistory, this.transferReceiptData})
      : super(key: key);

  @override
  _SingleFundTransferState createState() => _SingleFundTransferState();
}

class _SingleFundTransferState extends State<SingleFundTransfer>
    with AfterLayoutMixin<SingleFundTransfer> {
  ReceiptScreen receiptScreen;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  LoginState loginState;
  @override
  void initState() {
    // asyncFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loginState = Provider.of<LoginState>(context);
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
            " ${MyUtils.formatDate(widget.transferHistory.created_at)}",
            style: TextStyle(color: blue, fontSize: 12),
          ),
          SizedBox(height: 10),
          Text(
            "${widget.transferHistory.currency} ${widget.transferHistory.value}",
            style: TextStyle(
              color: widget.textColor ?? barGreen,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 60,
                child: Text(
                  widget.transferHistory.txn_ref,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: blue),
                ),
              ),
              SizedBox(width: 5),
              InkWell(
                onTap: () {
                  Clipboard.setData(
                    new ClipboardData(
                      text: widget.transferHistory.txn_ref,
                    ),
                  );
                  toast("Copied to Clipboard");
                },
                child: Icon(
                  Icons.file_copy_rounded,
                  color: cyan,
                  size: 15,
                ),
              ),
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
                    receiptScreen.printPdf();
                    // receiptScreen
                    //     .downloadTransactionPdf()
                    //     .then((b) {
                    //   if (b) {
                    //     Navigator.pop(
                    //         context);
                    //       showSimpleNotification(
                    //         Text("Receipt Downloaded. Check your Download folder"),
                    //         background: Colors.green
                    //
                    //       );
                    //   }
                    // });
                  },
                  color: cyan,
                  text: "Download",
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: CustomButton(
                  onPressed: () {
                    receiptScreen.sharePdf();
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

  @override
  void afterFirstLayout(BuildContext context) {
    asyncFunc();
  }

  void asyncFunc() async {
    // String name = (await SharedPreferences.getInstance()).getString("name");
    receiptScreen = ReceiptScreen(
        transferReceiptData: widget.transferReceiptData,
        transferHistory: widget.transferHistory,
        loginState: loginState);
  }
}
