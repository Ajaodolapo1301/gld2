import 'package:flutter/material.dart';
import 'package:glade_v2/utils/functions/bottom_sheet_utils.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/bottom_sheets/transaction_pin_bottom_sheet.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/header.dart';

class SendBTCPage extends StatefulWidget {
  @override
  _SendBTCPageState createState() => _SendBTCPageState();
}

class _SendBTCPageState extends State<SendBTCPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 10),
              Header(text: "Send BTC"),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    CustomTextField(header: "Recipient Address"),
                    SizedBox(height: 32),
                    CustomTextField(
                      headerLess: true,
                      outerSuffix: Container(
                        height: 52.2,
                        width: 50,
                        child: Center(
                          child: Text(
                            "BTC",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: btcBlue,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      alignment: Alignment.centerLeft,
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Icon(
                          Icons.compare_arrows_rounded,
                          size: 30,
                          color: cyan,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    CustomTextField(
                      headerLess: true,
                      outerSuffix: Container(
                        height: 52.2,
                        width: 50,
                        child: Center(
                          child: Text(
                            "USD",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: btcBlue,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "\$1 = ₦400.00",
                            style: TextStyle(color: barGreen, fontSize: 10),
                          ),
                        ),
                        Text(
                          "\$39,000.00 = ₦15,600,000.00",
                          style: TextStyle(color: barGreen, fontSize: 10),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    CustomTextField(header: "Description (Optional)"),
                  ],
                ),
              ),
              CustomButton(
                text: "Proceed",
                onPressed: () {
                  showTransactionPinBottomSheet(context,
                      minuValue: 200,
                      details: TransactionBottomSheetDetails(
                        buttonText: "Transfer Bitcoin",
                        middle: Column(
                          children: [
                            SizedBox(height: 20),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: "Please confirm you want to send ",
                                style: TextStyle(color: blue, fontSize: 12),
                                children: [
                                  TextSpan(
                                    text: "0.0023BTC\n",
                                    style: TextStyle(
                                      color: blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(text: "to "),
                                  TextSpan(
                                    text: "563hfbbzxhdhjfhhhjdsh4758",
                                    style: TextStyle(
                                      color: blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                      onButtonPressed: (pin) {});
                },
                color: cyan,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
