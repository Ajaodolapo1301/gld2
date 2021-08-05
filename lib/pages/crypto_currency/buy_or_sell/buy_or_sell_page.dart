import 'package:flutter/material.dart';
import 'package:glade_v2/pages/crypto_currency/buy_or_sell/buy_btc_page.dart';
import 'package:glade_v2/pages/crypto_currency/buy_or_sell/sell_btc_page.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/header.dart';

class BuyOrSellPage extends StatefulWidget {
  @override
  _BuyOrSellPageState createState() => _BuyOrSellPageState();
}

class _BuyOrSellPageState extends State<BuyOrSellPage> {
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
              Header(text: "Buy / Sell BTC"),
              SizedBox(height: 20),
              CustomButton(
                text: "Buy BTC",
                onPressed: () {
                  pushTo(context, BuyBTCPage());
                },
                type: ButtonType.outlined,
              ),
              SizedBox(height: 20),
              CustomButton(
                text: "Sell BTC",
                onPressed: () {
                  pushTo(context, SellBTCPage());
                },
                type: ButtonType.outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
