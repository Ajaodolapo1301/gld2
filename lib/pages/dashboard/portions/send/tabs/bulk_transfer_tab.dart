import 'package:flutter/material.dart';
import 'package:glade_v2/pages/states/fund_transfer_successful_page.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/Business/fundTransferState.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/reuseables/dialogPopup.dart';
import 'package:glade_v2/utils/functions/bottom_sheet_utils.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/body_modal_not_live.dart';
import 'package:glade_v2/utils/widgets/bottom_sheets/transaction_pin_bottom_sheet.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:provider/provider.dart';

class BulkTransferTab extends StatefulWidget {
  @override
  _BulkTransferState createState() => _BulkTransferState();
}

class _BulkTransferState extends State<BulkTransferTab> {

  List <Map<String, dynamic>> playList = [];

  FundTransferState fundTransferState;
  LoginState loginState;
  AppState appState;
  BusinessState businessState;
  var total;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  gettingTotalPrice(){
    return total  = playList.map<int>((m) => int.parse(m["amount"].toString())).reduce((a,b )=>a+b);
  }
  @override
  Widget build(BuildContext context) {

    fundTransferState = Provider.of<FundTransferState>(context);
    loginState = Provider.of<LoginState>(context);
    appState = Provider.of<AppState>(context);
    businessState = Provider.of<BusinessState>(context);
    return Scaffold(
        key: scaffoldKey ,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Column(
          children: [
            SizedBox(height: 10),
            Expanded(
              child: Builder(builder: (context) {
                bool isEmpty = true;
                if (playList.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 5),
                      Text(
                        "No Listing found",
                        style: TextStyle(
                            color: blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      Text(
                        "Click add recipient below to initiate a \nbulk transfer",
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
                  itemCount: playList.length,
                  itemBuilder: (context, index) {
                    gettingTotalPrice();

                    if (index == 9) {
                      return SizedBox(height: 30);
                    }
                    return recipientItem(context, playList[index]);
                  },
                );
              }),
            ),
            if(playList.isEmpty)CustomButton(
              text: "Add Recipient",
              color: cyan,
              onPressed: () {
                showAddRecipientToBulkTransferBottomSheet(context: context, onBulkItem: (v){
                  print(v);
                  setState(() {
                    playList.add(v);
                  });
                });
              },
            ),
            if (playList.isNotEmpty)
        Column(
                children: [
                  CustomButton(
                    text: "Proceed",
                    onPressed: onProceed,
                  ),
                  SizedBox(height: 10),
                  CustomButton(
                    text: "Add More Recipient",
                    type: ButtonType.outlined,
                    onPressed: () {
                      showAddRecipientToBulkTransferBottomSheet(context: context, onBulkItem: (v){
                          setState(() {
                            playList.add(v);
                          });
                      });
                    },
                  ),
                ],
              ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget recipientItem(BuildContext context,  Map<String, dynamic> bulkItem) {
    return Stack(


      children: [
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          decoration: BoxDecoration(
            color: lightBlue,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: borderBlue.withOpacity(0.1),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bulkItem["accountname"],
                      style: TextStyle(
                          color: blue, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Text(
                      "${bulkItem["bank_name"]} - ${bulkItem["accountnumber"]}",
                      style: TextStyle(color: blue, fontSize: 13),
                    )
                  ],
                ),
              ),


              Text(
                "NGN${bulkItem["amount"]}",
                style: TextStyle(color: blue, fontSize: 13, fontWeight: FontWeight.bold),
              ),

            ],
          ),
        ),
        Positioned(
          right: 0.0,
          top: -2.0,
          child: GestureDetector(
            onTap: (){
              setState(() {
                playList.removeWhere((element) => element == bulkItem);

              });
            },
            child: Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                radius: 14.0,
                backgroundColor: Colors.white,
                child: Icon(Icons.close, color: orange),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void onProceed() {
    if(loginState.user.compliance_status == "approved"){
      showTransactionPinBottomSheet(
        context,
        minuValue: 100,
        details: TransactionBottomSheetDetails(
          buttonText: "Transfer",
          middle: Column(
            children: [
              Text(
                "Please confirm the transaction details are correct. Note \nthat submitted payments cannot be recalled.",
                textAlign: TextAlign.center,
                style: TextStyle(color: blue, fontSize: 12),
              ),
              SizedBox(height: 20),
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 25),
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: borderBlue.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Money",
                            style: TextStyle(
                                color: blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          ),
                          // Text(
                          //   "Zenith Bank - 211706821",
                          //   style: TextStyle(color: blue, fontSize: 13),
                          // )
                        ],
                      ),
                    ),
                    Text(
                      "NGN $total",
                      style: TextStyle(color: blue, fontSize: 13),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                "SEE MORE RECIPIENTS",
                style: TextStyle(
                    color: cyan, fontWeight: FontWeight.bold, fontSize: 10),
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
        onButtonPressed: (pin) {

          verifyPasscode(pin);
        },
      );
    }else{
      CommonUtils.modalBottomSheetMenu(context: context,  body: buildModal(text: "Oh, Merchant not enabled for transaction!", subText: "dbfhbdf"));
    }
  }


  verifyPasscode(pin, ) async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result = await loginState.verifyPasscode(token: loginState.user.token, passcode: pin);
    Navigator.pop(context);
    if(result["error"] == false){
      bulkTransfer();
    }else if(result["error"] == true && result["statusCode"] == 401 ){
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

      CommonUtils.showMsg(body: result["message"]  ?? 'tt', context: context, scaffoldKey: scaffoldKey,snackColor : Colors.red );
    }
  }


  void bulkTransfer()async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result = await fundTransferState.bulkTransferExternal(bulkItem: playList, token: loginState.user.token);
      print(result);
    Navigator.pop(context);
    if(result["error"] == false){
      playList.clear();
      pushTo(context, FundTransferSuccessfulPage(isbulk: true, status: "successful",));
      }else{
        CommonUtils.showMsg(body: result["message"]  ?? 'tt', context: context, scaffoldKey: scaffoldKey,snackColor : Colors.red );
      }

  }


}
