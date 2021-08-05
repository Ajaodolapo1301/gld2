import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:glade_v2/core/models/apiModels/Business/LoanAndOverdraft/loanHistory.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/reuseables/dialogPopup.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/myUtils/myUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/core/models/apiModels/Business/LoanAndOverdraft/loanTypes.dart';
import 'package:glade_v2/provider/Business/loanAndOverdraftState.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:provider/provider.dart';
import '../loan_application_info_page.dart';

class LoansAndOverdraftHistoryTab extends StatefulWidget {

  GlobalKey<ScaffoldState> scaffoldKey;
  GlobalKey<FormState> formkey;

  LoansAndOverdraftHistoryTab({this.scaffoldKey, this.formkey});
  @override
  _LoansAndOverdraftHistoryTabState createState() =>
      _LoansAndOverdraftHistoryTabState();
}

class _LoansAndOverdraftHistoryTabState extends State<LoansAndOverdraftHistoryTab> with AfterLayoutMixin<LoansAndOverdraftHistoryTab> {
  LoanAndOverdraftState loanAndOverdraftState;
  CreditTypes loanTypes;
  AppState appState;
  LoginState  loginState;
  bool isLoading = false;
  List<CreditHistory> credithistoryList = [];
  @override
  Widget build(BuildContext context) {
    loanAndOverdraftState = Provider.of<LoanAndOverdraftState>(context);
    loginState = Provider.of<LoginState>(context);
    appState = Provider.of<AppState>(context);
    return isLoading ? Center(child: CircularProgressIndicator()) : Container(
      margin: EdgeInsets.only(top: 20),
      child: Builder(builder: (context) {
        bool isEmpty = true;

        if (credithistoryList.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 5),
              Text(
                "No history yet.",
                style: TextStyle(
                    color: blue, fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Text(
                "Make transactions to see history",
                textAlign: TextAlign.center,
                style: TextStyle(color: blue, fontSize: 11),
              )
            ],
          );
        }
        return ListView.separated(
          separatorBuilder: (context, index) => SizedBox(
            height: 20,
          ),
          itemCount: loanAndOverdraftState.loanHistory.length,
          itemBuilder: (context, index) {
            return loanItem(context, loanAndOverdraftState.loanHistory[index]);
          },
        );
      }),
    );
  }

  Widget loanItem(BuildContext context, CreditHistory creditHistory) {
    return GestureDetector(
      onTap: () {
        pushTo(context, LoansApplicationInfoPage(
          creditHistory:  creditHistory,
          
        ));
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: lightBlue,
          border: Border.all(
            color: borderBlue.withOpacity(0.05),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    MyUtils.formatDate(creditHistory.created_at),
                    style: TextStyle(color: blue, fontSize: 10),
                  ),
                  SizedBox(height: 3),
                  Text(
                      CommonUtils.capitalize(creditHistory.type),
                    style: TextStyle(color:blue
                    ),
                  )
                ],
              ),
            ),
            Text(
              CommonUtils.capitalize(creditHistory.status),
              style: TextStyle(color:   creditHistory.status == "pending" || creditHistory.status == "pause" ||   creditHistory.status == "awaiting-user-response" || creditHistory.status == "under-review"   ?  Colors.yellow[900] :
              creditHistory.status == "approved" || creditHistory.status == "active" ? Colors.green
                  : creditHistory.status == "cancelled" || creditHistory.status == "rejected" || creditHistory.status == "closed" ?Colors.red : Colors.black12
                  ,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
   getHistory();
  }
  getHistory()async{
    setState(() {
      isLoading = true;
    });

    var result = await loanAndOverdraftState.getLoanHistory(token: loginState.user.token, business_uuid: loginState.user.business_uuid);
    setState(() {
      isLoading = false;
    });

    if(result["error"] == false){
    setState(() {
      credithistoryList = result["creditHistory"];
    });
    }else if(result["error"] == true && result["statusCode"] == 401){

      // showDialog(
      //     barrierDismissible: false,
      //     context: context,
      //     child: dialogPopup(
      //         context: context,
      //         body: result["message"]
      //     ));
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_)=> dialogPopup(
              context: context,
              body: result["message"]
          )

      );
    }
    else{

      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:widget.scaffoldKey, snackColor: Colors.red );

    }
  }

}
