import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/VirtualCardModel.dart';
import 'package:glade_v2/core/models/apiModels/Personal/ReserveFund/reserve.dart';
import 'package:glade_v2/pages/dashboard/dashboard_page.dart';
import 'package:glade_v2/pages/personal/reserve_funds/reserve_funds_page.dart';
import 'package:glade_v2/pages/states/fund_account_VirtualCard_successful_page.dart';
import 'package:glade_v2/pages/virtual_cards/view_virtual_card/options/see_more__virtual_card_transactions_page.dart';
import 'package:glade_v2/provider/Business/virtualCardState.dart';
import 'package:glade_v2/provider/Personal/reserveState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/reuseables/dialogPopup.dart';
import 'package:glade_v2/utils/functions/bottom_sheet_utils.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/bottom_sheets/transaction_pin_bottom_sheet.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:provider/provider.dart';

class FundReserve extends StatefulWidget {
    final ReserveDetails reserveDetails;
    FundReserve({this.reserveDetails});
  @override
  _FundReserveState createState() => _FundReserveState();
}

class _FundReserveState extends State<FundReserve> {

  LoginState loginState;
  ReserveState reserveState;

  MoneyMaskedTextController amountController = MoneyMaskedTextController(
      decimalSeparator: ".",  thousandSeparator: ",");
  final FocusNode amountNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var amount;
  @override
  Widget build(BuildContext context) {
    reserveState = Provider.of<ReserveState>(context);
    loginState = Provider.of<LoginState>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                child: Header(
                  text: "Stash Fund",
                ),
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: CustomTextField(
                    focusNode: amountNode,
                  textEditingController:  amountController,
                  validator: (value){
                    if(value == "0.00"){
                      return "Amount is required";
                    }

                    return null;
                  },
                  onSubmit: (value){
                      amountNode.unfocus();
                    if(_formKey.currentState.validate()){


                      fund();

                    }
                  },
                  header: "Enter amount to fund",
                ),
              ),
              Spacer(),
              CustomButton(
                text: "Proceed",
                onPressed: () {
                if(_formKey.currentState.validate()){
//                  showTransactionPinBottomSheet(
//                    context,
//                    details: TransactionBottomSheetDetails(
//                      buttonText: "Fund Card",
//                      middle: Text(
//                        "Please confirm you want to you virtual Card ${widget.virtualCardModel.masked_pan} with  ₦$amount",
//                        textAlign: TextAlign.center,
//                        style: TextStyle(
//                          color: blue,
//                        ),
//                      ),
//                    ),
//                    onButtonPressed: (pin) {
//
//
//
//                    },
//                  );


                fund();

                }
                },
                color: cyan,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  fund()async{
    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result = await  reserveState.fundReserve(token: loginState.user.token, reserve_id: widget.reserveDetails.id, amount: amountController.text.replaceAll(",", "").split(".")[0]  );
    Navigator.pop(context);
    if(result["error"] == false){
      setState(() {
//        CommonUtils.showMsg(body: result["message"] , context: context, scaffoldKey: _scaffoldKey,snackColor : Colors.green );
//        Future.delayed(const Duration(seconds: 2), () {
//        pop(context);
//        pop(context);
//        pop(context);
//          pushReplacementTo(context, (ReserveFundsPage()), PushStyle.cupertino);
//        });
      
      CommonUtils.showAlertDialog(text: result["message"], context: context, onClose: (){
          // pop(context);
          // pop(context);
       // pop(context);
  // Navigator.pus
//        pop(context);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => ReserveFundsPage()), (route) => route.isFirst  );

          pushReplacementTo(context, (ReserveFundsPage()), PushStyle.cupertino);
      });




      });

    } else if(result["error"] == true && result["statusCode"] == 401){
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
      CommonUtils.showMsg(body: result["message"]  ?? 'An Error occurred', context: context, scaffoldKey: _scaffoldKey,snackColor : Colors.red );

    }
  }





}
