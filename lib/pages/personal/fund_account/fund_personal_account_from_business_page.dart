import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:glade_v2/core/models/apiModels/Auth/allBusiness.dart';
import 'package:glade_v2/pages/states/fund_account_VirtualCard_successful_page.dart';
import 'package:glade_v2/pages/states/fund_account_successful_page.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/Personal/fundAccountState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/reuseables/dialogPopup.dart';
import 'package:glade_v2/utils/functions/bottom_sheet_utils.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/bottom_sheets/transaction_pin_bottom_sheet.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_drop_down.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:provider/provider.dart';

class FundPersonalAccountFromBusinessPage extends StatefulWidget {
  @override
  _FundPersonalAccountFromBusinessPageState createState() =>
      _FundPersonalAccountFromBusinessPageState();
}

class _FundPersonalAccountFromBusinessPageState
    extends State<FundPersonalAccountFromBusinessPage> with AfterLayoutMixin<FundPersonalAccountFromBusinessPage> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  MoneyMaskedTextController amountController = MoneyMaskedTextController(
      decimalSeparator: ".",  thousandSeparator: ",");
  List<AllBusiness> listOfBusiness = [];
  BusinessState busnessState;
  TextEditingController remark = TextEditingController();
  bool isLoading = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FundAccountState fundAccountState;
  LoginState loginState;

  AllBusiness allBusiness;
  @override
  Widget build(BuildContext context) {
    busnessState = Provider.of<BusinessState>(context);
fundAccountState = Provider.of<FundAccountState>(context);
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
                text: "Fund from Business Account",
              ),
              SizedBox(height: 10),
              Expanded(
                child: Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      CustomDropDown<AllBusiness>(
               suffix: isLoading ?  CupertinoActivityIndicator() : null,
                        header: "Select business to withdraw from",
                        intialValue: CustomDropDownItem<AllBusiness>(

                            value: allBusiness,
                            text: "Loading..."
                        ),

                        items: listOfBusiness.map((e){
                          return CustomDropDownItem(
                              text: e.business_name,
                              value: e
                          );

                        }).toList(),
                        onSelected: (v) {
                      allBusiness = v;
                        },
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                        prefix: Text("NGN"),
                        validator: (v){
                          if(v == "0.00"){
                            return "Empty";
                          }
                          return null;
                        },
                        textEditingController: amountController,
                        header: "Input Amount to fund",
                      ),
                      SizedBox(height: 15),
                      CustomTextField(

                        hint: "Remark",
                        textEditingController: remark,
                        validator: (v){
                          if(v.isEmpty){
                            return "Empty";
                          }
                          return null;
                        },
                        header: "Remark",
                      ),

                    ],
                  ),
                ),
              ),

              CustomButton(
                onPressed: () {
                  if(formKey.currentState.validate()){
                    showTransactionPinBottomSheet(
                        context,
                        details: TransactionBottomSheetDetails(
                          buttonText: "Fund Account",
                          middle: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "Please confirm you want to fund ",
                              style: TextStyle(color: blue, fontSize: 12),
                              children: [
                                TextSpan(
                                  text:"${ amountController.text} " ,
                                  style: TextStyle(
                                    color: blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(text: "from "),
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
                          verifyPasscode(pin);
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
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
 getBusiness();
  }
  getBusiness()async{
    setState(() {
      isLoading = true;
    });
    var result = await busnessState.getAllBusiness(token: loginState.user.token);
    setState(() {
      isLoading = false;
    });
    if(result["error"] == false){
      setState(() {
        listOfBusiness = result["business"];
      });
    }else{

    }


  }



  verifyPasscode(pin) async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result = await loginState.verifyPasscode(token: loginState.user.token, passcode: pin);
    Navigator.pop(context);
    if(result["error"] == false){
      fromBusinessAccount();
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
      CommonUtils.showMsg(body: result["message"]  ?? 'tt', context: context, scaffoldKey: _scaffoldKey,snackColor : Colors.red );
    }
  }


  void fromBusinessAccount()async{
    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result = await fundAccountState.fundAccountfromBusiness(token: loginState.user.token, amount: amountController.text.replaceAll(",", "").split(".")[0], remark: remark.text, business_uuid: allBusiness.business_uuid, currency: "NG" );
    pop(context);
    if(result["error"] == false){
  pushTo(context, FundAccountSuccessfulPage());
    }else{
      CommonUtils.showMsg(body:result["message"] ?? "Error", context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );

    }
  }

}
