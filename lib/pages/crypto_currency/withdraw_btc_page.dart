import 'package:flutter/material.dart';
import 'package:glade_v2/utils/functions/bottom_sheet_utils.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/bottom_sheets/transaction_pin_bottom_sheet.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/header.dart';

class WithdrawBTCPage extends StatefulWidget {
  @override
  _WithdrawBTCPageState createState() => _WithdrawBTCPageState();
}

class _WithdrawBTCPageState extends State<WithdrawBTCPage> {
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
              Header(text: "Withdraw BTC"),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    CustomTextField(
                      headerLess: true,
                      outerSuffix: Container(
                        height: 52.2,
                        width: 50,
                        child: Center(
                          child: Text(
                            "NGN",
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
                    SizedBox(height: 30),
                    CustomTextField(
                      headerLess: true,
                      hint: "BTC Worth",
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
                    Text(
                      "Rate: ₦400/\$1",
                      style: TextStyle(color: barGreen, fontSize: 12),
                    ),
                  ],
                ),
              ),
              CustomButton(
                text: "Proceed",
                onPressed: () {
                  showTransactionPinBottomSheet(context,
                      details: TransactionBottomSheetDetails(
                        buttonText: "Sell Bitcoin",
                        middle: Column(
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: "Please confirm you want to sell\n",
                                style: TextStyle(color: blue, fontSize: 12),
                                children: [
                                  TextSpan(
                                    text: "0.0023BTC\n",
                                    style: TextStyle(
                                      color: blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "Fee applied: \$1",
                              style: TextStyle(
                                color: barGreen
                              ),
                            )
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
