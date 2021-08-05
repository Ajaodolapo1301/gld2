

import 'package:flutter/material.dart';
import 'package:glade_v2/api/AccountStatement/accountStatement.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/myUtils/myUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/header.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AccountStatementDetails extends StatefulWidget {
  final Statement statement;
  // final bool isDark;

  AccountStatementDetails({
    @required this.statement,
    // this.isDark,
  });

  @override
  _AccountStatementDetailsState createState() =>
      _AccountStatementDetailsState();
}

class _AccountStatementDetailsState extends State<AccountStatementDetails> {
  // Dimens dimens;
  var headerStyle;
  var detailStyle;

  @override
  void initState() {
    initTextScale();
    setState(() {
      // isDark = widget.isDark;
    });
    headerStyle = TextStyle(
        fontSize: 16, color: blue);
    detailStyle = TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: blue);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isDark = true;

  void initTextScale() async {
    var pref = await SharedPreferences.getInstance();
    setState(() {
      textScale = pref.getDouble("textScaleFactor") ?? 1.0;
    });
  }

  double textScale = 1.0;

  @override
  Widget build(BuildContext context) {
    // dimens = Dimens(context);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: textScale),
      child: new Scaffold(
          // backgroundColor: isDark ? Colors.black : buttonColor,
          body: SafeArea(bottom: false,
            child: Container(
              color:  Colors.white,
              child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.zero,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                    Header(
                      preferredActionOnBackPressed: (){
                        pop(context);

                      },
                      text:"Account Statement Details" ,
                    ),

                    // Divider(color: Colors.white),
                    // SizedBox(height: 10),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        children: <Widget>[
                          SizedBox(
                            height: 15,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Transaction ID",
                                    style: headerStyle,
                                  ),
                                  Expanded(
                                    child: Text(
                                      widget.statement.txn_ref,
                                      textAlign: TextAlign.end,
                                      style: detailStyle,
                                    ),
                                  )
                                ],
                              ),
                              Divider()
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Amount",
                                    style: headerStyle,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "NGN" +
                                          " " +
                                   MyUtils.formatAmount(widget.statement.value),
                                      textAlign: TextAlign.end,
                                      style: detailStyle,
                                    ),
                                  )
                                ],
                              ),
                              Divider()
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Type",
                                    style: headerStyle,
                                  ),
                                  CommonUtils.displayStatus(
                                      status: widget.statement.txn_type,
                                      createdAt: widget.statement.txn_date),
                                ],
                              ),
                              Divider()
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Remarks",
                                    style: headerStyle,
                                  ),
                                  Expanded(
                                    child: Text(
                                      widget.statement.narration ?? "",
                                      style: detailStyle,
                                      maxLines: 3,
                                      textAlign: TextAlign.end,
                                    ),
                                  )
                                ],
                              ),
                              Divider()
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Date",
                                    style: headerStyle,
                                  ),
                                  Expanded(
                                    child: Text(
                                   MyUtils.formatDate(widget.statement.createdAt),
                                      style: detailStyle,
                                      textAlign: TextAlign.end,
                                    ),
                                  )
                                ],
                              ),
                              Divider()
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
class StatementReceiptData {
  final String accountName;
  final String openingBalance;
  final String accountNumber;
  final String requestedPeriod;
  final String dateCreated;
  final List statementItem;
  final String closingBalance;

  StatementReceiptData(
      {this.accountName,
        this.openingBalance,
        this.accountNumber,
        this.requestedPeriod,
        this.dateCreated,
        this.statementItem,
        this.closingBalance});
}
