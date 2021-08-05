
import 'package:flutter/material.dart';
import 'package:glade_v2/core/models/ui/TransferReceiptData.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/myUtils/myUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/styles/receipt.dart';
import 'package:glade_v2/utils/widgets/button.dart';
import 'package:glade_v2/utils/widgets/header.dart';

import 'package:shared_preferences/shared_preferences.dart';

class BillsTransactionDetails extends StatefulWidget {
  final AirtimeData data;

  BillsTransactionDetails({
    @required this.data,
  });

  @override
  _BillsTransactionDetailsState createState() =>
      _BillsTransactionDetailsState();
}

class _BillsTransactionDetailsState extends State<BillsTransactionDetails> {
  // Dimens dimens;

  var headerStyle = TextStyle(fontSize: 16, color: blue);
  var detailStyle = TextStyle(fontWeight: FontWeight.bold, color: blue, fontSize: 16);
  final scaffoldKey = GlobalKey<ScaffoldState>();

  ReceiptScreen receiptScreen;

  @override
  void initState() {
    super.initState();
    initTextScale();
    initDark();
    receiptScreen = ReceiptScreen(billsData: widget.data);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initTextScale() async {
    var pref = await SharedPreferences.getInstance();
    setState(() {
      textScale = pref.getDouble("textScaleFactor") ?? 1.0;
    });
  }

  double textScale = 1.0;

  void initDark() async {
    var pref = await SharedPreferences.getInstance();
    setState(() {
      isDark = pref.getBool("isDark") ?? false;
      headerStyle = TextStyle(
          fontSize: 16, color: blue);
      detailStyle = TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: blue);
    });
  }

  bool isDark = true;

  @override
  Widget build(BuildContext context) {
    // dimens = Dimens(context);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: textScale),
      child: new Scaffold(
          key: scaffoldKey,
          backgroundColor:  Colors.white,
          body: SafeArea(bottom: false,
            child: Container(
              color:  Colors.white,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  Header(
                    preferredActionOnBackPressed: (){
                      pop(context);

                    },
                    text: "Details",
                  ),
                  // SizedBox(height: 20),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Transaction ID",
                                  style: headerStyle,
                                ),

                                Expanded(child: Text(widget.data.txnRef,  textAlign: TextAlign.end, style: detailStyle))
                              ],
                            ),
                            // Divider(
                            //   // color: borderBlue,
                            // )
                          ],
                        ),
                        // Column(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: <Widget>[
                        //     Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: <Widget>[
                        //         Text(
                        //           "Order ID",
                        //           style: headerStyle,
                        //         ),
                        //         Container(
                        //             width: dimens.width * 0.6,
                        //             child: Text(
                        //               widget.data.orderRef,
                        //               style: detailStyle,
                        //               textAlign: TextAlign.right,
                        //               maxLines: 2,
                        //             ))
                        //       ],
                        //     ),
                        //     Divider(color: Colors.grey)
                        //   ],
                        // ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            widget.data.category == null ? SizedBox() :            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Category",
                                  style: headerStyle,
                                ),
                                Text(
                                  widget.data.category ?? "",
                                  style: detailStyle,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Name",
                                  style: headerStyle,
                                ),
                                Text(
                                  widget.data.bill_name ?? "" ,
                                  style: detailStyle,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Amount",
                                  style: headerStyle,
                                ),
                                Text(
                                  "NGN" +
                                      " " +
                                  MyUtils.formatAmount(
                                          widget.data.amount_charged.toString()),
                                  style: detailStyle,
                                )
                              ],
                            ),
                            Divider()
                          ],
                        ),
                        widget.data.unit != null ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Units",
                                  style: headerStyle,
                                ),
                                Text(
                                 "${ widget.data.unit} unit",
                                  style: detailStyle,
                                )
                              ],
                            ),
                            Divider()
                          ],
                        ): SizedBox(),
                        widget.data.token != null ?Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Electricity Token",
                                  style: headerStyle,
                                ),
                                SizedBox(width: 15,),
                                Expanded(
                                  child: Text(
                                    widget.data.token,
                                    textAlign: TextAlign.end,
                                    style: detailStyle,
                                  ),
                                )
                              ],
                            ),
                            Divider()
                          ],
                        ): SizedBox(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Status",
                                  style: headerStyle,
                                ),
                          CommonUtils.displayStatus(
                                    status: widget.data.status,
                                    createdAt: widget.data.createdAt),
                              ],
                            ),
                            Divider()
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Remarks",
                                  style: headerStyle,
                                ),
                                Text(
                                  widget.data.note ?? "",
                                  style: detailStyle,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Date",
                                  style: headerStyle,
                                ),
                                Text(
                              MyUtils.formatDate(widget.data.createdAt),
                                  style: detailStyle,
                                )
                              ],
                            ),
                            Divider(),
                            SizedBox(height: 20),
                            widget.data.status == "successful"
                                ? Container(
                              child: Button(
                                onPressed: () {
                                  showDialog(
                                      context: this.context,
                                      builder: (BuildContext context) {
                                        return Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            height: MediaQuery.of(context).size.height * 0.5,
                                            width: MediaQuery.of(context).size.width,
                                            child: AlertDialog(
                                              title: Text(
                                                "Select Option",
                                                textAlign: TextAlign.center,
                                              ),
                                              content: Container(
                                                height: 50,
                                                child: Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    // FlatButton(
                                                    //     onPressed: () async {
                                                    //       // receiptScreen
                                                    //       //     .downloadBillsPdf()
                                                    //           .then((b) {
                                                    //         if (b) {
                                                    //           Navigator.pop(
                                                    //               context);
                                                    //           scaffoldKey
                                                    //               .currentState
                                                    //               .showSnackBar(
                                                    //               SnackBar(
                                                    //                 content: Text(
                                                    //                     "Receipt Downloaded. Check your Download folder"),
                                                    //                 backgroundColor:
                                                    //                 Colors.green,
                                                    //                 duration: Duration(
                                                    //                     milliseconds:
                                                    //                     2500),
                                                    //               ));
                                                    //         }
                                                    //       });
                                                    //     },
                                                    //     child: Column(
                                                    //       children: <Widget>[
                                                    //         Icon(Icons
                                                    //             .file_download),
                                                    //         Text("Download")
                                                    //       ],
                                                    //     )),
                                                    FlatButton(
                                                        onPressed: () {
                                                          receiptScreen.printPdf();
                                                        },
                                                        child: Column(
                                                          children: <Widget>[
                                                            Icon(Icons.print),
                                                            Text("Print")
                                                          ],
                                                        )),
                                                    FlatButton(
                                                        onPressed: () {
                                                          receiptScreen.sharePdf();
                                                        },
                                                        child: Column(
                                                          children: <Widget>[
                                                            Icon(Icons.share),
                                                            Text("Share")
                                                          ],
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                },
                                text: "Receipt",
                              ),
                            )
                                : SizedBox()
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
