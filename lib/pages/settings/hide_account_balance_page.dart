import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:glade_v2/provider/appState.dart';

import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HideAccountBalancePage extends StatefulWidget {
  @override
  _HideAccountBalancePageState createState() => _HideAccountBalancePageState();
}

class _HideAccountBalancePageState extends State<HideAccountBalancePage> with AfterLayoutMixin<HideAccountBalancePage> {

 AppState appState;
// TextEditingController pseudoAmountController  = TextEditingController();
 MoneyMaskedTextController pseudoAmountController = MoneyMaskedTextController(
     decimalSeparator: ".", leftSymbol: "NGN ", thousandSeparator: ",");
  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);
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
                  text: "Hide Account Balance",
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Container(
                  child: ListView(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Hide my Account Balance",
                                      style: TextStyle(color: blue, fontSize: 11),
                                    ),
                                  ),
                                  Transform(
                                    transform: Matrix4.identity()
                                      ..scale(0.5)
                                      ..translate(70.0, 20),
                                    child: CupertinoSwitch(
                                      value:  appState.enableHiddenAmount,
                                      onChanged: (v) {
                                        setState(() {
                                          appState.enableHiddenAmount = v;
                                        });

                                        SharedPreferences.getInstance().then((prefs) {
                                          prefs.setBool("enableHiddenAmount", appState.enableHiddenAmount);
                                        });

                                      },
                                      activeColor: cyan,
                                    ),
                                  ),
                                ],
                              ),
                              padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: lightBlue,
                                border: Border.all(
                                  color: borderBlue.withOpacity(0.2),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Prevent intruders from snooping in on your \nReal account Account Balance.",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: blue, fontSize: 12),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Divider(),
                      SizedBox(height: 20),
           appState.enableHiddenAmount ?           Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            CustomTextField(
                              type: FieldType.number,
//                            textInputFormatters: [
//                              WhitelistingTextInputFormatter.digitsOnly,
//                              // Fit the validating format.
//                              //fazer o formater para dinheiro
//                              CurrencyInputFormatter()
//                            ],
                              header: "Enter Amount",

                              textEditingController: pseudoAmountController,
                            ),
                            SizedBox(height: 10),
                            Center(
                              child: Text(
                                "NB: This is not your real Account Balance".toUpperCase(),
                                style: TextStyle(
                                  color: cyan,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ],
                        ),
                      ) : Container(),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              appState.enableHiddenAmount ?              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomButton(
                  text: "Set Pseudo Balance",
                  onPressed: () {
                    SharedPreferences.getInstance()
                        .then((prefs) {prefs.setString(
                          "pseudoBalance",
                          pseudoAmountController.text
                              .replaceAll("NGN", "")
                              .replaceAll(",", "")
                              .trim()
                              .split(".")[0]);
                      appState.pseudoBalance = pseudoAmountController.text
                          .replaceAll("NGN", "")
                          .replaceAll(",", "")
                          .trim()
                          .split(".")[0];
                    });
                    Navigator.pop(context);
                  },
                ),
              ) :Container() ,
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    pseudoAmountController.text = "${appState.pseudoBalance}.00";
  }
}
