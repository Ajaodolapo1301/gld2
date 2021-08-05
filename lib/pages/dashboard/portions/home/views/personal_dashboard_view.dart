import 'package:flutter/material.dart';
import 'package:glade_v2/pages/business/airtime_and_bills/airtime_and_bills_page.dart';
import 'package:glade_v2/pages/crypto_currency/crypto_currency_page.dart';
import 'package:glade_v2/pages/personal/account_statement/personal_account_statement_page.dart';
import 'package:glade_v2/pages/personal/go_live/go_live_personal_page.dart';
import 'package:glade_v2/pages/personal/reserve_funds/reserve_funds_page.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/body_modal_not_live.dart';
import 'package:glade_v2/utils/widgets/home_card.dart';
import 'package:provider/provider.dart';

import '../../../../switch_account_page.dart';

class PersonalDashboardView extends StatefulWidget {
  final AnimationController fadeController;
  final VoidCallback onSwitch;
  final bool hasAccount;
  final VoidCallback onClickFundTransfer;


  const PersonalDashboardView({
    Key key,
    this.fadeController,
    this.onSwitch, this.hasAccount, this.onClickFundTransfer,
  }) : super(key: key);

  @override
  _PersonalDashboardViewState createState() => _PersonalDashboardViewState();
}

class _PersonalDashboardViewState extends State<PersonalDashboardView> with AutomaticKeepAliveClientMixin {
  LoginState loginState;
  @override
  Widget build(BuildContext context) {
     loginState = Provider.of(context);

    super.build(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
   loginState.user.compliance_status == "approved"   ? Container() :   loginState.user.compliance_status == "pending" ?

   FadeTransition(
     opacity: widget.fadeController.drive(Tween(begin: 0.4, end: 1.0)),
     child: Container(
       color: Colors.white,
       width: double.maxFinite,
       padding: EdgeInsets.only(bottom: 10, top: 5),
       child: Center(
         child: Text(
           "Activation is under review",
           style: TextStyle(color: Colors.orange, fontSize: 12),
         ),
       ),
     ),
   ) : loginState.user.compliance_status == "rejected" ?
   GestureDetector(
     onTap: (){
       pushTo(context, GoLivePage());
     },
     child: FadeTransition(
       opacity: widget.fadeController.drive(Tween(begin: 0.3, end: 1.0)),
       child: Container(
         color: Colors.white,
         width: double.maxFinite,
         padding: EdgeInsets.only(bottom: 10, top: 5),
         child: Center(
           child: Text(
             "Your submission was rejected, please check and resubmit!",
             style: TextStyle(color: Colors.red, fontSize: 12),
           ),
         ),
       ),
     ),
   ) :   GestureDetector(
     onTap: (){
       pushTo(context, GoLivePage());
     },
     child: FadeTransition(
       opacity: widget.fadeController.drive(Tween(begin: 0.4, end: 1.0)),
       child: Container(
         color: Colors.white,
         width: double.maxFinite,
         padding: EdgeInsets.only(bottom: 10, top: 5),
         child: Center(
           child: Text(
             "Activate your account for transactions!",
             style: TextStyle(color: Colors.red, fontSize: 12),
           ),
         ),
       ),
     ),

   ),



    loginState.user.business_message!= null ?  GestureDetector(
          onTap: ()=> pushTo(context, SwitchAccountPage()),
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Text(
                  "Please Set a Default Business",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.red),
                ),
                Spacer(),
                Icon(
                  Icons.add,
                  color: cyan,
                ),
              ],
            ),
          ),
        ):
        GestureDetector(
          onTap: widget.onSwitch,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Text(
                  widget.hasAccount ?  "Switch to Business Account": "Add a Business Account",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: blue),
                ),
                Spacer(),
                Icon(
                  widget.hasAccount ?  Icons.all_inclusive_rounded: Icons.add_circle_outline_rounded,
                  color: cyan,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 5),
        Expanded(
          child: ListView(
            children: [
              Row(
                children: [
                  Expanded(
                    child: HomeCard(
                      imagePath: "assets/images/home/fund_transfer.png",
                      mainText: "Fund\nTransfer",
                      subText: "Send money locally & Internationally.",
                      color: almostRed,
                      onTap: widget.onClickFundTransfer,
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: HomeCard(
                      imagePath: "assets/images/home/reserve_fund.png",
                      mainText: "Stash\nFunds",
                      subText: "Put away money for small or big projects.",
                      color: almostCyan,
                      onTap: (){
                        CommonUtils.modalBottomSheetMenu(context: context, body: StashModal());
                        // CommonUtils.kShowSnackBar(ctx: context, msg: "Feature Coming soon");
                        // pushTo(context, ReserveFundsPage());
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: HomeCard(
                      imagePath: "assets/images/home/airtime_and_bills.png",
                      mainText: "Airtime\nAnd Bills",
                      subText: "Make Bill Payment and Purchase Airtime",
                      color: almostPurple,
                      onTap: (){

                        pushTo(context, AirtimeAndBillsPage());
                      },
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: HomeCard(
                      imagePath: "assets/images/home/account_statement.png",
                      mainText: "Personal\nAccount\nStatement",
                      subText: "Get insight into your financial transactions.",
                      color: almostGreen,
                      onTap: (){
                        pushTo(context, PersonalAccountStatementPage());
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
