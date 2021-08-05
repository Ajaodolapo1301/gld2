import 'package:flutter/material.dart';
import 'package:glade_v2/pages/states/fund_account_VirtualCard_successful_page.dart';
import 'package:glade_v2/utils/functions/bottom_sheet_utils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/header.dart';

class FundCryptoWalletWithDebitCardPage extends StatefulWidget {
  @override
  _FundCryptoWalletWithDebitCardPageState createState() =>
      _FundCryptoWalletWithDebitCardPageState();
}

class _FundCryptoWalletWithDebitCardPageState
    extends State<FundCryptoWalletWithDebitCardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 10),
              Header(
                text: "Fund with Debit Card",
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(height: 20),
                    CustomTextField(
                      header: "Enter a Card Title",
                    ),
                    SizedBox(height: 15),
                    CustomTextField(
                      header: "Enter Card Number [ 0000 0000 0000 0000 ]",
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(right: 5, top: 3),
                      child: Text(
                        "VISA",
                        style: TextStyle(
                          color: cyan,
                          fontWeight: FontWeight.bold,
                          fontSize: 10
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    CustomTextField(
                      header: "Valid Date [mm/yy]",
                    ),
                    SizedBox(height: 15),
                    CustomTextField(
                      header: "CVV [000]",
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              CustomButton(
                onPressed: () {

                },
                color: cyan,
                text: "Proceed",
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
