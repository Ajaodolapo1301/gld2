import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glade_v2/utils/functions/bottom_sheet_utils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/bottom_sheets/transaction_pin_bottom_sheet.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/header.dart';

class ReceiveBTCPage extends StatefulWidget {
  @override
  _ReceiveBTCPageState createState() => _ReceiveBTCPageState();
}

class _ReceiveBTCPageState extends State<ReceiveBTCPage> {
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
              Header(text: "Receive BTC"),
              Expanded(
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: SvgPicture.asset(
                        "assets/images/crypto_currency/qr.svg",
                        width: 200,
                      ),
                    ),
                    SizedBox(height: 40),
                    Text(
                      "Wallet Address",
                      style: TextStyle(
                        color: blue,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "354gydade12638382hh2yt23uyyu3rh",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: blue, fontSize: 12),
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onPressed: () {},
                            color: cyan,
                            text: "Copy Address",
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: CustomButton(
                            onPressed: () {},
                            color: blue,
                            text: "Share QR Code",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),

                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
