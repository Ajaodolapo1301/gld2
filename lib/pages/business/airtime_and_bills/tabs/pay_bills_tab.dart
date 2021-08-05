import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:glade_v2/api/AirtimeAndBills/BillsSingleton.dart';
import 'package:glade_v2/core/models/apiModels/AirtimeAndBills/airtimeAndBills.dart';
import 'package:glade_v2/core/models/apiModels/Business/increaseLimit/billsType.dart';
import 'package:glade_v2/core/models/ui/TransferReceiptData.dart';
import 'package:glade_v2/pages/states/airtime_and_bills_successful_page.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/airtimeAndBills.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/reuseables/dialogPopup.dart';
import 'package:glade_v2/reuseables/form.dart';
import 'package:glade_v2/utils/functions/bottom_sheet_utils.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/body_modal_not_live.dart';
import 'package:glade_v2/utils/widgets/bottom_sheets/transaction_pin_bottom_sheet.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_drop_down.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class PayBillsTab extends StatefulWidget {
  // bool isLoading ;
  // BillsInfo billsInfo;
  // List <Categories> categories;

   // PayBillsTab({this.isLoading = false, this.categories, this.billsInfo});
  @override
  _PayBillsTabState createState() => _PayBillsTabState();
}

class _PayBillsTabState extends State<PayBillsTab> with AfterLayoutMixin<PayBillsTab> {

Categories categories;
List<Categories> categoriesList = [];
BillsReceiptData billsReceiptData;
MoneyMaskedTextController amountController = MoneyMaskedTextController(
    decimalSeparator: ".",
    leftSymbol: "NGN ",
    thousandSeparator: ",",
    initialValue: 0.00

);
List<Bills> billers;
Bills bills;
AirtimeData airtimeData;
bool readOnly = false;
bool isCableValidateLoading = false;
bool    isMeternameLoading = false;
bool   isinternetNameLoading = false;
  TextEditingController decoderNumber  =  TextEditingController();
TextEditingController decoderName  = TextEditingController();
TextEditingController reference  = TextEditingController();
TextEditingController referenceName  = TextEditingController();
TextEditingController phoneNumber  = TextEditingController();
TextEditingController meterName  = TextEditingController();
TextEditingController meterNum  = TextEditingController();
TextEditingController internetNum  = TextEditingController();
final _scaffoldKey = GlobalKey<ScaffoldState>();
AirtimeAndBillsState airtimeAndBillsState;
AppState appState;
BillsInfo billsInfo;
LoginState loginState;
bool isloading = false;
BusinessState businessState;
bool isLoading = false;
bool   show = true;
Items item;
Cable cable;
Meter meter;
BeneficiaryAirtime singleBeneficiary;
List<BeneficiaryAirtime> beneficiaryList = [];

BillsSingleton billsSingleton = BillsSingleton();

bool save_beneficiary = false;
final _formKey = GlobalKey<FormState>();
List<Items> items;
  @override
  Widget build(BuildContext context) {
    businessState = Provider.of<BusinessState>(context);
    airtimeAndBillsState = Provider.of<AirtimeAndBillsState>(context);
    loginState = Provider.of<LoginState>(context);
    appState = Provider.of<AppState>(context);
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 10),

                Builder(
                  builder: (context){
                    if(isLoading){
                     return Center(child: CupertinoActivityIndicator());
                    }else{
                      return  Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              CustomDropDown<Categories>(
                                intialValue: CustomDropDownItem(value: categories, text: "Select a category "),
                                items: categoriesList.map((e){
                                  return CustomDropDownItem<Categories>(
                                      text: e.category_title,
                                      value: e
                                  );
                                }).toList(),

                                onSelected: (v) {
                                  setState(() {
                                    show = true;
                                    categories = v;

                                    reference.clear();
                                    referenceName.clear();
                                    billers = billsInfo?.data?.bills?.where((element) => element.category_id == categories?.id.toString())?.toList();

                                    // items = [];


                                  });

                                  // print(" bille $billers");
                                },
                                header: "Select Bill Type",
                              ),
                              SizedBox(height: 15),



                              CustomDropDown<Bills>(
                                intialValue: CustomDropDownItem<Bills>(value: bills , text: "Loading...."),
                                items: billers == null ? [] : billers.map((e) {

                                  return   CustomDropDownItem<Bills>(
                                      value: e,
                                      text: e.name
                                  );
                                }).toList(),

                                onSelected: (v) {
                                  setState(() {
                                    show = true;


                                    bills = v;
                                    if(bills != null){
                                      getBeneficiary(bills?.id);

                                    }

                                    items = null;

                                    if(billsInfo != null){

                                      items =  billsInfo?.data.items.where((element) => element.billsId == bills?.id).toList();
                                    }

                                    // print("items ss $items");
                                    if(items == null || items.isEmpty){
                                      setState(() {
                                        show = false;

                                      });
                                    }
                                  });
                                },
                                header: "Select a Biller",
                              ),
                              SizedBox(height: 15),
                              show == false ? SizedBox() :     CustomDropDown<Items>(
                                intialValue: CustomDropDownItem(value: item, text: "Select an Item"),
                                items: items == null ?  [] : items.map((e){
                                  return    CustomDropDownItem(
                                    value: e,
                                    text: e.title,
                                  );
                                }).toList(),


                                onSelected: (v) {
                                  setState(() {
                                    item = v;

                                    // });
                                    print("itemememe ${item}");
                                    if(item?.base_amount != "0.00"){
                                      amountController.text = item?.base_amount;
                                      readOnly = true;
                                    }else if(item == null || item.base_amount == "0.00"){
                                      amountController.text = "0.00";
                                      readOnly = false;
                                    }
                                    // setState(() {

                                  });
                                },
                                header: "Select an Item",
                              ),

                              Builder(builder: (context) {
                                return getMiddle(context,   items);
                              }),






                              CustomTextField(
                                  readOnly: readOnly,
                                  textEditingController: amountController,
                                  validator: (v){
                                    if(v.isEmpty){
                                      return "Amount is required";
                                    }    else if (v.length <= 4) {
                                      return "Invalid Amount";
                                    }else{
                                      if(double.parse(v.trim()
                                          .replaceAll("NGN", "")
                                          .replaceAll(",", "")
                                          .split(".")[0]) < 50){
                                        return "Invalid Amount. Minimum of 50 required";
                                      }
                                    }

                                    return null;
                                  },
                                  header: "Amount"),
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
                                      activeColor: blue,
                                      onChanged: (value) {
                                        setState(() {
                                          save_beneficiary = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              isLoading  ? SizedBox() :     CustomButton(
                                text: "Proceed",
                                color: cyan,
                                onPressed: () {
                                  if(_formKey.currentState.validate()){
                                    if(loginState.user.compliance_status == "approved"){
                                      showTransactionPinBottomSheet(
                                        context,
                                        minuValue: 50,
                                        details: TransactionBottomSheetDetails(
                                            buttonText: "Pay",
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
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 14, horizontal: 25),
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
                                                              bills.name,
                                                              style: TextStyle(
                                                                color: blue,
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                            Text(
                                                              item.title,
                                                              style:
                                                              TextStyle(color: blue, fontSize: 13),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Text(
                                                        amountController.text,
                                                        style: TextStyle(
                                                          color: blue,
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                              ],
                                            )),
                                        onButtonPressed: (pin) {
                                          verifyPasscode(pin, categories);
                                          // pop(context);
                                          // pushTo(context, AirtimeAndBillsSuccessfulPage());
                                        },
                                      );
                                    }else{
                                      CommonUtils.modalBottomSheetMenu(context: context,  body: buildModal(text: "Oh, Merchant not enabled for transaction!", subText: "dbfhbdf", status: loginState.user.compliance_status));
                                    }
                                  }

                                },
                              ),
                              SizedBox(height: 10)
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),








            ],
          ),
        ),
      ),
    );
  }



Widget getMiddle(BuildContext context, List<Items> items) {
    return  Column(
      children: [

        show == false ? SizedBox() :      GestureDetector(
          onTap: () {
            showBeneficiaryBottomSheetAirtime(context: context, beneficiaryList: beneficiaryList, onBeneficiarySelect: (v){
              setState(() {
                  singleBeneficiary = v;

                // bills = billers[billers.indexWhere((b) =>
                // "${b.id}" == "${singleBeneficiary.id}")];
                reference.text = singleBeneficiary.reference;
                referenceName.text = singleBeneficiary.reference_data;
                 // print(singleBeneficiary.reference);
              });

            });
          },
          child: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              "Choose Beneficiary",
              style: TextStyle(
                  color: cyan, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(height: 15),
        CustomTextField(
        onChanged: (v){
            if(v.length == 11){
              categories.id == 3 ?  validateMeterName(v) :  categories.id == 5 ? validateDecodername(v) : null;

            }else if(v.length < 11){
          referenceName.clear();
            }else{


            }
          },
            textEditingController: reference,
            type: FieldType.phone,
            textInputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
              new LengthLimitingTextInputFormatter(20),
            ],
            validator: (v){
              if(v.isEmpty){
                return "Empty";
              }
              return null;
            },
            header:  bills?.reference ?? ""),
        SizedBox(height: 15),
   item?.requires_name_enquiry == 0 ? SizedBox() :  CustomTextField(
            suffix: isloading ?  CupertinoActivityIndicator() : null,
            readOnly: true,
            textEditingController: referenceName,
            header: "${ bills?.reference} details",
          ),
      ],
    );

    //cable Sub
  // } else if (categories?.id == 5) {
  //   return Column(
  //     children: [
  //
  //       SizedBox(height: 15),
  //       CustomTextField(
  //           textEditingController: decoderNumbe
  //           onChanged: (v){
  //
  //             if(v.length == 10){
  //               validateDecodername();
  //             }else if (v.isEmpty){
  //               decoderName.clear();
  //             }
  //           },
  //           validator: (v){
  //             if(v.isEmpty){
  //               return "Empty";
  //             }
  //             return null;
  //           },
  //           header:  bills?.reference ?? ""),
  //       SizedBox(height: 15),
  //       CustomTextField(
  //         suffix: isCableValidateLoading ?  CupertinoActivityIndicator() : null,
  //         readOnly: true,
  //         textEditingController: decoderName,
  //         header: "Enter Decoder Name (IUC) Detailers",
  //       ),
  //       SizedBox(height: 15),
  //     ],
  //   );
  //
  //   // Electricity token
  // } else if (categories?.id  == 3) {
  //   return Column(
  //     children: [
  //       SizedBox(height: 15),
  //       CustomTextField(
  //         textEditingController: meterNum,
  //         header: bills?.reference ?? "",
  //         onChanged: (v){
  //           if(v.length == 10){
  //             validateMeterName(v);
  //           }else if (v.isEmpty){
  //             meterName.clear();
  //           }
  //         },
  //         validator: (v){
  //           if(v.isEmpty){
  //             return "Empty";
  //           }
  //           return null;
  //         },
  //
  //
  //       ),
  //       SizedBox(height: 15),
  //       CustomTextField(
  //           readOnly: true,
  //           suffix: isMeternameLoading ? CupertinoActivityIndicator() : null,
  //           textEditingController: meterName,
  //
  //           header: "Meter name"),
  //       SizedBox(height: 15),
  //
  //     ],
  //   );
  // }
  // //Internet services
  // return Column(
  //   children: [
  //
  //     // SizedBox(height: 15),
  //     CustomTextField(
  //       textEditingController: internetNum,
  //       header: bills?.reference,
  //
  //       onChanged: (v){
  //         if(v.length == 10){
  //           validateInternetName(v);
  //         }
  //       },
  //       validator: (v){
  //         if(v.isEmpty){
  //           return "Empty";
  //         }
  //         return null;
  //       },
  //     ),
  //     // SizedBox(height: 15),
  //     // CustomTextField(header: "Mifi Account Number Details"),
  //     SizedBox(height: 15),
  //   ],
  // );
}





// decode
  void validateDecodername(cableNum)async{
  // print("vaGlade");
  setState(() {
    isloading = true;

  });
  var result = await  airtimeAndBillsState.fetchCableName(card_iuc_number: cableNum, token: loginState.user.token, paycode: item.paycode, amount: amountController.text );
  // print(result);
  setState(() {
    isloading = false;

  });
  if(result["error"] == false){
    setState(() {
      cable = result["cable"];
      referenceName.text = cable.decoder_name;

    });

  }else{
    toast("An Error occured resolving");

    // CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:scaffoldKey, snackColor: Colors.red );

  }
}
  // meter
  void validateMeterName(meterNum) async{
    setState(() {
      isloading = true;
    });
    var result = await  airtimeAndBillsState.fetchmetername(meter_number: meterNum, token: loginState.user.token, paycode: item.paycode );
    setState(() {
      isloading = false;
    });
    // print(result);
    if(result["error"] == false){
      setState(() {
        meter = result["meter"];
        referenceName.text = meter.custName;

      });

    }else{
      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );

    }
  }

  void validateInternetName(internet) async{
    setState(() {
      isloading = true;
    });
    var result = await  airtimeAndBillsState.fetchinternetService(account_number: internet, token: loginState.user.token, );
    setState(() {
      isloading = false;
    });
    // print(result);
    if(result["error"] == false){
      setState(() {
        // cable = result["cable"];
        // decoderName.text = cable.decoder_name;

      });

    }else{
      // CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:scaffoldKey, snackColor: Colors.red );

    }
  }



verifyPasscode(pin, Categories categories) async{
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Preloader();
      });
  var result = await loginState.verifyPasscode(token: loginState.user.token, passcode: pin);
  Navigator.pop(context);
  if(result["error"] == false){
    // print(categories.category_title);
    categories.category_title == "Airtime" ? airtimepayment() : categories?.id  == 3  ? electricity() : categories?.id  == 5 ? cablePay() : internetPay() ;
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







//final  Payment
void airtimepayment()async{

  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Preloader();
      });
  var result = await  airtimeAndBillsState.airtime(token: loginState.user.token,  paycode: item.paycode,   reference:reference.text,  amount: amountController.text.replaceAll(",", "").replaceAll("NGN", ""), save_beneficiary: save_beneficiary, isPersonal: appState.isPersonal, business_uuid: businessState?.business?.business_uuid ?? "", );
      pop(context);
      if(result["error"] == false){
        setState(() {
          airtimeData = result["data"];
          // print(airtimeData.amount_charged)
            billsReceiptData = BillsReceiptData(
              electricityToken: airtimeData.token,
              transactionId: airtimeData.id,
              txn_ref: airtimeData.txnRef,
              remarks: airtimeData.note,
              unit: airtimeData.unit,
              amount: airtimeData.amount_charged,
                bill_item_id: airtimeData.bill_item_id,
                bill_reference: airtimeData.bill_reference,
              date: DateTime.now().toString(),
              status: airtimeData.status,
            );
           pushTo(context, AirtimeAndBillsSuccessfulPage(

             message: result["message"],
             billsReceiptData: billsReceiptData,
           ));
        });

      }else{
        CommonUtils.showMsg(body: result["message"]  ?? 'tt', context: context, scaffoldKey: _scaffoldKey,snackColor : Colors.red );
      }
}

void electricity()async{
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Preloader();
      });
  var result = await  airtimeAndBillsState.electricy(token: loginState.user.token, paycode: item.paycode,   reference:reference.text, amount: amountController.text.replaceAll(",", "").replaceAll("NGN", ""), save_beneficiary: save_beneficiary, meter_number_details: referenceName.text, isPersonal: appState.isPersonal, business_uuid: businessState?.business?.business_uuid ?? "",);
 pop(context);
  if(result["error"] == false){
    setState(() {
      airtimeData = result["data"];
      // print(airtimeData.status);
      billsReceiptData = BillsReceiptData(
        electricityToken: airtimeData.token,
        transactionId: airtimeData.id,
        txn_ref: airtimeData.txnRef,
        remarks: airtimeData.note,
        unit: airtimeData.unit,
        amount: amountController.text,
        bill_item_id: airtimeData.bill_item_id,
        bill_reference: airtimeData.bill_reference,
        date: DateTime.now().toString(),
        status: airtimeData.status ?? "Successful",

      );
      pushTo(context, AirtimeAndBillsSuccessfulPage(
        billsReceiptData: billsReceiptData,
        message: result["message"],
      ));
    });

  }else{
    CommonUtils.showMsg(body: result["message"]  ?? 'tt', context: context, scaffoldKey: _scaffoldKey,snackColor : Colors.red );
  }
}

  getBeneficiary(type)async{

    var result = await airtimeAndBillsState.getBeneficairies(type: type, token: loginState.user.token);

      if(result["error"] == false){
    setState(() {
      beneficiaryList = result["beneficiaryAirtime"];
    });
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
      }else{
        toast("An Error occurred fetching beneficiary");
      }
  }

void cablePay()async{
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Preloader();
      });
  var result = await  airtimeAndBillsState.cable(token: loginState.user.token, paycode: item.paycode,   reference:reference.text,   cable_name :referenceName.text,  amount: amountController.text.replaceAll(",", "").replaceAll("NGN", ""), save_beneficiary: save_beneficiary, isPersonal: appState.isPersonal, business_uuid: businessState?.business?.business_uuid ?? "",   );
  pop(context);
  if(result["error"] == false){
    setState(() {
      airtimeData = result["data"];
      billsReceiptData = BillsReceiptData(
        // electricityToken: airtimeData.electricityToken,
        transactionId: airtimeData.id,
        txn_ref: airtimeData.txnRef,
        remarks: airtimeData.note,
        // unit: airtimeData.unit,
        amount: amountController.text,
        bill_item_id: airtimeData.bill_item_id,
        bill_reference: airtimeData.bill_reference,
        date: DateTime.now().toString(),

        status: airtimeData.status,

      );
      pushTo(context, AirtimeAndBillsSuccessfulPage(
        message: result["message"],

        billsReceiptData: billsReceiptData,
      ));
    });

  }else{
    CommonUtils.showMsg(body: result["message"]  ?? 'tt', context: context, scaffoldKey: _scaffoldKey,snackColor : Colors.red );
  }
}

 void internetPay() async {
   showDialog(
       context: context,
       barrierDismissible: false,
       builder: (BuildContext context) {
         return Preloader();
       });
   var result = await  airtimeAndBillsState.internet(token: loginState.user.token, paycode: item.paycode,   reference: reference.text,     amount: amountController.text.replaceAll(",", "").replaceAll("NGN", ""), save_beneficiary: save_beneficiary, isPersonal: appState.isPersonal, business_uuid: businessState?.business?.business_uuid ?? "", );
   pop(context);
   if(result["error"] == false){
     setState(() {
       airtimeData = result["data"];
       billsReceiptData = BillsReceiptData(
         // electricityToken: airtimeData.electricityToken,
         transactionId: airtimeData.id,
         txn_ref: airtimeData.txnRef,
         remarks: airtimeData.note,
         unit: airtimeData.unit,
         amount: amountController.text,
         bill_item_id: airtimeData.bill_item_id,
         bill_reference: airtimeData.bill_reference,
         date: DateTime.now().toString(),

         status: airtimeData.status,

       );
       pushTo(context, AirtimeAndBillsSuccessfulPage(
         billsReceiptData: billsReceiptData,
         message: result["message"],
       ));
     });

   }else{
     CommonUtils.showMsg(body: result["message"]  ?? 'tt', context: context, scaffoldKey: _scaffoldKey,snackColor : Colors.red );
   }
 }

  @override
  void afterFirstLayout(BuildContext context) {
    if (billsSingleton.billsInfo == null || billsSingleton.categories.isEmpty) {
      // load if it hasn't been loaded before
//      print("${billsSingleton.billsInfo} ${billsSingleton.categories}");
      load().then((_) {
        setState(() {
          billsInfo = billsSingleton.billsInfo;
          categoriesList = billsSingleton.categories;
        });
      });
    } else {
      setState(() {
        billsInfo = billsSingleton.billsInfo;
        categoriesList = billsSingleton.categories;
      });
    }
  }

  Future load() async {
    print("calling");
    setState(() {
      isLoading = true;
    });
    var result = await airtimeAndBillsState.getBills(token: loginState.user.token);

    setState(() {
      isLoading = false;
    });

    try {
      setState(() {
        if (result["error"] ==false) {

          billsSingleton.billsInfo = result["bills"];
          billsSingleton.categories =  billsSingleton.billsInfo.data.categories;
        }else if(result["error"] == true && result["statusCode"] ==401) {
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
          pop(context);
          CommonUtils.showMsg(body: result["message"], scaffoldKey: _scaffoldKey, snackColor: Colors.red);
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }




}








enum BillType {
  airtime,
  electricityTokens,
  internetServices,
  cableTVSubscriptions
}
