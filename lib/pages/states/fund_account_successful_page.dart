import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/VirtualCardModel.dart';
import 'package:glade_v2/pages/dashboard/dashboard_page.dart';
import 'package:glade_v2/pages/personal/fund_account/fund_personal_account_page.dart';
import 'package:glade_v2/pages/virtual_cards/view_virtual_card/view_virtual_card_page.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';

class FundAccountSuccessfulPage extends StatefulWidget {
  // final VirtualCardModel virtualCardModel;
  // FundAccountSuccessfulPage({this.virtualCardModel});
  @override
  _FundAccountSuccessfulPageState createState() =>
      _FundAccountSuccessfulPageState();
}

class _FundAccountSuccessfulPageState extends State<FundAccountSuccessfulPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: ()async {
          pushToAndClearStack(context, DashboardPage());
          return false;
        },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: SvgPicture.asset("assets/images/states/confetti.svg"),
                  ),
                  SizedBox(height: 40),
                  Text(
                    "Funding is being processed",
                    style: TextStyle(
                      color: blue,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Funding is being processed",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: blue, fontSize: 12),
                  ),
                  SizedBox(height: 60),
                  GestureDetector(
                    onTap: (){
                      pop(context);
                      pop(context);
                  pushReplacementTo(context, FundPersonalAccountPage());

                    },
                    child: Text(
                      "GO BACK",
                      style: TextStyle(
                        color: cyan,
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
