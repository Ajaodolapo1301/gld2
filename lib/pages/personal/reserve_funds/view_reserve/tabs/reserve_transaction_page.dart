import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:glade_v2/provider/Personal/reserveState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';

class ReserveTransactionsTab extends StatefulWidget {
  @override
  _ReserveTransactionsTabState createState() => _ReserveTransactionsTabState();
}

class _ReserveTransactionsTabState extends State<ReserveTransactionsTab>  with AfterLayoutMixin<ReserveTransactionsTab>{

  ReserveState reserveState;
  LoginState loginState;
  @override
  Widget build(BuildContext context) {
    return
    //   isLoading ? Center(child: CircularProgressIndicator()) : Container(
    //   margin: EdgeInsets.only(top: 20),
    //   child: Builder(builder: (context) {
    //     bool isEmpty = true;
    //
    //     if (credithistoryList.isEmpty) {
    //       return Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           SizedBox(height: 5),
    //           Text(
    //             "No history yet.",
    //             style: TextStyle(
    //                 color: blue, fontWeight: FontWeight.bold, fontSize: 17),
    //           ),
    //           Text(
    //             "Make transactions to see history",
    //             textAlign: TextAlign.center,
    //             style: TextStyle(color: blue, fontSize: 11),
    //           )
    //         ],
    //       );
    //     }
    //     return ListView.separated(
    //       separatorBuilder: (context, index) => SizedBox(
    //         height: 20,
    //       ),
    //       itemCount: loanAndOverdraftState.loanHistory.length,
    //       itemBuilder: (context, index) {
    //         return loanItem(context, loanAndOverdraftState.loanHistory[index]);
    //       },
    //     );
    //   }),
    // );



      Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "No transaction on\nthis stash yet.",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: blue, fontSize: 17, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "Transaction for this stash will show\nhere. Please check back",
            textAlign: TextAlign.center,
            style: TextStyle(color: blue, fontSize: 12),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // TODO: implement afterFirstLayout
  }

  // void reserveTransaction() async{
  //   var result = reserveState.
  // }
}
