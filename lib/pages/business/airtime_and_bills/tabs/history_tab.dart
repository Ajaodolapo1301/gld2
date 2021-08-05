import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glade_v2/core/models/apiModels/Auth/Business.dart';
import 'package:glade_v2/core/models/ui/TransferReceiptData.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/airtimeAndBills.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/reuseables/dialogPopup.dart';
import 'package:glade_v2/utils/functions/bottom_sheet_utils.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/myUtils/myUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:provider/provider.dart';

import 'billspaymentDetails.dart';

class AirtimeAndBillsHistoryTab extends StatefulWidget {
  @override
  _AirtimeAndBillsHistoryTabState createState() => _AirtimeAndBillsHistoryTabState();
}

class _AirtimeAndBillsHistoryTabState extends State<AirtimeAndBillsHistoryTab>  with AfterLayoutMixin<AirtimeAndBillsHistoryTab>{
  AirtimeAndBillsState airtimeAndBillsState;
  LoginState loginState;
  BusinessState businessState;
  AppState appState;
  bool isLoading = false;
  Map<String, dynamic > datePicked = {};
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<AirtimeData> billsHistory = [];
  @override
  Widget build(BuildContext context) {
    airtimeAndBillsState = Provider.of<AirtimeAndBillsState>(context);
    loginState = Provider.of<LoginState>(context);
    businessState = Provider.of<BusinessState>(context);
    appState = Provider.of<AppState>(context);
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
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
                  getHistory();
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
            isLoading ? Center(child: CupertinoActivityIndicator(),) :    Expanded(
              child: Builder(builder: (context) {
                bool isEmpty = false;
                if (billsHistory == null ||  billsHistory.isEmpty ) {
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
                    height: 10,
                  ),
                  itemCount: billsHistory.length,
                  itemBuilder: (context, index) {
                    return transactionItem(context, billsHistory[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget transactionItem(BuildContext context, AirtimeData airtimeData) {
    return GestureDetector(
      onTap: () {
        // showSingleTransactionBottomSheet(context, textColor: orange);
        pushTo(context, BillsTransactionDetails(data: airtimeData,));
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
                  MyUtils.formatDate(airtimeData.createdAt),
                    style: TextStyle(color: blue, fontSize: 10),
                  ),
                  SizedBox(height: 3),
                  Container(
                    width: 200,
                    child: Text(
                      airtimeData.bill_name,
                      style: TextStyle(color: blue),
                    ),
                  )
                ],
              ),
            ),
            Text(
              "NGN ${ MyUtils.formatAmount(airtimeData.amount_charged)}" ,
              style: TextStyle(color: blue, fontWeight: FontWeight.bold),
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
    var res = await airtimeAndBillsState.gethistory(isPersonal: appState.isPersonal,  end_date: datePicked["end_date"],  start_date: datePicked["start_date"], business_uuid: businessState?.business?.business_uuid ?? "", token: loginState.user.token);
    setState(() {
      isLoading = false;
    });
        if(res["error"] == false){
          setState(() {
            billsHistory = res["billsHistory"];
          });
        }else if(res["error"] == true && res["statusCode"] == 401) {
          // showDialog(
          //     barrierDismissible: false,
          //     context: context,
          //
          //     child: dialogPopup(
          //         context: context,
          //         body: res["message"]
          //     ));
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_)=> dialogPopup(
                  context: context,
                  body: res["message"]
              )

          );
        }else{
          CommonUtils.showMsg(body: res["message"], scaffoldKey: _scaffoldKey, snackColor: Colors.red);
        }
  }

}
