import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glade_v2/core/models/ui/TransferReceiptData.dart';
import 'package:glade_v2/pages/dashboard/dashboard_page.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/styles/receipt.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';

class AirtimeAndBillsSuccessfulPage extends StatefulWidget {
  final message;

  BillsReceiptData billsReceiptData;
  AirtimeAndBillsSuccessfulPage({this.message, this.billsReceiptData});
  @override
  _AirtimeAndBillsSuccessfulPageState createState() =>
      _AirtimeAndBillsSuccessfulPageState();
}

class _AirtimeAndBillsSuccessfulPageState
    extends State<AirtimeAndBillsSuccessfulPage> with AfterLayoutMixin<AirtimeAndBillsSuccessfulPage> {

  ReceiptScreen receiptScreen;
  @override
  Widget build(BuildContext context) {
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
                   widget.message ??  "Successful Purchase.",
                    style: TextStyle(
                      color: blue,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Transfer receipt has been generated. \nKindly below to download or share.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: blue, fontSize: 12),
                  ),
                  SizedBox(height: 30),
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
                  ),
                  SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      pop(context);

                      pushToAndClearStack(context, DashboardPage());
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
        ReceiptScreen(billsReceiptData: widget.billsReceiptData);
  }
}
