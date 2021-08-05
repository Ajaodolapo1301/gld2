import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glade_v2/core/models/apiModels/Business/PaymentLink/paymentLinkhistory.dart';
import 'package:glade_v2/core/models/apiModels/paymentLink/paymentLink.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/Business/paymentLinkState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/reuseables/dialogPopup.dart';
import 'package:glade_v2/utils/functions/bottom_sheet_utils.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:provider/provider.dart';

class PaymentLinkHistoryTab extends StatefulWidget {
  @override
  _PaymentLinkHistoryTabState createState() => _PaymentLinkHistoryTabState();
}

class _PaymentLinkHistoryTabState extends State<PaymentLinkHistoryTab> with AfterLayoutMixin<PaymentLinkHistoryTab> {

  PaymentLinkState paymentLinkState;
  BusinessState businessState;
  LoginState loginState;
bool loading = false;
 List <PaymentLinkItem> paymentLinkHistory = [];
  @override
  Widget build(BuildContext context) {
    paymentLinkState = Provider.of<PaymentLinkState>(context);
    businessState = Provider.of<BusinessState>(context);
    loginState = Provider.of<LoginState>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          SizedBox(height: 10),
        loading ? Center(child: CircularProgressIndicator()) :   Expanded(
            child: Builder(builder: (context) {
              bool isEmpty = false;
              if (paymentLinkHistory.isEmpty) {
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
                      "Create payment links to see history",
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
                itemCount: paymentLinkHistory.length,

                itemBuilder: (context, index) {
                  return linkItem(context, paymentLinkHistory[index]);
                },
              );
            }),
          ),

        ],
      ),
    );
  }


  Widget linkItem(BuildContext context, PaymentLinkItem paymentLinkHistory ) {

    return GestureDetector(
      onTap: () {
        showPaymentLinkOptionsBottomSheet(context,  paymentLinkHistory);
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
                  paymentLinkHistory.createdAt,
                    style: TextStyle(color: blue, fontSize: 10),
                  ),
                  SizedBox(height: 3),
                  Text(
                    paymentLinkHistory.name,
                    style: TextStyle(color: blue),
                  )
                ],
              ),
            ),
            Text(
            paymentLinkHistory.amount != null ? paymentLinkHistory.amount : "0.00",
              style: TextStyle(color: blue, fontWeight: FontWeight.bold),
            ),
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
      loading = true;
    });
    var res = await paymentLinkState.paymentLinkHistory(token: loginState.user.token, business_uuid: businessState.business.business_uuid);

    setState(() {
      loading = false;
    });
    if(res["error"] == false){
      setState(() {
        paymentLinkHistory = res["paymentLinkHistory"];
      });
    }else if(res["error"] == true && res["statusCode"] == 401){
      // showDialog(
      //     barrierDismissible: false,
      //     context: context,
      //     child: dialogPopup(
      //         context: context,
      //         body:"Session ended"
      //     ));
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_)=> dialogPopup(
              context: context,
              body:"Session ended"
          )

      );
    }else{

    }
  }
}
