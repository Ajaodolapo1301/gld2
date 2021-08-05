import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/VirtualCardModel.dart';
import 'package:glade_v2/pages/states/fund_account_VirtualCard_successful_page.dart';
import 'package:glade_v2/pages/virtual_cards/view_virtual_card/options/see_more__virtual_card_transactions_page.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/Business/virtualCardState.dart';
import 'package:glade_v2/provider/appState.dart';
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

class FundVirtualCardPage extends StatefulWidget {
  final  VirtualCardModel virtualCardModel;
  FundVirtualCardPage({this.virtualCardModel});
  @override
  _FundVirtualCardPageState createState() => _FundVirtualCardPageState();
}

class _FundVirtualCardPageState extends State<FundVirtualCardPage> {
  VirtualCardState virtualCardState;
  LoginState loginState;
  AppState appState;
  BusinessState businessState;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // var amount;
  var currencyType;
  var masked_pan;
  MoneyMaskedTextController amountController = MoneyMaskedTextController(
      decimalSeparator: ".",  thousandSeparator: ",");


  @override
  void initState() {
  currencyType = widget.virtualCardModel.currency;
  masked_pan = widget.virtualCardModel.masked_pan;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    virtualCardState = Provider.of<VirtualCardState>(context);
    loginState = Provider.of<LoginState>(context);

    businessState = Provider.of<BusinessState>(context);
    appState = Provider.of<AppState>(context);
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
                  text: "Fund Card",
                ),
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: CustomTextField(
                  prefix: Text(widget.virtualCardModel.currency ?? "", style: TextStyle(color:blue),),
                  textEditingController: amountController,
                  validator: (value){
                    if(value == "0.00"){
                      return "Amount is required";
                    }
                    // amount = value;
                    return null;
                  },
                  header: "Enter amount to fund",
                ),
              ),
              Spacer(),
              CustomButton(
                text: "Proceed",
                onPressed: () {
                if(_formKey.currentState.validate()){
                  showTransactionPinBottomSheet(
                    context,
                    details: TransactionBottomSheetDetails(
                      buttonText: "Fund Card",
                      middle: Text(
                        "Please confirm you want to you virtual Card $masked_pan with $currencyType ${amountController.text}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: blue,
                        ),
                      ),
                    ),
                    onButtonPressed: (pin) {
                        if(pin.length == 4){
                          verifyPasscode(pin);
                        }


                    },
                  );

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

  fundVcard()async{

    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result = await  virtualCardState.fundCard(card_id: widget.virtualCardModel.card_id, amount: amountController.text.replaceAll(",", "").split(".")[0],token: loginState.user.token, business_uuid: businessState.business.business_uuid, isPersonal: appState.isPersonal );
  Navigator.pop(context);
    if(result["error"] == false){
      pushTo(context, FundAccountVirtualCardSuccessfulPage(
          virtualCardModel : widget.virtualCardModel
      ));

    } else{
      CommonUtils.showMsg(body: result["message"], context: context, scaffoldKey: _scaffoldKey,snackColor : Colors.red );
    }
  }


  verifyPasscode(pin,) async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result = await loginState.verifyPasscode(token: loginState.user.token, passcode: pin);
    Navigator.pop(context);
    if(result["error"] == false){
      fundVcard();
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

}
