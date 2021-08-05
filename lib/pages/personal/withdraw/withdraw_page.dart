import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:glade_v2/pages/states/fund_account_VirtualCard_successful_page.dart';
import 'package:glade_v2/provider/Personal/withdrawalState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/functions/bottom_sheet_utils.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/bottom_sheets/transaction_pin_bottom_sheet.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:provider/provider.dart';
class WithdrawPage extends StatefulWidget {
  @override
  _WithdrawPageState createState() =>
      _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage>  with AfterLayoutMixin<WithdrawPage>{
  MoneyMaskedTextController amountController = MoneyMaskedTextController(
      decimalSeparator: ".", leftSymbol: "NGN ", thousandSeparator: ",");
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  WithdrawalState withdrawalState;
  String remark;
LoginState loginState;
  @override
  Widget build(BuildContext context) {
    withdrawalState = Provider.of<WithdrawalState>(context);
    loginState = Provider.of<LoginState>(context);
    return Scaffold(

      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 10),
              Header(
                text: "Withdraw Funds",
              ),
              SizedBox(height: 10),
              Form(
                key: formKey,
                child: Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      CustomTextField(
                        validator: (v){
                          if(v == "NGN 0.00"){
                            return "Enter amount";
                          }
                          return null;
                        },
                        textEditingController: amountController,
                        header: "Input Amount to withdraw",
                        hint: "Input Amount to withdraw; e.g NGN5,000.00",
                      ),
                      SizedBox(height: 15),
                      CustomTextField(

                        header: "Remark",
                        hint: "Remark",
                        onChanged: (v){
                          setState(() {
                            remark = v;
                          });

                        },
                      ),
                      Spacer(),
                      CustomButton(
                        onPressed: () {
                      if(formKey.currentState.validate()){
                        showTransactionPinBottomSheet(
                            context,
                            details: TransactionBottomSheetDetails(
                              buttonText: "Withdraw",
                              middle: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: "Please confirm you want to withdraw ",
                                  style: TextStyle(color: blue, fontSize: 12),
                                  children: [
                                    TextSpan(
                                      text: "${amountController.text}NGN\n",
                                      style: TextStyle(
                                        color: blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(text: "to your "),
                                    TextSpan(
                                      text: "Business Account",
                                      style: TextStyle(
                                        color: blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            onButtonPressed: (pin){
                             withdraw();
                            }
                        );
                      }
                        },
                        color: cyan,
                        text: "Proceed",
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {

  }

  withdraw()async{
    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result = await withdrawalState.withdraw(token: loginState.user.token, amount: amountController.text.replaceAll("NGN", "").replaceAll(",", "").split(".")[0], remark: remark);
    Navigator.pop(context);

    if(result["error"] == false){
      setState(() {
        pushTo(context, FundAccountVirtualCardSuccessfulPage());
      });
    }else{

      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );
    }
  }
}
