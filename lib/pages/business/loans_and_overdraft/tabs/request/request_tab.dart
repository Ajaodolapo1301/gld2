import 'package:flutter/material.dart';
import 'package:glade_v2/pages/business/loans_and_overdraft/tabs/request/stages/request_loan_stage_1.dart';
import 'package:glade_v2/pages/business/loans_and_overdraft/tabs/request/stages/request_loan_stage_2.dart';
import 'package:glade_v2/pages/dashboard/dashboard_page.dart';
import 'package:glade_v2/provider/Business/loanAndOverdraftState.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:provider/provider.dart';

class LoanAndOverdraftRequestTab extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldKey;
  GlobalKey<FormState> formkey;

  LoanAndOverdraftRequestTab({this.scaffoldKey, this.formkey});
  @override
  _LoanAndOverdraftRequestTabState createState() => _LoanAndOverdraftRequestTabState();
}

class _LoanAndOverdraftRequestTabState extends State<LoanAndOverdraftRequestTab> {

  int currentPage = 0;
  Map<String, dynamic> loanPayload = {};
  Map<String, dynamic> GuaPayload = {};
  PageController controller = PageController();
  LoanAndOverdraftState loanAndOverdraftState;
  LoginState loginState;
AppState appState;
  @override
  Widget build(BuildContext context) {
    loanAndOverdraftState = Provider.of<LoanAndOverdraftState>(context);
    loginState = Provider.of<LoginState>(context);
    appState = Provider.of<AppState>(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: widget.formkey,
                child: PageView(
                  controller: controller,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    RequestLoanStage1(scaffoldKey: widget.scaffoldKey, onLoanPayload: (v){
                      setState(() {
                        loanPayload = v;
                      });
                    },),
                    RequestLoanStage2(scaffoldKey: widget.scaffoldKey, onGuarantorPayload: (v){
                      setState(() {
                        GuaPayload = v;
                      });
                    },),
                  ],
                ),
              ),
            ),
            CustomButton(
              text: currentPage == 0 ? "Next" : "Request Loan",
              onPressed: () {
                if(currentPage == 0){

                  if(widget.formkey.currentState.validate()){
                    setState(() {
                      currentPage++;
                    });
                    controller.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeOutExpo,
                    );
                  }
                }else if(currentPage == 1){
                  if(widget.formkey.currentState.validate()){
                    applyForLoan();
                  }

                }
              },
              color: cyan,
            ),
            SizedBox(height: 20),
          ],
        ),
      )
    );
  }

  void applyForLoan() async{

      showDialog(
          context: this.context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Preloader();
          });
      var result = await  loanAndOverdraftState.applyLoan(token: loginState.user.token, guarantor_address:GuaPayload["address"] , guarantor_email: GuaPayload["guaEmail"], guarantor_name: GuaPayload["guaName"], guarantor_phone: GuaPayload["guaPhone"],
        amount: loanPayload["amount"], reason: loanPayload["reason"], type_id: loanPayload["type"], business_uuid: loginState.user.business_uuid ) ;
      Navigator.pop(context);
      if(result["error"] == false){

        CommonUtils.showAlertDialog(context: context, text: result["message"], onClose: () async{
            pushToAndClearStack(context, DashboardPage());
        });

      }else{

        CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:widget.scaffoldKey, snackColor: Colors.red );

      }
    }
  }

