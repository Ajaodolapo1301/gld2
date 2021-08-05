import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glade_v2/core/constants.dart';
import 'package:glade_v2/core/models/ui/feature_from_more_details.dart';
import 'package:glade_v2/pages/business/airtime_and_bills/airtime_and_bills_page.dart';

import 'package:glade_v2/pages/business/fund_account/fund_account_page.dart';
import 'package:glade_v2/pages/business/invoices/invoices_page.dart';
import 'package:glade_v2/pages/business/loans_and_overdraft/loans_and_overdraft_page.dart';
import 'package:glade_v2/pages/business/payment_link/payment_link_page.dart';
import 'package:glade_v2/pages/business/pos/pos_page.dart';

import 'package:glade_v2/pages/personal/budgeting/budgeting_page.dart';
import 'package:glade_v2/pages/personal/fund_account/fund_personal_account_page.dart';

import 'package:glade_v2/pages/settings/chatWithUs.dart';
import 'package:glade_v2/pages/settings/settings_page.dart';
import 'package:glade_v2/pages/switch_account_page.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/myUtils/myUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/account_details_view.dart';
import 'package:glade_v2/utils/widgets/body_modal_not_live.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MorePortion extends StatefulWidget {
  final AccountState accountState;

  const MorePortion({Key key, @required this.accountState}) : super(key: key);

  @override
  _MorePortionState createState() => _MorePortionState();
}

class _MorePortionState extends State<MorePortion>
    with AutomaticKeepAliveClientMixin {


  LoginState loginState;
  BusinessState businessState;
AppState appState;
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
    businessState = Provider.of<BusinessState>(context);
    appState = Provider.of<AppState>(context);
    super.build(context);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: textScale),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              "More Features",
              style: TextStyle(
                  color: blue, fontWeight: FontWeight.bold, fontSize: 15),
            ),
            SizedBox(height: 20),
            AccountDetailsView(

              onTap: () {
                // pushTo(context, FundAccountPage());
              },
              loginState: loginState,
              businessState: businessState ,
              accountState: widget.accountState ,
            ),
            SizedBox(height: 20),
            Expanded(
              child: Theme(
                data: Theme.of(context).copyWith(highlightColor: Colors.pink),
                child: ListView.separated(
                  separatorBuilder: (_, __) => Container(
                    margin: EdgeInsets.only(left: 70),
                    child: Divider(),
                  ),
                  itemBuilder: (context, index) {
                    if (index == list.length) {
                      return SizedBox(height: 10);
                    }
                    return GestureDetector(
                      onTap: () {
                        if (list[index] != null) {
                          list[index].onTap(context);
                        }
                      },
                      child: ListTile(
                        leading: SvgPicture.asset(list[index].imagePath, ),
                        title: Text(
                          list[index].mainText,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: blue,
                              fontSize: 14),
                        ),
                        subtitle: Text(
                          list[index].subText,
                          style: TextStyle(color: blue, fontSize: 12),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                      ),
                    );
                  },
                  itemCount: list.length + 1,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<FeatureFromMoreDetails> get list =>
      widget.accountState == AccountState.business
          ? getBusinesss()
          : getPersona();

  @override
  bool get wantKeepAlive => true;




  List<FeatureFromMoreDetails> getBusinesss(){
    return    [
      FeatureFromMoreDetails(
          imagePath: "assets/images/more/fund account.svg",
          mainText: "Fund Account",
          subText: "Fund your Account by paying into",
          onTap: (context) {
            pushTo(context, FundAccountPage(

            ));
          }),
      FeatureFromMoreDetails(
          imagePath: "assets/images/more/invoices.svg",
          mainText: "Invoices",
          subText: "Send Invoices to Customers and get Paid",
          onTap: (context) {
            pushTo(context, InvoicesPage());
          }),
      FeatureFromMoreDetails(
        imagePath: "assets/images/more/business.svg",
        mainText: "Request POS",
        subText: "Access Point of Sale with Ease.",
        onTap: (context) {
          pushTo(context, POSPage());
        },
      ),
      FeatureFromMoreDetails(
        imagePath: "assets/images/more/invoices.svg",
        mainText: "Payment Link",
        subText: "Sell Items and Tickets with Ease",
        onTap: (context) {
          pushTo(context, PaymentLinkPage());
        },
      ),
      FeatureFromMoreDetails(
        imagePath: "assets/images/more/airtimeandbills.svg",
        mainText: "Airtime and Bills",
        subText: "Buy Airtime and Pay bills",
        onTap: (context) {
          pushTo(context, AirtimeAndBillsPage());
        },
      ),
      // FeatureFromMoreDetails(
      //   imagePath: "assets/images/more/virtual cards.svg",
      //   mainText: "Virtual Cards",
      //   onTap: (context){
      //     pushTo(context, ());
      //   },
      //   subText: "Create Virtual Cards",
      // ),
      FeatureFromMoreDetails(
          imagePath: "assets/images/more/loans and overdraft.svg",
          mainText: "Loan & Overdraft",
          subText: "Get access to financial support",
          onTap: (context) {
            pushTo(context, LoansAndOverdraftPage());
          }),
      FeatureFromMoreDetails(
        imagePath: "assets/images/more/switch.svg",
        mainText: "Switch Account",
        subText: "Switch to Another Business Account",
        onTap: (context) {
          print("Tapping");
          pushTo(context, SwitchAccountPage());
        },
      ),
      FeatureFromMoreDetails(
        imagePath: "assets/images/more/chat.svg",
        mainText: "Chat With Us",
        subText: "Get 247 support with our Customer Care",
          onTap: (context){
            pushTo(context, LiveChatWebView());

          }
      ),
      FeatureFromMoreDetails(
        imagePath: "assets/images/more/settings.svg",
        mainText: "Settings",
        subText: "Access to Security, Dark mode...",
        onTap: (context) {
          pushTo(context, SettingsPage());
        },
      ),
      FeatureFromMoreDetails(
          imagePath: "assets/images/more/logout.svg",
          mainText: "LogOut",
          onTap: (context){
            MyUtils.showAlertDialog(context, appState);
          },
          subText: "Sign out Properly"),
    ];

  }

 List<FeatureFromMoreDetails>  getPersona(){
    return    [
      FeatureFromMoreDetails(
        imagePath: "assets/images/more/fund account.svg",
        mainText: "Fund Personal Account",
        subText: "Fund your Account by paying into ",
        onTap: (context) {
          pushTo(
            context,
            FundPersonalAccountPage(


            ),
          );
        },
      ),
      FeatureFromMoreDetails(
        imagePath: "assets/images/more/budget.svg",
        mainText: "Set a Budget",
        subText: "Send Invoices to Customers and get Paid",
        onTap: (context) {

          if(loginState.user.compliance_status  == "approved"){
            pushTo(
              context,
              BudgetingPage(),
            );
          }else{
            CommonUtils.modalBottomSheetMenu(context: context,  body: buildModal(text: "Oh, Merchant not enabled for transaction!", subText: "dbfhbdf", status: loginState.user.compliance_status));
          }

        },
      ),
      FeatureFromMoreDetails(
        imagePath: "assets/images/more/business.svg",
        mainText: "Request POS",
        subText: "Access Point of Sale with Ease.",
        onTap: (context) {
          if(loginState.user.compliance_status  == "approved"){
            pushTo(context, POSPage());
          }else{
            CommonUtils.modalBottomSheetMenu(context: context,  body: buildModal(text: "Oh, Merchant not enabled for transaction!", subText: "dbfhbdf", status: loginState.user.compliance_status));
          }

        },
      ),
      // FeatureFromMoreDetails(
      //   imagePath: "assets/images/more/withdraw_funds.svg",
      //   mainText: "Withdraw Funds",
      //   subText: "Withdraw funds to business account",
      //   onTap: (context) {
      //     pushTo(context, WithdrawPage());
      //   },
      // ),
      //   FeatureFromMoreDetails(
      //   imagePath: "assets/images/more/btc.svg",
      //   mainText: "Crypto currency",
      //   subText: "Buy, Sell, Hold & Trade Digital Currencies.",
      //   onTap: (context) {
      //     pushTo(context, CryptoCurrencyPage());
      //   },
      // ),
      // FeatureFromMoreDetails(
      //     imagePath: "assets/images/more/virtual cards.svg",
      //     mainText: "Virtual Cards",
      //     subText: "Create Virtual Cards"),
      FeatureFromMoreDetails(
          imagePath: "assets/images/more/switch.svg",
          mainText: "Switch Account",
          subText: "Switch to Another Business Account",
          onTap: (context) {
            print("Tapping");
            pushTo(context, SwitchAccountPage());
          }
      ),
      FeatureFromMoreDetails(
          imagePath: "assets/images/more/chat.svg",
          mainText: "Chat With Us",
          subText: "Get 247 support with our Customer Care",
          onTap: (context){
            pushTo(context, LiveChatWebView());

          }
      ),
      FeatureFromMoreDetails(
        imagePath: "assets/images/more/settings.svg",
        mainText: "Settings",
        subText: "Access to Security, Dark mode...",
        onTap: (context) {
          pushTo(context, SettingsPage());
        },
      ),
      FeatureFromMoreDetails(
          imagePath: "assets/images/more/logout.svg",
          mainText: "LogOut",

          onTap: (context){
            MyUtils.showAlertDialog(context, appState);
          },
          subText: "Sign out Properly"),

    ];

  }
}
