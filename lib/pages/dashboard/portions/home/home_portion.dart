import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:glade_v2/core/constants.dart';
import 'package:glade_v2/pages/authentication/welcome_back_page.dart';
import 'package:glade_v2/pages/dashboard/portions/home/views/business_dashboard_view.dart';
import 'package:glade_v2/pages/dashboard/portions/home/views/personal_dashboard_view.dart';
import 'package:glade_v2/pages/personal/account_statement/personal_account_statement_page.dart';
import 'package:glade_v2/pages/personal/add_a_business_account/select_a_business_account_page.dart';
import 'package:glade_v2/pages/personal/go_live/go_live_personal_page.dart';
import 'package:glade_v2/pages/personal/reserve_funds/reserve_funds_page.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/myUtils/myUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/home_card.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../notifyScreen.dart';

class HomePortion extends StatefulWidget {
  final PageController pageController;
  final VoidCallback onClickFundTransfer;
  final Function(AccountState accountState) getAccount;

  const HomePortion(
      {Key key, this.getAccount, this.pageController, this.onClickFundTransfer})
      : super(key: key);
  @override
  _HomePortionState createState() => _HomePortionState();
}

class _HomePortionState extends State<HomePortion> with  TickerProviderStateMixin, AfterLayoutMixin<HomePortion> {
  AnimationController fadeController;
  bool hasAccount = false;
  Timer _timer;
  LoginState loginState;
AppState appState;
bool showBusinessDetails = false;
BusinessState businessState;
  int notificationCounter = 0;
  // Timer timer;
  PageController pageController = PageController();
  @override
  void initState() {

    super.initState();
    fadeController =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..forward()
          ..repeat(reverse: true);


    Timer(Duration(milliseconds: 1), () {
      widget.getAccount(AccountState.personal);
    });

  }









  @override
  void dispose() {
    fadeController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    loginState = Provider.of<LoginState>(context);
    businessState = Provider.of<BusinessState>(context);
    appState = Provider.of<AppState>(context);

    // super.build(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          SizedBox(height: 20),
          Row(

            children: [
              Container(
                decoration: BoxDecoration(
                  color: cyan.withOpacity(0.35),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: cyan,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(10),
                  child: Text(
                   "${loginState.user.firstname[0]} ${loginState.user.lastname[0]}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                  showBusinessDetails ? businessState?.business.business_name : "${loginState.user.firstname} ${loginState.user.lastname}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: blue,
                      fontSize: 15,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 180,
                    child: Text(
                      showBusinessDetails ? "${businessState?.business?.account_number} ${businessState?.business?.bank_name }" :
                      loginState.user?.accountNum == null ? "Account pending" :

                      "${loginState?.user?.accountNum }-${loginState?.user?.bank_name}",
                      style: TextStyle(
                        color: blue,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
              Spacer(),
              InkWell(
                  onTap: (){
                    // appState.notificationEntered = false;
                    pushTo(context, NotifyScreen());

                  },
                  child: Stack(children: [

                    IconButton(
                      icon: Icon(
                        Icons.notifications_outlined,
                        color: blue,
                      ),
                      onPressed: () {
                        pushTo(context, NotifyScreen());
                      },
                    ),
                    notificationCounter != 0
                        ? Positioned(
                        right: 1,
                        bottom: 9,
                        child: Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle),
                          child: Center(
                            child: Text(
                              "${notificationCounter > 9
                                  ? "9+"
                                  : notificationCounter}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11),
                            ),
                          ),
                        ))
                        : SizedBox(),




                  ])),


            ],
          ),
          SizedBox(height: 20),

          Container(
            width: double.maxFinite,
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: deepCyan,
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 10,
                  left: 4,
                  child: Image.asset(
                    "assets/images/curve.png",
                    width: 120,
                    height: 120,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: lightDeepCyan),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Available Balance",
                        style: TextStyle(color: blue, fontSize: 13),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "₦",
                            style: TextStyle(
                                color: blue,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                fontSize: 26),
                          ),
                          Text(
                        MyUtils.formatAmount( appState.enableHiddenAmount ? "${appState.pseudoBalance}.00" : showBusinessDetails ? businessState.business.available_balance :  loginState.user.availableBalance,),
                            style: TextStyle(
                                color: blue,
                                fontWeight: FontWeight.w800,
                                fontSize: 26),
                          ),
                        ],
                      ),

                      // ledger balance has not been impl, showing available balance for now
                      RichText(
                        text: TextSpan(
                          text: "LEDGER BALANCE: ",
                          style: TextStyle(
                            color: blue,
                            fontFamily: 'DMSans',
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: loginState.user.currency ,
                              style: TextStyle(fontWeight: FontWeight.normal)
                            ),
                            TextSpan(
                              text: MyUtils.formatAmount(showBusinessDetails ? businessState.business.available_balance:  loginState.user.availableBalance,),
                              style: TextStyle(
                                  color: blue, fontWeight: FontWeight.normal),
                            )
                          ],
                        ),
                      ),

                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 5),
          Expanded(
            child: PageView(
              controller: pageController,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              children: [
                PersonalDashboardView(
                  fadeController: fadeController,
                  hasAccount: hasAccount,
                  onClickFundTransfer: widget.onClickFundTransfer,
                  onSwitch: () {
                    if (!hasAccount) {

                      pushTo(context, SelectABusinessAccountPage());
                    } else {
                          setState(() {
                            appState.isPersonal = false;
                            showBusinessDetails = true;
                          });
                      widget.getAccount(AccountState.business);
                      pageController.nextPage(
                        duration: Duration(milliseconds: 700),
                        curve: Curves.easeInOutExpo,
                      );
                    }
                  },
                ),
                BusinessDashboardView(

                  fadeController: fadeController,
                  onClickFundTransfer: widget.onClickFundTransfer,
                  onSwitch: () {
                    setState(() {
                      showBusinessDetails = false;
                      appState.isPersonal = true;
                    });
                    widget.getAccount(AccountState.personal);
                    pageController.previousPage(
                      duration: Duration(milliseconds: 700),
                      curve: Curves.easeInOutExpo,
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void resetIsDark() async {
    var pref = await SharedPreferences.getInstance();

    _timer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      if (mounted) {
        try {
          setState(() {
            notificationCounter = (pref.getStringList("notifications") ?? []).length;
//        print(notificationCounter) ?? 0;
          });
        } catch (e) {
          print(e);
        }
      }
    });
  }

  // @override
  // bool get wantKeepAlive => true;

  @override
  void afterFirstLayout(BuildContext context) async{
    hasAccount = loginState.user.hasBusinessAccount;
    pinging();
  }
  pinging() {

    _timer = Timer.periodic(Duration(minutes: 2), (Timer t) => appState.isPersonal ? CommonUtils.getBalance(loginState) : CommonUtils.getBalanceBusiness(loginState, businessState));
  }

}
