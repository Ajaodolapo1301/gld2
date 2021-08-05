import 'package:flutter/material.dart';
import 'package:glade_v2/pages/personal/fund_account/fund_personal_account_with_debit_card_page.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';

import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/account_details_view.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FundAccountPage extends StatefulWidget {
  @override
  _FundAccountPageState createState() => _FundAccountPageState();
}

class _FundAccountPageState extends State<FundAccountPage> {
  LoginState loginState;



  double textScale = 1.0;
  void initTextScale() async {
    var pref = await SharedPreferences.getInstance();
    setState(() {
      textScale = pref.getDouble("textScaleFactor") ?? 1.0;
    });
  }

  @override
  void initState() {
    initTextScale();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    loginState = Provider.of<LoginState>(context);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: textScale),
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 10),
                Header(text: "Fund Account",),
                SizedBox(height: 10),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: 10),
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
                        "Fund Your Account",
                        style: TextStyle(
                            color: blue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Make a transfer from your local bank using the below info or use other payment method available.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: blue, fontSize: 12),
                      ),
                      SizedBox(height: 30),
                      AccountDetailsView(onTap: (){}, loginState: loginState,)
                      ,
                      Spacer(),
                      CustomButton(
                        text: "Use Saved Card",
                        onPressed: (){

                        },
                      ),
                      SizedBox(height: 10),
                      CustomButton(
                        text: "Fund Account with Card",
                        onPressed: (){
                          pushTo(context, FundPersonalAccountWithDebitCardPage());
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
      ),
    );
  }
}

