import 'package:after_layout/after_layout.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:glade_v2/core/models/apiModels/Business/LoanAndOverdraft/loanTypes.dart';
import 'package:glade_v2/provider/Business/loanAndOverdraftState.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/widgets/custom_drop_down.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class RequestLoanStage1 extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldKey;
  final Function(Map<String, dynamic> value)onLoanPayload;
  RequestLoanStage1({this.scaffoldKey, this.onLoanPayload});
  @override
  _RequestLoanStage1State createState() => _RequestLoanStage1State();
}

class _RequestLoanStage1State extends State<RequestLoanStage1>  with AfterLayoutMixin<RequestLoanStage1>{
  LoginState  loginState;
  bool isLoading = false;
LoanAndOverdraftState loanAndOverdraftState;
CreditTypes loanTypes;
AppState appState;
 MoneyMaskedTextController amountController = MoneyMaskedTextController(
     decimalSeparator: ".",  thousandSeparator: ",");

String loanType;
var reasons;
String amount;
CreditTypes creditTypes ;
  @override
  Widget build(BuildContext context) {
    loanAndOverdraftState = Provider.of<LoanAndOverdraftState>(context);
    loginState = Provider.of<LoginState>(context);
    appState = Provider.of<AppState>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                CustomDropDown<CreditTypes>(

                              intialValue: CustomDropDownItem(value: creditTypes , text: "Loading.."),
                      suffix: isLoading ? CupertinoActivityIndicator(): null ,
                  items: loanAndOverdraftState.loanTypesList.map((e) {
                    return  CustomDropDownItem(
                        value: e,
                        text: e.credit_type_name
                    );
                  }).toList(),

//                  items: [
//                    CustomDropDownItem(value: "For School", text: "For School"),
//                    CustomDropDownItem(value: "For House", text: "For House"),
//                  ],
                  onSelected: (value) {
                  creditTypes = value;

                  },
                  header: "Select type of Loan",
                ),
                SizedBox(height: 15),
                CustomTextField(
                  textEditingController: amountController,
                  type: FieldType.number,
                  textInputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  validator: (value){
                    if(value == "0.00"){
                      return "Field is required";
                    }
                      amount = value;

                    return null;
                  },
                  header: "Loan Amount",
                  hint: "Enter Loan Amount eg; NGN 5,000.00",
                ),
                SizedBox(height: 15),
                CustomTextField(
                  validator: (value){
                    if(value.isEmpty){
                      return "Field is required";
                    }
                 reasons = value;
                    widget.onLoanPayload({
                      "reason" : reasons,
                      "amount" : amount.replaceAll(",", "").trim().split(".")[0],
                      "type" : creditTypes.credit_type_id
                    });
                    return null;
                  },
                  header: "Reason for Loan",
                  hint: "Reason for Loan",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
  if(loanAndOverdraftState?.loanTypesList == null || loanAndOverdraftState.loanTypesList?.isEmpty){
    getLoanType();

  }
  }


  getLoanType()async{
  setState(() {
    isLoading = true;
  });

  var result = await loanAndOverdraftState.creditTypes(token: loginState.user.token);
  setState(() {
    isLoading = false;
  });

    if(result["error"] == false){

    }else{
        pop(context);
      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:widget.scaffoldKey, snackColor: Colors.red );

    }
  }
}
