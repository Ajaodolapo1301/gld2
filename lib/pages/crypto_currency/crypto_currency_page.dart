import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glade_v2/pages/crypto_currency/fund_wallet/fund_crypto_wallet_page.dart';
import 'package:glade_v2/pages/crypto_currency/receive_btc_page.dart';
import 'package:glade_v2/pages/crypto_currency/send_btc_page.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/header.dart';

import 'buy_or_sell/buy_or_sell_page.dart';
import 'withdraw_btc_page.dart';

class CryptoCurrencyPage extends StatefulWidget {
  @override
  _CryptoCurrencyPageState createState() => _CryptoCurrencyPageState();
}

class _CryptoCurrencyPageState extends State<CryptoCurrencyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Header(
                  text: "Crypto Currency",
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerRight,
                  // ignore: deprecated_member_use
                  child: OutlineButton(
                    onPressed: () {
                      pushTo(context, WithdrawBTCPage());
                    },
                    child: Text(
                      "WITHDRAW FUNDS",
                      style: TextStyle(
                          fontFamily: 'DMSans',
                          color: blue,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    ),
                    borderSide: BorderSide(color: cyan),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    shape: StadiumBorder(),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff1FB3FF),
                      Color(0xff6875FF),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Stack(
                  children: [
                    Container(
                      width: double.maxFinite,
                    ),
                    Positioned(
                      left: 110,
                      top: -50,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 20,
                            color: Colors.white.withOpacity(0.25),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 20,
                      top: 30,
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.25)),
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(15),
                              child: SvgPicture.asset(
                                "assets/images/crypto_currency/Icon awesome-btc.svg",
                                height: 20,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.25),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "1.00322BTC",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "BITCOIN WALLET BALANCE",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: 2,
                              height: 120,
                              color: Colors.white.withOpacity(0.25),
                            ),
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "BTC/USD",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  "\$39,445.18",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            SizedBox(width: 5),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          linker(
                              imagePath:
                                  "assets/images/crypto_currency/send.svg",
                              text: "Send",
                              color: almostRed,
                              onTap: () {
                                pushTo(context, SendBTCPage());
                              }),
                          linker(
                              imagePath:
                                  "assets/images/crypto_currency/receive.svg",
                              text: "Receive",
                              color: almostCyan,
                              onTap: () {
                                pushTo(context, ReceiveBTCPage());
                              }),
                          linker(
                            imagePath:
                                "assets/images/crypto_currency/buy_sell.svg",
                            text: 'Buy/Sell',
                            color: almostPurple,
                            onTap: (){
                              pushTo(context, BuyOrSellPage());
                            }
                          ),
                          linker(
                            imagePath: "assets/images/crypto_currency/fund.svg",
                            text: "Fund",
                            color: almostGreen,
                            onTap: (){
                              pushTo(context, FundCryptoWalletPage());
                            }
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 40,
                      color: lightBlue,
                      child: Center(
                        child: Row(
                          children: [
                            SizedBox(width: 15),
                            Text(
                              "RECENT ACTIVITY",
                              style: TextStyle(
                                  color: blue,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector linker(
      {String imagePath,
      String text,
      Color color,
      @required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 65,
            padding: EdgeInsets.all(20),
            child: SvgPicture.asset(
              "$imagePath",
              width: 23,
            ),
            decoration: BoxDecoration(
              color: color,
              border:
                  Border.all(color: borderBlue.withOpacity(0.2), width: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(height: 2),
          Text(
            "$text",
            style: TextStyle(color: blue),
          )
        ],
      ),
    );
  }
}
