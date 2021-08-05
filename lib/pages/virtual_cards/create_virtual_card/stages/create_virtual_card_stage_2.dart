import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/VirtualcardCurrency.dart';
import 'package:glade_v2/provider/Business/virtualCardState.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_drop_down.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class CreateVirtualCardStage2 extends StatefulWidget {

  final Function(Map<String, dynamic> value) onItemSelected;
  CreateVirtualCardStage2({this.onItemSelected});

  @override
  _CreateVirtualCardStage2State createState() => _CreateVirtualCardStage2State();
}

class _CreateVirtualCardStage2State extends State<CreateVirtualCardStage2>  with AfterLayoutMixin<CreateVirtualCardStage2>{

  MoneyMaskedTextController amountController = MoneyMaskedTextController(
      decimalSeparator: ".",  thousandSeparator: ",");
  VirtualCardState virtualCardState;
  LoginState loginState;
  AppState appState;
 String currencyType;
 String currency;
 String country_code;
VirtualCardCurrency virtualCardCurrency;
  bool isLoading = false;
  // List<VirtualCardCurrency> currency = [
  //   VirtualCardCurrency(
  //       country: "USA",
  //       currency_id: "1",
  //       symbol: "USD"
  //   ),
  // VirtualCardCurrency(
  // country: "EUR",
  // currency_id: "2",
  // symbol: "EUR"
  // ),
  //
  //
  // ];



  @override
  Widget build(BuildContext context) {

    appState = Provider.of<AppState>(context);
    loginState = Provider.of<LoginState>(context);
    virtualCardState = Provider.of<VirtualCardState>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: [
                CustomDropDown<VirtualCardCurrency>(
                              intialValue: CustomDropDownItem(value: virtualCardCurrency ,
                                  text:  isLoading ? "Loading" : "Select "


                              ),
                  suffix: isLoading ?  CupertinoActivityIndicator() : null,

                  items: virtualCardState.currencies.map((e) {
                   return CustomDropDownItem<VirtualCardCurrency>(
                     value: e,
                     text: e.currency_id
                   );

                  }).toList(),
                  onSelected: (value) {
                         print(value);
                  setState(() {
                    currencyType = value?.symbol;
                      currency = value?.currency_id;
                    country_code = value?.country_code;

                  });
                  },
                  header: "Currency",
                ),
                SizedBox(height: 15),
                CustomTextField(
                  validator: (v){
                    if(v.isEmpty){
                      return "Amount is required";
                    }else if(country_code == "NG"){
                      if(double.parse(v.trim()
                          .replaceAll("NGN", "")
                          .replaceAll(",", "")
                          .split(".")[0]) <  1000){
                        return "Invalid Amount. Minimum of 1,000  required";
                      }
                    }else {
                      if(double.parse(v.trim().replaceAll("NGN", "")
                          .replaceAll(",", "")
                          .split(".")[0]) <  10){
                        return "Invalid Amount. Minimum of 10 required";
                      }
                    }
                    return null;
                  },
                  textEditingController: amountController,
                  header: "Amount",

                  onChanged: (String v){
                    setState(() {
                      // appState.amountToFundVCard = v;
                      widget.onItemSelected({
                        "currency" :currency,
                        "country" : country_code,
                        "amount": amountController.text.replaceAll(",", "").split(".")[0]
                      });
                    });

                  },

                  prefix: Text(currencyType ?? "", style: TextStyle(color:blue),),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (virtualCardState?.currencies.isEmpty || virtualCardState?.currencies == null) {
      getAvailableCurrency();
    }
  }

  void getAvailableCurrency() async{
    setState(() {
      isLoading = true;
    });
    var result =await  virtualCardState.getCardCurrencies(token: loginState.user.token);
    setState(() {
      isLoading = false;
    });
        if(result["error"] == false){

        }
  }

}
