import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/transactionHistory.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/Business/fundTransferState.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/reuseables/dialogPopup.dart';
import 'package:glade_v2/utils/functions/bottom_sheet_utils.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/myUtils/myUtils.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:provider/provider.dart';

class FundTransferHistoryTab extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldKey;

  FundTransferHistoryTab({this.scaffoldKey});

  @override
  _FundTransferHistoryTabState createState() => _FundTransferHistoryTabState();
}

class _FundTransferHistoryTabState extends State<FundTransferHistoryTab> with AfterLayoutMixin<FundTransferHistoryTab> {
  FundTransferState fundTransferState;
  LoginState loginState;
  AppState appState;
  BusinessState businessState;
  bool isTransactionListLoading = false;
  Map<String, dynamic > datePicked = {};
  List<TransferHistory> transferHistory = [] ;
  @override
  Widget build(BuildContext context) {
    fundTransferState = Provider.of<FundTransferState>(context);
    loginState = Provider.of<LoginState>(context);
    appState = Provider.of<AppState>(context);
    businessState = Provider.of<BusinessState>(context);
    return isTransactionListLoading ? Center(child: CupertinoActivityIndicator()) : Container(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: Column(
        children: [
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              showSelectRangeBottomSheet(context: context, onDateSelected: (v){
                print(v);
                setState(() {
                  datePicked = v;
                });
                fetchTransactionList();
              } );
            },
            child: Container(
              padding: EdgeInsets.only(top: 5, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    color: orange,
                    size: 15,
                  ),
                  SizedBox(width: 5),
                  Text(
                    "Select Range",
                    style: TextStyle(
                      color: blue,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Builder(builder: (context) {
              bool isEmpty = false;
              if (fundTransferState.transferHistory.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 5),
                    Text(
                      "No history yet.",
                      style: TextStyle(
                          color: blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
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
                itemCount: transferHistory.length,
                itemBuilder: (context, index) {
                  return transactionItem(context, transferHistory[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget transactionItem(BuildContext contex,  TransferHistory transferHistory) {
    return GestureDetector(
      onTap: () {
        showSingleFundTransfer(context, textColor: orange, transferHistory: transferHistory);
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
                    MyUtils.formatDate(transferHistory.created_at),
                    style: TextStyle(color: blue, fontSize: 10),
                  ),
                  SizedBox(height: 3),
                  Text(
                    transferHistory.txn_ref,
                    style: TextStyle(color: blue),
                  )
                ],
              ),
            ),
            Text(
              "-${"NGN"}${MyUtils.formatAmount(transferHistory.value)}",
              style: TextStyle(color: blue, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    fetchTransactionList();
  }


  void fetchTransactionList() async{
    print("fetching countries");
    setState(() {

      isTransactionListLoading = true;

    });
    var result = await fundTransferState.getTransactionList(token: loginState.user.token, isPersonal: appState.isPersonal, start_date: datePicked["start_date"], end_date: datePicked["end_date"], business_uuid: businessState?.business?.business_uuid  ?? "", );

    setState(() {
      isTransactionListLoading = false;

    });
    if(result["error"] == false){
      setState(() {

    transferHistory = result["transferHistoryList"];
      });

    }else if (result["error"] == true && result["statusCode"] == 401){
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
