



import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glade_v2/pages/dashboard/dashboard_page.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';

class InvoiceSuccessfulPage extends StatefulWidget {
  @override
  _AirtimeAndBillsSuccessfulPageState createState() =>
      _AirtimeAndBillsSuccessfulPageState();
}

class _AirtimeAndBillsSuccessfulPageState
    extends State<InvoiceSuccessfulPage> {
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
                    child: SvgPicture.asset(
                      "assets/images/states/invoice.svg",
                      width: 200,
                      height: 105,
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    "Invoice sent Successfully.",
                    style: TextStyle(
                      color: blue,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Invoice preview has been generated. Kindly check history to download or share.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: blue, fontSize: 12),
                  ),
                  SizedBox(height: 30),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: CustomButton(
                  //         onPressed: () {},
                  //         color: cyan,
                  //         text: "Download",
                  //       ),
                  //     ),
                  //     SizedBox(width: 10),
                  //     Expanded(
                  //       child: CustomButton(
                  //         onPressed: () {},
                  //         color: blue,
                  //         text: "Share",
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      // pop(context);
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
}