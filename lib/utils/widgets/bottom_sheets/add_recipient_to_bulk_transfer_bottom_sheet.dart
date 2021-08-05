import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/bankModel.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/beneficiaryList.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/fetchAccountName.dart';
import 'package:glade_v2/provider/Business/fundTransferState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/reuseables/bankSingleton.dart';
import 'package:glade_v2/utils/functions/bottom_sheet_utils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import '../custom_drop_down.dart';
import '../dropDown.dart';

class AddRecipientToBulkTransferBottomSheet extends StatefulWidget {
  Function(Map<String, dynamic> value)onBulkItem;
  AddRecipientToBulkTransferBottomSheet({this.onBulkItem});
  @override
  _AddRecipientToBulkTransferBottomSheetState createState() => _AddRecipientToBulkTransferBottomSheetState();
}

class _AddRecipientToBulkTransferBottomSheetState extends State<AddRecipientToBulkTransferBottomSheet> with AfterLayoutMixin<AddRecipientToBulkTransferBottomSheet> {




  MoneyMaskedTextController amountController = MoneyMaskedTextController(
      decimalSeparator: ".",  thousandSeparator: ",");
  LoginState loginState;
  var accountNum;
  // var accountName;
bool isBankloading = false;
FundTransferState fundTransferState;
  var amount;
BankModel bankModel;

AccountName account_name;

  var narattion;
  TextEditingController accountname = TextEditingController();
  TextEditingController narration = TextEditingController();
bool isBanksLoading = false;
bool isExternalAccountNameLoading = false;
BanksSingleton banksSingleton = BanksSingleton();
List banks = [];
var bank;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // List<BankModel> allBanks = [
  //   BankModel(
  //       bank_code: "1",
  //       bank_name: "Glade MFB"
  //   ),
  //
  //   BankModel(
  //       bank_code: "2",
  //       bank_name: "GTB"
  //   ),
  //   BankModel(
  //       bank_code: "3",
  //       bank_name: "Zenith"
  //   )
  // ] ;


  @override
  Widget build(BuildContext context) {
    loginState = Provider.of<LoginState>(context);
    fundTransferState = Provider.of<FundTransferState>(context);
    return Container(
      height: MediaQuery.of(context).size.height - 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 30,
      ),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [

                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Container(
                        // margin: EdgeInsets.only(
                        //     left: 20),
                        child: Text(
                          "Select a bank",
                          style: TextStyle(color: blue, fontSize: 12),
                        ),
                      ),
                      SizedBox(height: 4),
                      Container(
                        // margin:
                        // EdgeInsets.symmetric(
                        //     horizontal: 20.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: borderBlue.withOpacity(0.5),
                            ),
                            borderRadius:
                            BorderRadius
                                .circular(8)
                        ),
                        child: DropDownField(
                          isDark: false,
                          parentContext: context,
                          dataSource: banks,
                          value: bank,
                          validator: (value) {
//                                        if (isNull(value)) {
                            if (value
                                .toString()
                                .isEmpty ||
                                value.toString() ==
                                    "0") {
                              return "Please select one option";
                            }

                            if (value
                                .toString()
                                .isEmpty ||
                                value.toString() ==
                                    "0") {
                              return "Please select one option";
                            }
                            return null;
                          },
                          hintText: "Select a Bank",
                          textField: 'name',
                          valueField: 'code',
                          onChanged: (value) {
                            setState(() {
                              bank = value;
                            });
//                                        print(banks.indexWhere(
//                                            (v) => v['code'] == bank));
//                                        print(banks[banks.indexWhere(
//                                            (v) => v['code'] == bank)]);
//                     _accNumNode.requestFocus();
                          },
                        ),
                      ),
                    ],
                  ),
                  // CustomDropDown<BankModel>(
                  //   suffix: isBanksLoading ? CupertinoActivityIndicator() : null,
                  //   intialValue: CustomDropDownItem(value: bankModel, text: "Select banks"),
                  //   items: allBanks.map((e) {
                  //     return CustomDropDownItem<BankModel>(
                  //         value: e,
                  //         text: e.bank_name
                  //     );
                  //   }).toList(),
                  //
                  //   onSelected: (v) {
                  //     bankModel =  v;
                  //   },
                  //   header: "Select Bank",
                  // ),
                  SizedBox(height: 15),
                  CustomTextField(
                      validator: (v){
                        if(v.isEmpty){
                          return "Field is required";
                        }
                        return null;
                      },
                      onChanged: (v){
                        setState(() {
                          accountNum = v;
                          if(v.length == 10){
                         cangetName(accountNum);
                          }

                        });
                      },
                      header: "Enter Account Number"),
                  SizedBox(height: 15),
                  CustomTextField(
                    suffix: isExternalAccountNameLoading ? CupertinoActivityIndicator() : null,
                    readOnly: true,
                    textEditingController: accountname,
                      header: "Account Name",
                    validator: (v){
                      if(v.isEmpty){
                        return "Field is required";
                      }
                      return null;
                    },
                    type: FieldType.text,
                    // textInputFormatters: [
                    //   WhitelistingTextInputFormatter.digitsOnly,
                    //   new LengthLimitingTextInputFormatter(10),
                    // ],
                    hint: "John Doe",
                    // onChanged: (String value){
                    //   setState(() {
                    //     accountName = value;
                    //
                    //
                    //   });
                    //
                    // },


                  ),

                  // GestureDetector(
                  //   onTap: () {
                  //     // showBeneficiaryBottomSheet(context,  []);
                  //   },
                  //   child: Container(
                  //     alignment: Alignment.centerRight,
                  //     padding: EdgeInsets.symmetric(vertical: 5),
                  //     child: Text(
                  //       "Choose Beneficiary",
                  //       style: TextStyle(
                  //           color: cyan,
                  //           fontSize: 12,
                  //           fontWeight: FontWeight.bold),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 10),
                  CustomTextField(
                      textEditingController: amountController,
                      validator: (v){
                        if(v == "0.00"){
                          return "Empty";
                        }

                        return null;
                      },
                      header: "Amount"
                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    textEditingController: narration,
                      header: "Narration"

                  ),
                  SizedBox(height: 15),
                  CustomButton(
                    text: "Add Entry",
                    onPressed: () {
                      if(formKey.currentState.validate() && bank != null ){
                        pop(context);
                        widget.onBulkItem({
                          "bankcode": bank.bank_code,
                          "sender_name" : accountname.text,
                          "bank_name" : bank.bank_name,
                          "accountname" : accountname.text,
                          "amount" : amountController.text.replaceAll(",", "").split(".")[0],
                          "narration": narration.text,
                          "accountnumber" : accountNum
                        });
                      }else{
                        toast("Select a bank ");
                      }
                    },
                    color: cyan,
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  // "amount": "1",
  // "bankcode":"011",
  // "accountnumber":"3078239219",
  // "sender_name": "Peter Temi",
  // "narration": ""

  @override
  void afterFirstLayout(BuildContext context) {
    if (banksSingleton.banks.isEmpty) {
      loadBanks().then((_) {
        setState(() {
          banks = banksSingleton.banks;
        });
      });
    } else {
      setState(() {
        banks = banksSingleton.banks;
      });
    }
  }




  cangetName(String accountNum)async{
    setState(() {
      isExternalAccountNameLoading = true;
    });
      var result = await fundTransferState.FetchAcountNameExternal(accoutNum: accountNum, token: loginState.user.token, mode: "external_local", bankCode: bank.bank_code );
      setState(() {
        isExternalAccountNameLoading = false;

      });
      if(result["error"] == false){
        setState(() {
          account_name = result["accountName"];
          accountname.text = account_name.accountName;

        });

      }else{
        showSimpleNotification(
            Text(result["message"]),
            background: Colors.red);
      }
    }




  Future loadBanks() async {
    var result = await fundTransferState.getBanks(token: loginState.user.token, mode:"external_local" );
    try {
      setState(() {
        if (result["error"] == false) {
          banksSingleton.banks = result["bankList"];
//          banks = result;
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

//  void validateAccountNameExternal()async{
//    setState(() {
//      isExternalAccountNameLoading = true;
//
//    });
////    var result = await fundTransferState.FetchAcountNameExternal(accoutNum: accountNum, token: loginState.user.token, mode: bankTransferMode.mode, bankCode: bankModel.bank_code );
//
//    setState(() {
//      isExternalAccountNameLoading = false;
//
//    });
//    if(result["error"] == false){
//      setState(() {
////        account_name = result["accountName"];
////        accountNameExternal.text = account_name.accountName;
//
//      });
//
//    }else{
////      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:widget.scaffoldKey, snackColor: Colors.red );
//
//    }
//  }


}
