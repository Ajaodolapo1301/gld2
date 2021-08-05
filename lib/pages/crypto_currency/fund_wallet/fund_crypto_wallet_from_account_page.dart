import 'package:flutter/material.dart';
import 'package:glade_v2/utils/functions/bottom_sheet_utils.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/bottom_sheets/transaction_pin_bottom_sheet.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/header.dart';

class FundCryptoWalletFromAccountPage extends StatefulWidget {
  @override
  _FundCryptoWalletFromAccountPageState createState() =>
      _FundCryptoWalletFromAccountPageState();
}

class _FundCryptoWalletFromAccountPageState
    extends State<FundCryptoWalletFromAccountPage> {
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
              Header(text: "Fund from Account"),
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
                    SizedBox(height: 2),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Rate: ₦400/\$1",
                        style: TextStyle(color: barGreen, fontSize: 12),
                      ),
                    ),
                    SizedBox(height: 25),
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
                    SizedBox(height: 25),
                    CustomTextField(
                      header: "Remark",
                      hint: "Remark",
                    ),
                  ],
                ),
              ),
              CustomButton(
                text: "Proceed",
                onPressed: () {

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
