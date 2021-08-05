import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/VirtualCardModel.dart';
import 'package:glade_v2/pages/dashboard/dashboard_page.dart';
import 'package:glade_v2/pages/virtual_cards/view_virtual_card/view_virtual_card_page.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';

class FundAccountVirtualCardSuccessfulPage extends StatefulWidget {
  final VirtualCardModel virtualCardModel;
  FundAccountVirtualCardSuccessfulPage({this.virtualCardModel});
  @override
  _FundAccountVirtualCardSuccessfulPageState createState() =>
      _FundAccountVirtualCardSuccessfulPageState();
}

class _FundAccountVirtualCardSuccessfulPageState extends State<FundAccountVirtualCardSuccessfulPage> {
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
                    "Funding Was Successful",
                    style: TextStyle(
                      color: blue,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Virtual Card funding was successful",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: blue, fontSize: 12),
                  ),
                  SizedBox(height: 60),
                  GestureDetector(
                    onTap: (){
                      pop(context);
                      pop(context);
                      // pop(context);
                      pushReplacementTo(context, ViewVirtualCardPage(
                        virtualCardId: widget.virtualCardModel.card_id,
                      ));
                      // pop(context);
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
