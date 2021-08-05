
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:glade_v2/core/models/apiModels/Personal/POS/pos.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/Personal/posState.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/myUtils/myUtils.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:provider/provider.dart';



class PendingPos extends StatefulWidget {
  @override
  _PendingPosState createState() => _PendingPosState();
}

class _PendingPosState extends State<PendingPos>  with AfterLayoutMixin<PendingPos>{
  POSState posState;
List<PosHistoryModel> posPending = [];

  // List list = [
  //   "1",
  //   "2"
  // ];
  AppState appState;
  LoginState  loginState;
  bool isLoading = false;
  BusinessState businessState;
  @override
  Widget build(BuildContext context) {
    print(isLoading);
    posState = Provider.of<POSState>(context);
    loginState = Provider.of<LoginState>(context);
    appState = Provider.of<AppState>(context);
    businessState = Provider.of<BusinessState>(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [

              SizedBox(height: 10),
              Header(
                text: "Pending POS",
              ),
              SizedBox(height: 10),
              Builder(builder: (context) {
                bool isEmpty = true;
                if (isLoading) {
          return        Center(child: CircularProgressIndicator(backgroundColor: blue,),);
                }
                else if (posPending.isEmpty) {
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
                        "Check back later",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: blue, fontSize: 11),
                      )
                    ],
                  );
                }
                return Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                      height:15,
                    ),
                    itemCount: posPending.length,
                    itemBuilder: (context, index) {
                      return loanItem(context,posPending[index]);
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget loanItem(BuildContext context,  PosHistoryModel posPending) {
    return GestureDetector(
      onTap: () {
        // pushTo(context, LoansApplicationInfoPage(
        //   creditHistory:  creditHistory,
        //
        // ));
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
                     capitalize(posPending.request_type) ,
                    // creditHistory.created_at,
                    style: TextStyle(color: blue, fontSize: 10),
                  ),
                  SizedBox(height: 3),
                  Text(
                    "Quantity: ${posPending.quantity_requested.toString()}",
                    // CommonUtils.capitalize(creditHistory.type),
                    style: TextStyle(color: blue),
                  )
                ],
              ),
            ),
            Text(
                // posPending.status,
              CommonUtils.capitalize(posPending.status,),
              style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    posreq();
  }



  void posreq()async{
    setState(() {
      isLoading = true;
    });
    var result = await posState.posPending(token: loginState.user.token, business_uuid: businessState?.business?.business_uuid, isPersonal: appState.isPersonal);
    setState(() {
      isLoading = false;
    });
    if(result["error"] == false){
      posPending = result["posPending"];
    }else{

    }
  }
}
