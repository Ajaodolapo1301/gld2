import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/transactionHistory.dart';
import 'package:glade_v2/core/models/apiModels/Receipt/receipts.dart';
import 'package:glade_v2/core/models/ui/TransferReceiptData.dart';
import 'package:glade_v2/pages/dashboard/dashboard_page.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/styles/receipt.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class FundTransferSuccessfulPage extends StatefulWidget {
  final String status;
  final String message;
  final String ref;
  final bool isbulk;
  // final bool isDark;
  final double textScale;
  final TransferReceiptData transferReceiptData;
  final   TransferHistory transferHistory;
  // final BillsReceiptData billsReceiptData;

  // ReceiptScreen receiptScreen;
  String accountName;


  FundTransferSuccessfulPage(
      {Key key,
         this.status,
         this.message,
         this.ref,
        this.accountName,
        this.transferReceiptData,
        this.transferHistory,
        this.isbulk = false,
        // this.billsReceiptData,
        // this.isDark = false,
        this.textScale}) {
   // super(key: key);

    // else if (billsReceiptData != null) {
    //   receiptScreen = ReceiptScreen(billsReceiptData: billsReceiptData);
    // }
  }
  @override
  _FundTransferSuccessfulPageState createState() =>
      _FundTransferSuccessfulPageState();
}

class _FundTransferSuccessfulPageState
    extends State<FundTransferSuccessfulPage> with AfterLayoutMixin<FundTransferSuccessfulPage> {

  ReceiptScreen receiptScreen;
  LoginState loginState;
  @override
  Widget build(BuildContext context) {
    loginState = Provider.of(context);
    return WillPopScope(
      onWillPop: ()async{
      pushToAndClearStack(context, DashboardPage());
      return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Image.asset(
                      "assets/images/login rocket.png",
                      width: 200,
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    widget?.status != "successful"  ?  "Transfer Queued Successfully" :           "Transfer was  Successful.",
                    style: TextStyle(
                      color: blue,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                 widget?.status != "successful"  ? "Your transfer is being Processed" :
                 "Transfer receipt has been generated. \nKindly below to download or share.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: blue, fontSize: 12),
                  ),
                  SizedBox(height: 30),
           widget?.status == "successful" && widget?.isbulk == false ?
           Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          onPressed: () {
                            receiptScreen.printPdf();
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
                  ):
           SizedBox(),
                  SizedBox(height: 40),
                 GestureDetector(
                    onTap: () {
                     pop(context);

                  pushReplacementTo(context, DashboardPage());
                    },
                    child: Text(
                      "GO BACK",
                      style: TextStyle(
                          color: cyan, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
asyncFunc();
  }
  void asyncFunc() async {
    // String name = (await SharedPreferences.getInstance()).getString("name");
    receiptScreen =
        ReceiptScreen(transferReceiptData: widget.transferReceiptData,   transferHistory: widget.transferHistory,  loginState: loginState );
  }
}
