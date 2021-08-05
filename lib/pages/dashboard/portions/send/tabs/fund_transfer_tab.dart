import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/BankTransferMode.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/bankModel.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/beneficiaryList.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/countriesModel.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/fetchAccountName.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/internationalFundModel.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/transactionHistory.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/transferMethod.dart';
import 'package:glade_v2/core/models/apiModels/Receipt/receipts.dart';
import 'package:glade_v2/core/models/ui/TransferReceiptData.dart';
import 'package:glade_v2/pages/states/fund_transfer_failed_page.dart';
import 'package:glade_v2/pages/states/fund_transfer_successful_page.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/Business/fundTransferState.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/reuseables/bankSingleton.dart';
import 'package:glade_v2/reuseables/dialogPopup.dart';
import 'package:glade_v2/utils/functions/bottom_sheet_utils.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/body_modal_not_live.dart';
import 'package:glade_v2/utils/widgets/bottom_sheets/transaction_pin_bottom_sheet.dart';
import 'package:glade_v2/utils/widgets/customDrop.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_drop_down.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/dropDown.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class FundTransferTab extends StatefulWidget {

  @override
  _FundTransferTabState createState() => _FundTransferTabState();
}

class _FundTransferTabState extends State<FundTransferTab> with AfterLayoutMixin<FundTransferTab> {
  BankTransferMode bankTransferMode;
  FundTransferState fundTransferState;
  LoginState loginState;
  TransferReceiptData transferReceiptData;
  MoneyMaskedTextController amountController = MoneyMaskedTextController(
      decimalSeparator: ".", leftSymbol: "NGN ", thousandSeparator: ",");
  MoneyMaskedTextController amountControllerInternational = MoneyMaskedTextController(
      decimalSeparator: ".",  thousandSeparator: ",");

  // account name
  TextEditingController accountName = TextEditingController();
  TextEditingController  accountNameExternal = TextEditingController();
  TextEditingController  accountNameInternational = TextEditingController();
  //account num
  TextEditingController accountNum = TextEditingController();
  TextEditingController  accountNumExternal = TextEditingController();
  TextEditingController  accountNumInternational = TextEditingController();

  TextEditingController  narration = TextEditingController();
  bool save_beneficiary = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<BeneficiaryList> beneficiaryList = [];
  BeneficiaryList singleBeneficiary;

List<MobileMoney> mobileMoneyList = [];
MobileMoney mobileMoney;
  List<BankIntlBranchList> bankIntlBranchList = [];
  BankIntlBranchList branchList;
  String accountNumber;
  String accountNumberExternal;
  String accountNumberInternational;

  AccountName account_name;
  bool isGladeAccountNameLoading = false;
  bool isExternalAccountNameLoading = false;
  bool isForeignAccountNameLoading = false;
  bool isBanksLoading = false;
  bool isCountriesLoading = false;
  bool isTransferMethodLoading = false;
  bool isBeneficiaryListLoading = false;
  bool isAccountNameAndAccountEditable = false;
  bool isLoadingMode = false;
  bool  isintlBankLoading = false;
  bool       isintlBranchLoading = false;
  bool   isfeeLoading = false;
  BankModel bankModel;
TransferFee transferFee;
var fee = 10;
AppState appState;
TransferHistory transferHistory;
BusinessState businessState;
bool validateButton = true;
var bank;
List banks = [];
CountriesModel countriesModel;
TransferMethod transferMethod;
List<TransferMethod> transferMethodList = [];
  Timer _debounce;
  List<BankIntlList> bankIntlList = [];
  BankIntlList bankIntl;

  BanksSingleton banksSingleton = BanksSingleton();

  _onSearchChanged(String query) {
    print(query);
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if(query.isNotEmpty){
        fetchTransferFee(query);
      }
    });
  }


  int chartIndex = 0;

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    fundTransferState = Provider.of<FundTransferState>(context);
    loginState = Provider.of<LoginState>(context);
    appState = Provider.of<AppState>(context);
    businessState = Provider.of<BusinessState>(context);
 return Scaffold(
      key: scaffoldKey,
      body:  Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Column(
                children: [
                  CustomDropDown<BankTransferMode>(
//                suffix: CupertinoActivityIndicator(),
                    header: "Select Transfer Mode",
                    intialValue: CustomDropDownItem<BankTransferMode>(

                        value: bankTransferMode,
                        text: "Loading..."
                    ),

                 items: fundTransferState.bankTransferMode.map((e){
                   return CustomDropDownItem(
                     text: e.mode,
                     value: e
                   );

               }).toList(),
                    onSelected: (v) {
                        if(v?.id == "external_local"){
                         // if(fundTransferState.bankList?.isEmpty || fundTransferState.bankList == null){
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
                         }else  if(v?.id == "external_foreign"){
                            if(fundTransferState.countriesList?.isEmpty || fundTransferState.countriesList == null){
                              fetchCountries();
                            }
                        }
                        // }
                      setState(() {
                        bankTransferMode = v;
                        if(v != null){
                          fetchbeneficiaryList(bankTransferMode);
                        }

                        bankIntl = null;
                          branchList = null;
                        // bankIntlBranchList.clear();
                        transferMethod = null;
                        // remove bank from textfield
                        bank = null;
                        transferFee = null;
                        amountControllerInternational.text = "0.00";
                        amountController.text = "0.00";
                        accountNameExternal.clear();
                        accountNumExternal.clear();
                      });
                    },
                  ),

                  SizedBox(height: 15),

              bankTransferMode == null ||   bankTransferMode?.id == "internal" ? Column(

                    children: [
                      CustomTextField(
                          onTap: (){
                            setState(() {
                              // isAccountNameAndAccountEditable  = false;
                              // accountNum.clear();
                              // accountName.clear();
                            });
                          },
                          validator: (value){
                            if(value.isEmpty){
                              return "Field is required";
                            }
                            return null;
                          },
                        readOnly: isAccountNameAndAccountEditable,
                        textEditingController: accountNum ,
                          type: FieldType.number,
                          textInputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                            new LengthLimitingTextInputFormatter(10),
                          ],
                          hint: "",
                          onChanged: (String value){
                            setState(() {
                              accountNumber = value;
                              if(value.length == 10){
                                cangetName(accountNumber);
                              }else{
                                accountName.clear();
                              }

                            });

                          },
                          header: "Enter Account Number"


                      ),
                      SizedBox(height: 15),


                      CustomTextField(
                        validator: (value){
                          if(value.isEmpty){
                            return "Field is required";
                          }
                          return null;
                        },
                        suffix: isGladeAccountNameLoading ? CupertinoActivityIndicator() : null,
                        header: "Account Name",
                        readOnly: true,
                        textEditingController: accountName,
                      ),
                    ],
                  ) : Container(),
                  (  bankTransferMode?.id == "external_local") ||  ( bankTransferMode?.id == "external_foreign" ) ? getOtherFields(context) :Container(),

                  //beneficiaries

               bankTransferMode?.id ==  "external_foreign"  ? SizedBox() : GestureDetector(
                    onTap: () {
                      showBeneficiaryBottomSheet(context: context, beneficiaryList: beneficiaryList, onBeneficiarySelect: (v){
                        if(v != null){
                          setState(() {

                            singleBeneficiary = v;

                            if(bankTransferMode.id == "internal"){
                              isAccountNameAndAccountEditable = true;
                              accountName.text = singleBeneficiary.account_name;
                              accountNum.text = singleBeneficiary.account_number;
                            }else if(bankTransferMode.id == "external_local"){
                              print(singleBeneficiary.bank_code);
                              bank = banks[banks.indexWhere((b) =>
                              "${b.bank_code}" == "${singleBeneficiary.bank_code}")];
                              isAccountNameAndAccountEditable = true;
                              accountNameExternal.text = singleBeneficiary.account_name;
                              accountNumExternal.text = singleBeneficiary.account_number;
                            }else{
                              // isAccountNameAndAccountEditable = true;
                              // accountNameInternational.text = singleBeneficiary.account_name;
                              // accountNumInternational.text = singleBeneficiary.account_number;
                            }

                          });
                        }

                      }  );
                    },
                    child: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        "Choose Beneficiary",
                        style: TextStyle(
                            color: isBeneficiaryListLoading ? cyan.withOpacity(0.5):  cyan, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),
                  ( bankTransferMode!= null && bankTransferMode.id == "internal") ||  (bankTransferMode!= null && bankTransferMode.id == "external_local" )  ?
                  CustomTextField(
                      textEditingController: amountController,
                      onChanged: (v){
                        // setState(() {
                        //   buttonEnabled();
                        // });
                      },
                      validator: (value){
                        if(value == "NGN 0.00"){
                          return "Amount is required";
                        }
                        return null;
                      },
                      header: "Amount") :
//                  international field

                  CustomTextField(
                      prefix: Text(countriesModel?.currency ?? "", style: TextStyle(color: blue),),
                      textEditingController: amountControllerInternational,
                      onChanged: (v){
                        setState(() {
                          print("print$v");
                          transferFee = null;
                            if(v != "0"){
                              _onSearchChanged(amountControllerInternational.text.replaceAll(",", "").split(".")[0]);
                              // fetchTransferFee(amountControllerInternational.text.replaceAll(",", "").split(".")[0]);
                            }
                        });

                      },
                      validator: (value){
                        if(value == "0.00"){
                          return "Amount is required";
                        }
                        return null;
                      },
                      header: "Amount"),
                SizedBox(height: 10,),
                transferFee != null ?    Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(7)
                    ),
                  padding: EdgeInsets.all(15),

                  width: double.infinity,
                  // margin: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Rate:", style: TextStyle(fontSize: 12, color: blue),),
                            SizedBox(height: 5,),
                              Text("Fee:", style: TextStyle(fontSize: 12, color: blue),),
                              SizedBox(height: 5,),
                              Text("Amount deductable:", style: TextStyle(fontSize: 12,color: blue ),),

                            ],
                          ),

                      SizedBox(width: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text("${transferFee?.fromCurrency}  ${transferFee?.rate.toStringAsFixed(2)}", style: TextStyle(fontSize: 12, color: orange),),
                          SizedBox(height: 5,),
                          Text("${transferFee?.fromCurrency} ${transferFee.fee.toString() ?? ""}", style: TextStyle(fontSize: 12, color: orange),),
                          SizedBox(height: 5,),
                          Text(" ${transferFee?.fromCurrency} ${(transferFee?.fromAmount + transferFee.fee).toStringAsFixed(2)}", style: TextStyle(fontSize: 12, color: orange),),
                        ],
                      ),
                    ],
                  ),
                ) : isfeeLoading ? CupertinoActivityIndicator(): SizedBox(),
                  SizedBox(height: 15),
                  CustomTextField(
                    header: "Narration",
                    textEditingController: narration,


                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Save as Beneficiary",
                          style: TextStyle(color: blue),
                        ),
                      ),
                      Transform(
                        transform: Matrix4.identity()
                          ..scale(0.5)
                          ..translate(20.0, 20.0),
                        child: CupertinoSwitch(
                          value: save_beneficiary,
                          activeColor: cyan,
                          onChanged: (value) {
                            setState(() {
                              save_beneficiary = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                ],
              ),
              // if(loginState.user.compliance_status == "approved"){
              CustomButton(
                text: "Proceed",
                color: cyan,
                onPressed: () {
                  if(formKey.currentState.validate()){
                        if(loginState.user.compliance_status == "approved"){
                          showTransactionPinBottomSheet(
                            context,
                            minuValue: 30,
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
                                    padding:
                                    EdgeInsets.symmetric(vertical: 14, horizontal: 25),
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
                                                bankTransferMode.id == "internal"  ? accountName.text : bankTransferMode.id == "external_local" ? accountNameExternal.text : accountNameInternational.text,
                                                style: TextStyle(
                                                    color: blue,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13),
                                              ),
                                              Text(
                                                bankTransferMode.id == "internal"  ? "Glade - ${accountNum.text}" :

                                                bankTransferMode.id == "external_local" ? " ${bank.bank_name} - ${accountNameExternal.text}" :  "${bankIntl.name} - ${accountNameInternational.text}",

                                                style: TextStyle(color: blue, fontSize: 13),
                                              )
                                            ],
                                          ),
                                        ),
                                        Text(
                                          bankTransferMode.id == "external_foreign" ? amountControllerInternational.text :  amountController.text,
                                          style: TextStyle(
                                              color: blue,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                            onButtonPressed: (pin) {
                                verifyPasscode(pin, bankTransferMode);
                              // pushTo(context, FundTransferFailedPage());
                            },
                          );
                        }else{
                          CommonUtils.modalBottomSheetMenu(context: context,  body: buildModal(text: "Oh, Merchant not enabled for transaction!", subText: "dbfhbdf",  status: loginState.user.compliance_status));
                        }
                  }
                  // print(buttonEnabled());

                }
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }






 bool buttonEnabled(){
    if(bankTransferMode?.id == "internal" ){
        print(accountName.text);
        print(amountController.text);
      if(accountName.text != null  ||  amountController.text != "NGN 0.00"){
        setState(() {
          return validateButton = true;
        });
      }else{
        setState(() {
          return validateButton = false;
        });
      }
    }
  }



//  other fields
  Widget getOtherFields(BuildContext context) {

    if (bankTransferMode.id == "external_local") {

      return Column(
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
                    if (value.toString() .isEmpty || value.toString() == "0") {
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
          SizedBox(height: 10),
          Column(

            children: [
              CustomTextField(
                  validator: (value){
                    if(value.isEmpty){
                      return "Field is required";
                    }
                    return null;
                  },
                    onTap: (){
                    setState(() {
                    isAccountNameAndAccountEditable  = false;
                    // accountNumExternal.clear();
                    // bank = null;
                    // accountNameExternal.clear();
                    });
                    },
                textEditingController: accountNumExternal,
                  type: FieldType.number,
                  textInputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    new LengthLimitingTextInputFormatter(10),
                  ],
                  hint: "",
                  onChanged: (String value){
                    setState(() {

                      accountNumberExternal = value;
                      if(value.length == 10 && bank?.bank_code != null){
                        cangetName(accountNumberExternal);
                      }else if(value.length == 10  && bank == null){
                        toast("Select a bank");
                      }else{
                        accountNameExternal.clear();

                      }

                    });

                  },
                  header: "Enter Account Number"


              ),
              SizedBox(height: 15),
              CustomTextField(
                validator: (value){
                  if(value.isEmpty){
                    return "Field is required";
                  }
                  return null;
                },
                suffix:  isExternalAccountNameLoading ? CupertinoActivityIndicator() : null,
                header: "Account Name",
                readOnly: true,
                textEditingController: accountNameExternal,
              ),
            ],
          ),
        ],
      );
    }
    else if (bankTransferMode?.id == "external_foreign"){

      return Column(
        children: [
          CustomDropDown(
            suffix: isCountriesLoading ? CupertinoActivityIndicator() : null,
            intialValue: CustomDropDownItem(value: countriesModel, text: "Select a country"),
            items: fundTransferState.countriesList.map((e){
              return   CustomDropDownItem(
              value: e,
              text: e.name,
    );
    }).toList(),
            onSelected: (v) {
              countriesModel = v;
              // if(fundTransferState.transferMethod?.isEmpty || fundTransferState.transferMethod == null ){
                fetchTransferMethod(countriesModel.code);
              // }
              transferMethod = null;
              bankIntl = null;
              transferFee = null;
              bankIntlList.clear();

            },
            header: "Select Country",
          ),
          SizedBox(height: 10),


        //   CustomDropDown(
        //     suffix: isTransferMethodLoading ? CupertinoActivityIndicator() : null,
        //     intialValue: CustomDropDownItem(value: transferMethod, text: "Select Transfer method"),
        //     items: transferMethodList.map((e) {
        //       return       CustomDropDownItem(
        //         value: e,
        //         text: e.name,
        //       );
        //     }).toList(),
        //
        //     onSelected: (v) {
        //    setState(() {
        //      transferMethod  = v;
        //
        //    });
        //
        // transferMethod.code == "mobilemoney" ? fetchmobileMoney(countriesModel.code, transferMethod.code) :    fetchIntlbanks(countriesModel.code, transferMethod.code);
        //     bankIntl = null;
        //    transferFee = null;
        //     },
        //     header: "Select transfer method",
        //   ),

          Container(

            child: CategoryDropDownField(
              dataSource: transferMethodList.isEmpty ? [] :transferMethodList  ,
              value: transferMethod,
              fillColor: Color(0xffF5F9FF),
              validator:(value) {

                if (value ==  null) {
                  return "Please select one option";
                }

                // if (value.isEmpty) {
                //   return "Please select one option";
                // }
                return null;
              },

            titleText: "Select transfer method",
              hintText: "Select a transfer method",
              textField: 'name',
              valueField: 'code',
              onChanged: (value) {
                print("bills category: $value");
         setState(() {
           transferMethod = value;
         });
                transferMethod.code == "mobilemoney" ? fetchmobileMoney(countriesModel.code, transferMethod.code) :    fetchIntlbanks(countriesModel.code, transferMethod.code);
                    bankIntl = null;
                   transferFee = null;
                   branchList = null;
                   amountControllerInternational.text = "0.00";
                   accountNameInternational.clear();
                   accountNumInternational.clear();

              },
            ),
          ),

          SizedBox(height: 10),
          transferMethod == null &&    bankIntlList == null  ?
       CupertinoActivityIndicator()
           :

       getBanksOrMobileMoney(context)

        ],
      );
    }

    }






  Widget getBanksOrMobileMoney(BuildContext context) {

    if (transferMethod?.code == "account" ) {

      return  BankAccount();
    }
    else if (transferMethod?.code == "mobilemoney"){
      return MobileMoneyWidget();
    }else{
     return SizedBox();
    }

  }




  void fetchbeneficiaryList(BankTransferMode mode) async{
    print("fetching beneficiary");
    setState(() {

      isBeneficiaryListLoading = true;

    });
    var result = await fundTransferState.beneficiariesList(token: loginState.user.token, business_uuid: businessState.business?.business_uuid ??"", isPersonal: appState.isPersonal, mode: mode?.id);
    setState(() {
      isBeneficiaryListLoading = false;

    });
    if(result["error"] == false){
      setState(() {
    beneficiaryList = result["beneficiaryList"];

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
    }else{
      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:scaffoldKey, snackColor: Colors.red );

    }

  }






  verifyPasscode(pin, BankTransferMode bankTransferMode) async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result = await loginState.verifyPasscode(token: loginState.user.token, passcode: pin);
    Navigator.pop(context);
    if(result["error"] == false){
      bankTransferMode.id == "internal" ? gladeToGlade() : bankTransferMode.id == "external_local" ? gladeToExternal() : gladeToInternational() ;
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




//  Glade to glade Methods ==================Starts
    cangetName(String accountNum)async{
      if(bankTransferMode.id == "internal"){
          setState(() {
            isGladeAccountNameLoading = true;

          });
          var result = await fundTransferState.FetchAcountNameInternal(accoutNum: accountNum, token: loginState.user.token, mode: bankTransferMode.id, business_uuid: businessState.business?.business_uuid ?? "", isPersonal: appState.isPersonal  );
          print(result);
          setState(() {
            isGladeAccountNameLoading = false;

          });
          if(result["error"] == false){
            setState(() {
              account_name = result["accountName"];
              accountName.text = account_name.accountName;
              print(accountName.text);
            });

          }else if(result["error"] == true && result["statusCode"] == 401) {
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
            CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:scaffoldKey, snackColor: Colors.red );

          }
        }else if(bankTransferMode.id == "external_local") {
        setState(() {
               isExternalAccountNameLoading = true;

             });
             var result = await fundTransferState.FetchAcountNameExternal(accoutNum: accountNum, token: loginState.user.token, mode: bankTransferMode.id, bankCode: bank.bank_code );
             setState(() {
               isExternalAccountNameLoading = false;
             });
             if(result["error"] == false){
               setState(() {
                 account_name = result["accountName"];
                 accountNameExternal.text = account_name.accountName;

               });

             }else if(result["error"] == true && result["statusCode"] == 401){
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
               CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey: scaffoldKey, snackColor: Colors.red );
             }
      }else if(bankTransferMode.id == "external_foreign"){
        setState(() {
          isForeignAccountNameLoading = true;

        });
        var result = await fundTransferState.FetchAcountNameInternal(accoutNum: accountNumber, token: loginState.user.token, mode: bankTransferMode.mode );

        setState(() {
          isForeignAccountNameLoading = false;

        });
        if(result["error"] == false){
          setState(() {
            account_name = result["accountName"];
            accountNameInternational.text = account_name.accountName;

          });

        }else if(result["error"] == true && result["statusCode"] == 401){
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
          CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:scaffoldKey, snackColor: Colors.red );

        }
      }
    }











  gladeToGlade()async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    transferReceiptData = TransferReceiptData(
        accountName: accountName.text,
        accountNumber: accountNum.text,
        amount: amountController.text,
        narration: narration.text,
        // bank: bankTransferMode.id == "internal" ? "Glade" : ""
    );
    var result = await fundTransferState.gladeToGlade(token: loginState.user.token,  account_number: accountNum.text, narration: narration.text, save_beneficiary: save_beneficiary, amount: amountController.text.replaceAll(",", "").replaceAll("NGN", ""), business_uuid: businessState.business?.business_uuid ?? "", isPersonal:appState.isPersonal);
    Navigator.pop(context);
    if(result["error"] == false){
      setState(() {
        transferHistory = result["transferhistory"];
        print(" iaia $transferHistory");
        print("txr ${transferHistory.txn_ref}");

        transferReceiptData = TransferReceiptData(
          accountName: transferHistory.beneficiary_name,
          accountNumber: transferHistory.beneficiary_account,
          amount: transferHistory.value,
          narration: narration.text,
          txn_ref: transferHistory.txn_ref,
          status: transferHistory.status,
          remarks: transferHistory.remark,
          currency: transferHistory.currency,
          created_at: transferHistory.created_at,
          date: transferHistory.created_at,
          bank: transferHistory.beneficiary_institution,





          // bank: bankTransferMode.id == "internal" ? "Glade" : ""
        );
      pushTo(context, FundTransferSuccessfulPage(
        transferReceiptData: transferReceiptData,

        transferHistory: transferHistory ,

      // john2@moakt.cc

      ));
      });
     CommonUtils.getBalance(loginState);
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
      pushTo(context, FundTransferFailedPage(
        text: result["message"],
      ));
    }

  }


//  ===================================== Ends














  gladeToExternal()async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result = await fundTransferState.gladeToOtherBank(account_name: accountNameExternal.text, account_number: accountNumExternal.text, bank_code: bank.bank_code,  narration: narration.text, save_beneficiary: save_beneficiary, amount: amountController.text.replaceAll(",", "").replaceAll("NGN", ""), token: loginState.user.token, bank_name: bank.bank_name, business_uuid: businessState.business?.business_uuid ?? "" , isPersonal: appState.isPersonal);
    Navigator.pop(context);
    if(result["error"] == false){
      setState(() {
        transferHistory = result["transferhistory"];
        transferReceiptData = TransferReceiptData(
          accountName: transferHistory.beneficiary_name,
          accountNumber: transferHistory.beneficiary_account,
          amount: transferHistory.value,
          narration: narration.text,
          txn_ref: transferHistory.txn_ref,
          status: transferHistory.status,
          remarks: transferHistory.remark,
          currency: transferHistory.currency,
          created_at: transferHistory.created_at,
          date: transferHistory.created_at,
          bank: transferHistory.beneficiary_institution,





          // bank: bankTransferMode.id == "internal" ? "Glade" : ""
        );
        pushTo(context, FundTransferSuccessfulPage(
          transferReceiptData: transferReceiptData,
              status:  transferHistory.status,
          transferHistory: transferHistory ,
        )
        );
      });
    }else if(result["error"] == true && result["statusCode"] == 401){
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
      pushTo(context, FundTransferFailedPage(
        text: result["message"],
      ));
      // CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:scaffoldKey, snackColor: Colors.red );

    }

  }
 //
 fetchCountries()async{

   setState(() {

     isCountriesLoading = true;

   });
   var result = await fundTransferState.getCountries(token: loginState.user.token, business_uuid: businessState.business?.business_uuid ??"", isPersonal: appState.isPersonal);

   setState(() {
     isCountriesLoading = false;

   });
   if(result["error"] == false){
     setState(() {


     });

   }else{
     // CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:scaffoldKey, snackColor: Colors.red );

   }

 }


  //  Glade to External Methods ==================Ends









  //  Glade to Internationa Methods ==================Starts


  fetchTransferMethod(country_code)async{
    print("fetching methods");
    setState(() {

      isTransferMethodLoading = true;

    });
    var result = await fundTransferState.getTransferMethod(token: loginState.user.token, country_code:country_code, business_uuid: businessState.business?.business_uuid ?? "", isPersonal: appState.isPersonal );

    setState(() {
      isTransferMethodLoading = false;

    });
    if(result["error"] == false){
      setState(() {
        transferMethodList = result["transferMethod"];
      });

    }else{
      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:scaffoldKey, snackColor: Colors.red );

    }

  }

  fetchIntlbanks(country_code, method_id)async{
    // print("fetching intl banks");
    setState(() {

      isintlBankLoading = true;

    });
    var result = await fundTransferState.getBanksInternational(token: loginState.user.token, method_id: method_id, country_code:country_code, business_uuid: businessState.business?.business_uuid ?? "", isPersonal: appState.isPersonal );
    print(result);
    setState(() {
      isintlBankLoading = false;

    });
    if(result["error"] == false){
      setState(() {
        bankIntlList = result["bankIntlList"];
      });

    }else{
      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:scaffoldKey, snackColor: Colors.red );

    }

  }



  fetchmobileMoney(country_code, method_id)async{
    print("fetching mobile banks");
    setState(() {

      isintlBankLoading = true;

    });
    var result = await fundTransferState.getMobileInternational(token: loginState.user.token, method_id: method_id, country_code:country_code, business_uuid: businessState.business?.business_uuid ?? "", isPersonal: appState.isPersonal );
    print(result);
    setState(() {
      isintlBankLoading = false;

    });
    if(result["error"] == false){
      setState(() {
        mobileMoneyList = result["mobileMoney"];
      });

    }else{
      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:scaffoldKey, snackColor: Colors.red );

    }

  }

  fetchIntlbranchBank(country_code, bank_id)async{
    print("fetching intl branck");
    setState(() {

      isintlBranchLoading = true;

    });
    var result = await fundTransferState.getBankBranchInternational(token: loginState.user.token, bank_id: bank_id, country_code:country_code, business_uuid: businessState.business?.business_uuid ?? "", isPersonal: appState.isPersonal );
print(result);
    setState(() {
      isintlBranchLoading = false;

    });
    if(result["error"] == false){
      setState(() {
        bankIntlBranchList = result["bankIntlBranchList"];
      });

    }else{
      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:scaffoldKey, snackColor: Colors.red );

    }

  }




  void fetchTransferFee(amount)async{
  setState(() {
    isfeeLoading = true;
  });
    var result = await fundTransferState.transferFee(amount:amount,destination_currency:countriesModel.currency, source_currency:loginState.user.currency, business_uuid: businessState.business?.business_uuid ?? "", isPersonal: appState.isPersonal, token: loginState.user.token);

  setState(() {
    isfeeLoading = false;
  });
      if(result["error"] == false){
        setState(() {
          transferFee = result["transferFee"];
        });
      }else{
        // toast("An Error occured");
      }
  }







  gladeToInternational()async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result = await fundTransferState.internationalTransfer(beneficiary_name: accountNameInternational.text,  beneficiary_account_number: accountNumInternational.text, bank_code: bankIntl.code,  narration: narration.text, save_beneficiary: save_beneficiary, amount: amountControllerInternational.text, currency: countriesModel.currency, currency_code: countriesModel.code, beneficiary_bank_branch: branchList?.code, business_uuid:businessState.business?.business_uuid ?? "", isPersonal: appState.isPersonal,token: loginState.user.token  );
   pop(context);
    if(result["error"] == false){
      setState(() {
        transferHistory = result["transferhistory"];
        print(" iaia $transferHistory");
        print("txr ${transferHistory.txn_ref}");

        transferReceiptData = TransferReceiptData(
          accountName: transferHistory.beneficiary_name,
          accountNumber: transferHistory.beneficiary_account,
          amount: transferHistory.value,
          narration: narration.text,
          txn_ref: transferHistory.txn_ref,
          status: transferHistory.status,
          remarks: transferHistory.remark,
          currency: transferHistory.currency,
          created_at: transferHistory.created_at,
          date: transferHistory.created_at,
          bank: transferHistory.beneficiary_institution,





          // bank: bankTransferMode.id == "internal" ? "Glade" : ""
        );

        pushTo(context, FundTransferSuccessfulPage(
          transferReceiptData: transferReceiptData,
          status: transferHistory.status,
          transferHistory: transferHistory ,



        ));
      });
    }else if(result["error"] == true && result["statusCode"] == 401){
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
    }else{
      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:scaffoldKey, snackColor: Colors.red );

    }

  }



  //  Glade to Internationa Methods ==================Ends



//general Methods









  @override
  void afterFirstLayout(BuildContext context) {
    getMode();



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


  void getMode() async{
    print("call");
    setState(() {
      isLoadingMode = true;
    });
    var result = await fundTransferState.getMode(token: loginState.user.token);
    setState(() {
      isLoadingMode = false;
    });
    if(result["error"] == false){
      setState(() {

      });
    }else if(result["error"] == true && result["statusCode"] == 401){
      // showDialog(
      //     barrierDismissible: false,
      //     context: context,
      //     child: dialogPopup(
      //         context: context,
      //         body: result["message"]
      //     ));
    }
    else{
      CommonUtils.showMsg(body: result["message"]  ?? 'tt', context: context, scaffoldKey: scaffoldKey,snackColor : Colors.red );
    }
  }




  Widget BankAccount() {
    return  Column(
      children: [

        Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Container(

              child: Text(
                "Select a bank",
                style: TextStyle(color: blue, fontSize: 12),
              ),
            ),
            SizedBox(height: 4),
            Container(

              decoration: BoxDecoration(
                  border: Border.all(
                    color: borderBlue.withOpacity(0.5),
                  ),
                  borderRadius:
                  BorderRadius
                      .circular(8)
              ),
              child: DropDownField2(
                isDark: false,
                parentContext: context,
                dataSource: bankIntlList,
                value: bankIntl,
                validator: (value) {
//                                     if (isNull(value)) {
                  if (value.toString().isEmpty || value.toString() == "0") {
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
                    bankIntl = value;
                    transferFee = null;
                    branchList = null;
                    // bankIntlBranchList.clear();
                    countriesModel.has_branch ?     fetchIntlbranchBank(countriesModel.code, bankIntl.id) : null;

                  });
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 10),

     countriesModel.has_branch && bankIntl != null ?     CustomDropDown<BankIntlBranchList>(
          suffix: isintlBranchLoading ? CupertinoActivityIndicator() : null,
          header: "Select bank branch",
          intialValue: CustomDropDownItem<BankIntlBranchList>(

              value: branchList,
              text: "Select a branch..."
          ),

          items: bankIntlBranchList.map((e){
            return CustomDropDownItem(
                text: e.name,
                value: e
            );

          }).toList(),
          onSelected: (v) {
            branchList = v;
          },
        ) : SizedBox(),

              // : SizedBox(),
        SizedBox(height: 10),
        Column(

          children: [
            CustomTextField(
              textEditingController: accountNumInternational,
                type: FieldType.number,
                textInputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  new LengthLimitingTextInputFormatter(11),
                ],
                hint: "",
                onChanged: (String value){
                  setState(() {
                    accountNumberInternational = value;
                    if(value.length == 11){

                    }

                  });

                },

                validator: (v){
                  if(v.isEmpty){
                    return "Field is required";
                  }
                  return null;
                },
                header: "Enter Account Number"


            ),
            SizedBox(height: 15),
            CustomTextField(
              validator: (v){
                if(v.isEmpty){
                  return "Field is required";
                }
                return null;
              },
              header: "Account Name",

              textEditingController: accountNameInternational,
            ),
          ],
        ),
      ],
    );
  }








  Widget MobileMoneyWidget() {
    return Column(
      children: [
        CustomDropDown<MobileMoney>(
          suffix: isintlBankLoading ? CupertinoActivityIndicator() : null,
          header: "Select provider",
          intialValue: CustomDropDownItem<MobileMoney>(
              value: mobileMoney,
              text: "Select provider"
          ),

          items: mobileMoneyList.map((e){
            return CustomDropDownItem(
                text: e.name,
                value: e
            );

          }).toList(),
          onSelected: (v) {

          },
        ),
        Column(

          children: [
            CustomTextField(
                type: FieldType.number,
                textInputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  new LengthLimitingTextInputFormatter(11),
                ],
                hint: "",
                onChanged: (String value){
                  setState(() {
                    accountNumberInternational = value;
                    if(value.length == 11){

                    }

                  });

                },
                header: "Enter Account Number"


            ),
            SizedBox(height: 15),
            CustomTextField(
              header: "Account Name",

              textEditingController: accountNameInternational,
            ),

//             Container(
//
//               child: CategoryDropDownField(
//                 dataSource: ["1", "2"],
//                 value: "",
//                 fillColor: Color(0xffF5F9FF),
//                 validator:(v){
//
//                 },
//
//                 hintText: "Select a category",
//                 textField: 'name',
//                 valueField: 'code',
//                 onChanged: (value) {
//                   print("bills category: $value");
// //                                        print(categories[categories.indexWhere((c)=> c.code == value)].name);
//
//                 },
//               ),
//             ),
          ],
        ),

      ],
    );
  }



  }



