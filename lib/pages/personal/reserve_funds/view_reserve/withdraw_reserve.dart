

import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/VirtualCardModel.dart';
import 'package:glade_v2/core/models/apiModels/Personal/ReserveFund/reserve.dart';
import 'package:glade_v2/pages/personal/reserve_funds/reserve_funds_page.dart';
import 'package:glade_v2/pages/states/fund_account_VirtualCard_successful_page.dart';
import 'package:glade_v2/pages/virtual_cards/view_virtual_card/options/see_more__virtual_card_transactions_page.dart';
import 'package:glade_v2/provider/Business/virtualCardState.dart';
import 'package:glade_v2/provider/Personal/reserveState.dart';
import 'package:glade_v2/provider/loginState.dart';
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

class WithdrwReserve extends StatefulWidget {
  final ReserveDetails reserveDetails;
  WithdrwReserve({this.reserveDetails});
  @override
  _WithdrwReserveState createState() => _WithdrwReserveState();
}

class _WithdrwReserveState extends State<WithdrwReserve> {

  LoginState loginState;
  ReserveState reserveState;

  MoneyMaskedTextController amountController = MoneyMaskedTextController(
      decimalSeparator: ".",  thousandSeparator: ",");
  final FocusNode amountNode = FocusNode();
  final FocusNode remarkNode = FocusNode();
  String remark;
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
                  text: "Fund Reserve",
                ),
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(

                      focusNode: amountNode,
                      textEditingController:  amountController,
                      validator: (value){
                        if(value == "0.00"){
                          return "Amount is required";
                        }

                        return null;
                      },
                      onSubmit: (value){
                        _fieldFocusChange(context, amountNode, remarkNode);

                      },
                      header: "Enter amount to fund",
                    ),


                    SizedBox(height: 15),
                    CustomTextField(
                      focusNode: remarkNode,
                      header: "Remark",
                      hint: "Remark",
                      validator: (v){
                        if(v.isEmpty){
                          return "Field is required";
                        }
                        remark = v;
                        return null;
                      },
                      onSubmit: (v){

                        remarkNode.unfocus();
                        if(_formKey.currentState.validate()){

                          withdraw();

                        }
                      },
                    ),
                  ],
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


                    withdraw();

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


  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  withdraw()async{
    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result = await  reserveState.withdrawReserve(token: loginState.user.token, reserve_id: widget.reserveDetails.id, amount: amountController.text.replaceAll(",", "").split(".")[0], remark: remark );
    Navigator.pop(context);
    if(result["error"] == false){
      setState(() {
//        CommonUtils.showMsg(body: result["message"] , context: context, scaffoldKey: _scaffoldKey,snackColor : Colors.green );
//        Future.delayed(const Duration(seconds: 2), () {
//          pop(context);
//          pop(context);
//          pop(context);
//          pushReplacementTo(context, (ReserveFundsPage()), PushStyle.cupertino);
//        });

        CommonUtils.showAlertDialog(text: result["message"], context: context, onClose: (){
          pop(context);
          pop(context);
          pop(context);
          pushReplacementTo(context, (ReserveFundsPage()), PushStyle.cupertino);
        });

      });

    }else{
      CommonUtils.showMsg(body: result["message"]  ?? 'An Error occurred', context: context, scaffoldKey: _scaffoldKey,snackColor : Colors.red );

    }
  }





}
