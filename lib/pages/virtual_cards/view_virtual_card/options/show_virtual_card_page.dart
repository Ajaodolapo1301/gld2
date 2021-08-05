import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/VirtualCardModel.dart';
import 'package:glade_v2/pages/virtual_cards/view_virtual_card/options/see_more__virtual_card_transactions_page.dart';
import 'package:glade_v2/utils/functions/bottom_sheet_utils.dart';
import 'package:glade_v2/utils/myUtils/monthFormatter.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/bottom_sheets/transaction_pin_bottom_sheet.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/header.dart';

class ShowVirtualCardPage extends StatefulWidget {
  final VirtualCardModel virtualCardModel;
  ShowVirtualCardPage({this.virtualCardModel});
  @override
  _ShowVirtualCardPageState createState() => _ShowVirtualCardPageState();
}

class _ShowVirtualCardPageState extends State<ShowVirtualCardPage> {

  TextEditingController panNumber = TextEditingController();
  TextEditingController balance = TextEditingController();
  TextEditingController cvv = TextEditingController();
  TextEditingController expiration = TextEditingController();
  TextEditingController cardType = TextEditingController();
  TextEditingController currency = TextEditingController();

  @override
  void initState() {
    panNumber.text = widget.virtualCardModel.card_pan;
    balance.text = widget.virtualCardModel.balance;
//        widget.virtualCardModel.balance;
    cvv.text = widget.virtualCardModel.cvv;
    expiration.text = widget.virtualCardModel.expiration;
//    widget.virtualCardModel.expdate

    cardType.text = widget.virtualCardModel.card_type;
    currency.text = widget.virtualCardModel.currency;

    super.initState();
  }


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
              Container(
                child: Header(
                  text: "Card Information",
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    CustomTextField(
                    textEditingController: panNumber,
                      readOnly: true,
                        header: "PAN Number"

                    ),
                    SizedBox(height: 15),
                    CustomTextField(header: "Card Balance",
                      textEditingController: balance,
                      readOnly: true,

                    ),
                    SizedBox(height: 15),
                    CustomTextField(header: "CCV",

                      textEditingController: cvv,
                      readOnly: true,),
                    SizedBox(height: 15),
                    CustomTextField(header: "Expiration",
                      textEditingController: expiration,
                      readOnly: true,
                      textInputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        MonthInputFormatter()
                      ],
                    ),
                    SizedBox(height: 15),
                    CustomTextField(header: "Card Type",
                      textEditingController: cardType,
                      readOnly: true,
                    ),
                    SizedBox(height: 15),
                    CustomTextField(header: "Currency",
                      textEditingController: currency,
                      readOnly: true,
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Text(
              //         "Freeze this Card",
              //         style: TextStyle(color: blue),
              //       ),
              //     ),
              //     Transform(
              //       transform: Matrix4.identity()
              //         ..scale(0.5)
              //         ..translate(20.0, 20.0),
              //       child: CupertinoSwitch(
              //         value: true,
              //         activeColor: blue,
              //         onChanged: (value) {},
              //       ),
              //     ),
              //   ],
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Text(
              //         "Terminate this Card",
              //         style: TextStyle(color: blue),
              //       ),
              //     ),
              //     Transform(
              //       transform: Matrix4.identity()
              //         ..scale(0.5)
              //         ..translate(20.0, 20.0),
              //       child: CupertinoSwitch(
              //         value: true,
              //         activeColor: blue,
              //         onChanged: (value) {},
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
