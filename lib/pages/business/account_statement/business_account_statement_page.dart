import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boom_menu/flutter_boom_menu.dart';
import 'package:glade_v2/api/AccountStatement/accountStatement.dart';
import 'package:glade_v2/main.dart';
import 'package:glade_v2/provider/Business/accountStatement.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/reuseables/dialogPopup.dart';
import 'package:glade_v2/utils/functions/bottom_sheet_utils.dart';
import 'package:glade_v2/utils/functions/statementReceipt.dart';
import 'package:glade_v2/utils/myUtils/myUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/account_details_view.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:provider/provider.dart' ;

import 'accountStatementDetails.dart';
class BusinessAccountStatementPage extends StatefulWidget {
  @override
  _BusinessAccountStatementPageState createState() =>
      _BusinessAccountStatementPageState();
}

class _BusinessAccountStatementPageState extends State<BusinessAccountStatementPage> with AfterLayoutMixin<BusinessAccountStatementPage> {
  AccountStatementState accountStatementState;
  LoginState loginState;
  BusinessState businessState;
  AppState appState;
  StatementDetails statementDetails;
  bool isLoading = false;
  List<Statement> myBusinessStatement = [];
  Map<String, dynamic > datePicked = {};
  @override
  Widget build(BuildContext context) {
    accountStatementState = Provider.of(context);
    businessState = Provider.of<BusinessState>(context);
    loginState = Provider.of<LoginState>(context);
    appState = Provider.of<AppState>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 10),
              Header(
                text: "Statement",
              ),
              GestureDetector(
                onTap: (){
                  showSelectRangeBottomSheet(context: context, onDateSelected: (v){
                    setState(() {
                      datePicked = v;
                    });
            print(v);
                    print(datePicked);
                    getStatement();
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(top: 10, bottom: 20),
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
                            color: blue, fontSize: 13, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
        isLoading ?  Center(child: CircularProgressIndicator(),) :       Expanded(
                child: Builder(builder: (context) {
                  bool isEmpty = false;
                  if (myBusinessStatement.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 5),
                        Text(
                          "No transactions yet.",
                          style: TextStyle(
                              color: blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                        Text(
                          "Make transactions to see statements",
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
                    itemCount: myBusinessStatement.length,
                    itemBuilder: (context, index) {
                      return statementItem(context, myBusinessStatement[index]);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Builder(
          builder: (context) {
            return BoomMenu(
              backgroundColor:  orange,
              animatedIcon: AnimatedIcons.menu_close,
              animatedIconTheme: IconThemeData(size: 22.0),
              overlayColor: Colors.black,
              overlayOpacity: 0.7,
              children: [
                MenuItem(
                    title: "Download",
                    subtitle: "Download statement as pdf",
                    backgroundColor: blue,
                    titleColor: Colors.white,
                    subTitleColor: Colors.white,
                    child: Icon(Icons.file_download, color: Colors.white,),
                    onTap: (){
                      downloadStatement(context);
                    }
                ),
                MenuItem(
                    title: "Print",
                    subtitle: "Print statement directly from your phone",
                    backgroundColor:  blue,
                    titleColor: Colors.white,
                    subTitleColor: Colors.white,
                    child: Icon(Icons.print, color: Colors.white,),
                    onTap: (){
                      printStatement();
                    }
                ),
                MenuItem(
                    title: "Share",
                    subtitle: "Share statement pdf to others",
                    backgroundColor:  blue,
                    titleColor: Colors.white,
                    subTitleColor: Colors.white,
                    child: Icon(Icons.share, color: Colors.white,),
                    onTap: (){
                      shareStatement();
                    }
                ),
              ],
            );
          }
      ),
    );
  }

  Widget statementItem(BuildContext context, Statement statement) {
    return GestureDetector(
      onTap: () {
        pushTo(context, AccountStatementDetails(statement: statement,));
        // showSingleTransactionBottomSheet(context, statement: statement);
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
        MyUtils.formatDate(statement.createdAt),
                    style: TextStyle(color: blue, fontSize: 10),
                  ),
                  SizedBox(height: 3),
                  Text(
                    statement.txn_ref,
                    style: TextStyle(color: blue),
                  )
                ],
              ),
            ),
            Text(
                statement.txn_type == "debit"  ?   " - NGN${statement.value}" :  "NGN${statement.value}",
              style: TextStyle(color: statement.txn_type == "debit" ? orange : barGreen, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    getStatement();
  }

  Future selectDate({@required BuildContext context}) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2018),
      lastDate: DateTime.now().add(Duration(hours: 1)),
      initialDate: DateTime.now(),
      selectableDayPredicate: (DateTime d) {
        if (d.isBefore(DateTime.now().add(Duration(hours: 12)))) {
          return true;
        }
        return false;
      },
    );
    if (picked != null) {
      return picked;
    }
    return null;
  }



  void downloadStatement(BuildContext context) async {
    // while (currentPage < lastPage) {
    //   if (_startDate != null) {
    //     await load(
    //         clear: true,
    //         startDate: _startDate,
    //         endDate: _endDate,
    //         showLoading: true);
    //   } else {
    //     await load(showLoading: true);
    //   }
    // }
    await StatementReceiptScreen(
      statementReceiptData: StatementReceiptData(
          accountName:  statementDetails.account_name,
          openingBalance: statementDetails.opening_balance,
          closingBalance: statementDetails.closing_balance,
          accountNumber: statementDetails.account_number,
          dateCreated:MyUtils.formatDate(DateTime.now().toString()),
          requestedPeriod: "${datePicked["start_date"] == null || datePicked["end_date"] == null ?MyUtils.formatDate(DateTime.now().toString()) : MyUtils.formatDate(datePicked["start_date"]) + "-" + MyUtils.formatDate(datePicked["end_date"])}",
          statementItem: myBusinessStatement),
    ).downloadReceipt();
    Scaffold.of(context)
        .showSnackBar(SnackBar(
      content: Text(
          "Receipt Downloaded. Check your Download folder"),
      backgroundColor: Colors.green,
      duration:
      Duration(milliseconds: 2500),
    ));
  }

  void printStatement() async {
    // while (currentPage < lastPage) {
    //   if (_startDate != null) {
    //     await load(
    //         clear: true,
    //         startDate: _startDate,
    //         endDate: _endDate,
    //         showLoading: true);
    //   } else {
    //     await load(showLoading: true);
    //   }
    // }
    StatementReceiptScreen(
      statementReceiptData: StatementReceiptData(
          accountName:  statementDetails.account_name,
          openingBalance: statementDetails.opening_balance,
          closingBalance: statementDetails.closing_balance,
          accountNumber: statementDetails.account_number,
          dateCreated:MyUtils.formatDate(DateTime.now().toString()),
          requestedPeriod: "${datePicked["start_date"] == null || datePicked["end_date"] == null ?MyUtils.formatDate(DateTime.now().toString()) : MyUtils.formatDate(datePicked["start_date"]) + "-" + MyUtils.formatDate(datePicked["end_date"])}",
          statementItem: myBusinessStatement),
    ).printPdf();
  }

  void shareStatement() async {
    // while (currentPage < lastPage) {
    //   if (_startDate != null) {
    //     await load(
    //         clear: true,
    //         startDate: _startDate,
    //         endDate: _endDate,
    //         showLoading: true);
    //   } else {
    //     await load(showLoading: true);
    //   }
    // }
    StatementReceiptScreen(
      statementReceiptData: StatementReceiptData(
          accountName:  statementDetails.account_name,
          openingBalance: statementDetails.opening_balance,
          closingBalance: statementDetails.closing_balance,
          accountNumber: statementDetails.account_number,
          dateCreated:MyUtils.formatDate(DateTime.now().toString()),
          requestedPeriod: "${datePicked["start_date"] == null || datePicked["end_date"] == null ?MyUtils.formatDate(DateTime.now().toString()) : MyUtils.formatDate(datePicked["start_date"]) + "-" + MyUtils.formatDate(datePicked["end_date"])}",
          statementItem: myBusinessStatement),
    ).sharePdf();
  }


  void getStatement() async{
    print("calling");
    setState(() {
      isLoading = true;
    });
    var result = await accountStatementState.getAccountStatement(token: loginState.user.token, isPersonal: appState.isPersonal, business_uuid: businessState.business.business_uuid, from_date: datePicked["start_date"], to_date: datePicked["end_date"]);
    setState(() {
      isLoading = false;
    });
    if(result["error"] == false){
      setState(() {
        myBusinessStatement = result["statement"];
        statementDetails = result["details"];
      });

    }else if(result["error"] == true && result["statusCode"] == 401 ){
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_)=> dialogPopup(
              context: context,
              body: result["message"]
          )

      );
    }else{

    }
  }
}
