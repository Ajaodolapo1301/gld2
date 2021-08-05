import 'package:flutter/material.dart';
import 'package:glade_v2/pages/business/account_statement/business_account_statement_page.dart';
import 'package:glade_v2/pages/business/airtime_and_bills/airtime_and_bills_page.dart';
import 'package:glade_v2/pages/business/invoices/invoices_page.dart';
import 'package:glade_v2/pages/business/loans_and_overdraft/loans_and_overdraft_page.dart';
import 'package:glade_v2/pages/business/loans_and_overdraft/tabs/request/request_tab.dart';
import 'package:glade_v2/pages/crypto_currency/crypto_currency_page.dart';
import 'package:glade_v2/pages/personal/add_a_business_account/add_a_business_account/stages/add_compliace.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/home_card.dart';
import 'package:provider/provider.dart';



class BusinessDashboardView extends StatefulWidget {
  final VoidCallback onSwitch;
  final VoidCallback onClickFundTransfer;
  final AnimationController fadeController;

  const BusinessDashboardView({
    Key key,
    this.onSwitch, this.onClickFundTransfer, this.fadeController
  }) : super(key: key);

  @override
  _BusinessDashboardViewState createState() => _BusinessDashboardViewState();
}

class _BusinessDashboardViewState extends State<BusinessDashboardView> with AutomaticKeepAliveClientMixin  {
  LoginState loginState;
  BusinessState businessState;
  @override
  Widget build(BuildContext context) {
    loginState = Provider.of<LoginState>(context);
    businessState = Provider.of<BusinessState>(context);

    super.build(context);
    return Column(
      children: [


     businessState.business.compliance_status == "not-submitted" ?
     GestureDetector(
          onTap: (){
            pushTo(context, AddCompliance());
          },
          child: FadeTransition(
            opacity: widget.fadeController.drive(Tween(begin: 0.5, end: 1.0)),
            child: Container(
              color: Colors.white,
              width: double.maxFinite,
              padding: EdgeInsets.only(bottom: 10, top: 5),
              child: Center(
                child: Text(
                  "Kindly submit compliance to activate your business!",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            ),
          ),
        ) :

     businessState.business.compliance_status == "approved"  ? SizedBox() :    GestureDetector(
       onTap:   businessState.business.compliance_status == "pending"  ||  businessState.business.compliance_status == "approved"   ? null : (){
         pushTo(context, AddCompliance());
       },
       child: FadeTransition(
         opacity: widget.fadeController.drive(Tween(begin: 0.5, end: 1.0)),
         child: Container(
           color: Colors.white,
           width: double.maxFinite,
           padding: EdgeInsets.only(bottom: 10, top: 5),
           child: Center(
             child: Text(
               businessState.business.compliance_status == "pending" ? "Your Compliance Submission is being reviewed" : businessState.business.compliance_status == "rejected" ? "Kindly resubmit valid Compliance document": "",
               style: TextStyle(color: businessState.business.compliance_status == "rejected" ? Colors.red : Colors.deepOrange, fontSize: 12),
             ),
           ),
         ),
       ),
     ) ,

        GestureDetector(
          onTap:   widget.onSwitch,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      "Switch to Personal Account",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: blue),
                    ),

                  ],
                ),
                Spacer(),
                Icon(
                  Icons.all_inclusive_rounded,
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
                      subText: "Send Funds to any Bank Account.",
                      color: almostRed,
                      onTap: widget.onClickFundTransfer,
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: HomeCard(
                      imagePath: "assets/images/home/digital_invoicing.png",
                      mainText: "Digital\nInvoicing",
                      subText: "Send invoice to customers and get paid.",
                      color: almostCyan,
                      onTap: (){
                        pushTo(context, InvoicesPage());
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
                      imagePath: "assets/images/home/loan.png",
                      mainText: "Loan and \nOverdraft",
                      subText: "Access finances to grow your business.",
                      color: almostPurple,
                      onTap: (){
                        pushTo(context, LoansAndOverdraftPage());
                      },
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: HomeCard(
                      imagePath: "assets/images/home/account_statement.png",
                      mainText: "Business\nAccount\nStatement",
                      subText: "Get insight into your financial transactions.",
                      color: almostGreen,
                      onTap: (){
                        pushTo(context, BusinessAccountStatementPage());
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
  //
  @override
  bool get wantKeepAlive => true;
}
