import 'package:flutter/material.dart';
import 'package:glade_v2/pages/crypto_currency/fund_wallet/fund_crypto_wallet_from_account_page.dart';
import 'package:glade_v2/pages/crypto_currency/fund_wallet/fund_crypto_wallet_with_debit_card_page.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/header.dart';

class FundCryptoWalletPage extends StatelessWidget {
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
                text: "Fund Crypto Wallet",
              ),
              SizedBox(height: 10),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: lightBlue,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: borderBlue.withOpacity(0.2),
                        ),
                      ),
                      child: Image.asset(
                        "assets/images/bank.png",
                        width: 70,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Fund Your Wallet",
                      style: TextStyle(
                          color: blue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Fund your Bitcoin wallet from your Account \nor a Debit card.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: blue, fontSize: 12),
                    ),
                    SizedBox(height: 30),
                    Spacer(),
                    CustomButton(
                      text: "Fund From Account",
                      onPressed: () {
                        pushTo(context, FundCryptoWalletFromAccountPage());
                      },
                    ),
                    SizedBox(height: 10),
                    CustomButton(
                      text: "Fund with Debit Card",
                      onPressed: () {
                        pushTo(context, FundCryptoWalletWithDebitCardPage());
                      },
                      type: ButtonType.outlined,
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
