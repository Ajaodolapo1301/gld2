import 'dart:ui';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:glade_v2/core/models/apiModels/Business/Invoice/InvoiceHistory.dart';
import 'package:glade_v2/core/models/apiModels/Business/Invoice/invoice.dart';
import 'package:glade_v2/core/models/apiModels/Business/PaymentLink/paymentLinkhistory.dart';
import 'package:glade_v2/pages/states/Ivoice_sent_successfully.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/Business/invoiceState.dart';
import 'package:glade_v2/provider/Business/paymentLinkState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/reuseables/dialogPopup.dart';
import 'package:glade_v2/utils/functions/bottom_sheet_utils.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';

import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_drop_down.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class CreateInvoiceTab extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldKey;

  CreateInvoiceTab({this.scaffoldKey});

  @override
  _CreateInvoiceTabState createState() => _CreateInvoiceTabState();
}

class _CreateInvoiceTabState extends State<CreateInvoiceTab> with  AfterLayoutMixin<CreateInvoiceTab> {
  List <Map<String, dynamic>> playList = [];
  String _dateDue;
  bool _datePicked = true;
  var invoiceTo;
  // var invoiceNum;
  var customerEmail;
  var customerPhone;
  var customerAddress;

  InvoiceNum invoiceNum;
  var VAT;
  var shippingfee;
  var addVat = 0;
  var addNote;
  MoneyMaskedTextController shppingamountController = MoneyMaskedTextController(
      decimalSeparator: ".",  thousandSeparator: ",");
  var vatPercent;
  final _formKey = GlobalKey<FormState>();
  InvoiceState invoiceState;

  TextEditingController invoiceNumber = TextEditingController();
  LoginState  loginState;
  bool chargeUser = false;
  var total;
  String currencyType ;
  bool isCurrencyLoading = false;
  PaymentLinkCurrency currency;
  BusinessState businessState;

  gettingTotalPrice({addVat}){
     total  = playList.map<int>((m) => int.parse(m["price"].toString())).reduce((a,b )=>a+b);
      if(addVat != null){
        total += addVat;
      }
     return total;
  }
  bool payDirectly = false;

  PaymentLinkState paymentLinkState;
  TextEditingController _dueDateController  = TextEditingController();

  @override
  Widget build(BuildContext context) {
    invoiceState = Provider.of<InvoiceState>(context);
    loginState = Provider.of<LoginState>(context);
    businessState = Provider.of<BusinessState>(context);
     paymentLinkState = Provider.of<PaymentLinkState>(context);
    if(playList.isNotEmpty){
      gettingTotalPrice();
    }
    return  Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: CustomTextField(
                            textEditingController: invoiceNumber,
                            header: "Invoice Number",
                            type: FieldType.text,

                            onChanged: (v){
                              setState(() {
                                // invoiceNum = v;
                              });

                            },

                            validator: (value){
                              if(value.isEmpty){
                                return "Field is required";
                              }
                              // invoiceNum = value;
                              return null;

                            },


                          )),
                          SizedBox(width: 15),
                          Expanded(child: Container(
                            child: CustomTextField(

                                type: FieldType.text,
                                validator: (value){
                                  if(value.isEmpty){
                                    return "Field is required";
                                  }
                                  // invoiceTo = value;
                                  return null;

                                },
                                textEditingController: _dueDateController,
                                onTap: (){
                                  _selectDate();
                                },
                                header: "Due Date"),
                          )),
                        ],
                      ),
                      SizedBox(height: 15),
                      CustomTextField(
                        type: FieldType.text,
                        header: "Invoice to [ Customer's name ]",
                        validator: (value){
                          if(value.isEmpty){
                            return "Field is required";
                          }
                          invoiceTo = value;
                          return null;

                        },

                      ),
                      SizedBox(height: 15),
                      CustomTextField(
                        type: FieldType.email,
                        header: "Customer's Email Address",
                        validator: (value){
                          if(value.isEmpty){
                            return "Field is required";
                          }
                          customerEmail = value;
                          return null;

                        },

                      ),
                      SizedBox(height: 15),
                      CustomTextField(
                        type: FieldType.phone,
                        header: "Customer's Phone Number",
                        validator: (value){
                          if(value.isEmpty){
                            return "Field is required";
                          }
                          customerPhone = value;
                          return null;

                        },

                      ),
                      SizedBox(height: 15),
                      CustomTextField(
                        type: FieldType.phone,
                        header: "Customer's Address",
                        validator: (value){
                          if(value.isEmpty){
                            return "Field is required";
                          }
                          customerAddress = value;
                          return null;

                        },

                      ),
                      SizedBox(height: 15),
                      CustomDropDown<PaymentLinkCurrency>(
                        intialValue: CustomDropDownItem(value: currency, text: "Select Currency"),

                        items: paymentLinkState.currencies.map((e) {

                          return CustomDropDownItem(
                              value: e,
                              text: e.currency
                          );
                        }).toList(),
                        onSelected: (v) {
                          setState(() {
                            currencyType = v?.currency;
                          });
                        },
                        header: "Currency",
                      ),

                      SizedBox(height: 15),
                      Divider(),

                      GestureDetector(
                        onTap: () {
                          showAddInvoiceItemBottomSheet(
                            context,
                            onAddItem: (values) {

                              print(values);
                              playList.add(values);
                              setState(() {});
                            },
                          );

                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Invoice items".toUpperCase(),
                                  style: TextStyle(
                                      color: cyan,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Icon(
                                Icons.add_circle_outline_rounded,
                                color: orange,
                                size: 20,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "Add",
                                style: TextStyle(
                                  color: cyan,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      Builder(builder: (context) {
                        if (playList.isEmpty) {
                          return Container(
                            width: double.maxFinite,
                            padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                            child: Row(
                              children: [
                                Icon(Icons.upload_file),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "You have zero invoice item here, click add to add new.",
                                    style: TextStyle(color: blue, fontSize: 11),
                                  ),
                                )
                              ],
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: lightBlue,
                              border: Border.all(
                                color: borderBlue.withOpacity(0.09),
                              ),
                            ),
                          );
                        }
                        return Column(
                          children: [
                            ...List.generate(
                                playList.length, (index) {

                              return transactionItem(context, playList[index]);

                            }
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Grand Total:",
                                  style: TextStyle(color: blue),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "₦ ${total + addVat + double.parse(shppingamountController.text)}",
                                  style: TextStyle(
                                    color: cyan,
                                    fontSize: 15,
                                  ),
                                )
                              ],
                            ),
                          ],
                        );
                      }),





                      SizedBox(height: 15),
                      CustomTextField(
                        type: FieldType.number,
                        textInputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),

                        ],

                        onChanged: (value){
                        setState(() {

                          vatPercent =  double.parse(value) /100;
                          print(vatPercent);

                          addVat  = vatPercent * total;
                        });
                        print("fafa $addVat");
                        print(total + addVat);
                        },
                        header: "Value Added TAX [VAT]",
                        hint: "%",
                        validator: (value){
                          if(value.isEmpty){
                            return "Field is required";
                          }
                          VAT = value;
                          return null;

                        },
                      ),
                      SizedBox(height: 15),


                      CustomTextField(header: "Shipping fee",
                        textEditingController: shppingamountController,
                        onChanged: (value){
                        setState(() {
                          shippingfee = value;
                        });
                        },
                        validator: (value){
                          if(value.isEmpty){
                            return "Field is required";
                          }

                          return null;

                        },
                      ),
                      SizedBox(height: 15),

                      CustomTextField(header: "Add Note [Optional]",
                        onChanged: (value){
                          setState(() {
                            addNote = value;
                          });

                        },
                      ),
                      SizedBox(height: 15),
                      Transform.scale(
                        scale: 0.8,
                        child: CheckboxListTile(
                          value: payDirectly,
                          controlAffinity: ListTileControlAffinity.trailing,
                          onChanged: (value) {
                            setState(() {
                              payDirectly = value;
                            });
                          },
                          title: Text(
                            "Get the payment directly to your Glade Account.",
                            style: TextStyle(
                                color: blue,
                                fontSize: 13
                            ),
                          ),
                        ),
                      ),
                      Transform.scale(
                        scale: 0.8,
                        child: CheckboxListTile(
                          value: chargeUser,
                          controlAffinity: ListTileControlAffinity.trailing,
                          onChanged: (value) {
                            setState(() {
                              chargeUser = value;
                            });
                          },
                          title: Text(
                            "Charge User.",
                            style: TextStyle(
                                color: blue,
                                fontSize: 13
                            ),
                          ),
                        ),
                      ),
                      CustomButton(
                        text: "Proceed",
                        color: cyan,
                        onPressed: () {
                          if(_formKey.currentState.validate() && playList.isNotEmpty){
                            applyForInvoice();
                          }else{
                            toast("Invoice items cant be empty");
                          }
                        },
                      ),
                      SizedBox(height: 10)
                    ],
                  ),
                ),
              ),
              // CustomButton(
              //   text: "Proceed",
              //   color: cyan,
              //   onPressed: () {
              //     if(_formKey.currentState.validate() && playList.isNotEmpty){
              //       applyForInvoice();
              //     }else{
              //       toast("Invoice items cant be empty");
              //     }
              //   },
              // ),
              // SizedBox(height: 10)
            ],
          ),
        ),
      )
    );
  }





  Future _selectDate() async {
    DateTime today = DateTime.now();
    DateTime selectedDate = await showDatePicker(
        context: context,
        initialDate: today,
        firstDate: DateTime(2020),
        lastDate: DateTime(2100),
        selectableDayPredicate: (DateTime date) {
          if (date.isBefore(today.subtract(Duration(days: 1)))) {
            return false;
          }
          return true;
        });

    DateFormat dateFormat = DateFormat("yyyy-MM-dd");

    if (selectedDate != null) {
      setState(() {
        _dateDue = dateFormat.format(selectedDate);
        _dueDateController.text = _dateDue;
        _datePicked = true;
      });
    }
  }




  validateDate() {
    if (_dateDue == null) {
      setState(() {
        _datePicked = false;
      });
    }
  }



  Widget transactionItem(BuildContext context, Map<String, dynamic> invoiceItems) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: GestureDetector(
            onTap: () {
              // showSingleTransactionBottomSheet(context, textColor: orange);
            },
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: lightBlue,
                border: Border.all(
                  color: borderBlue.withOpacity(0.05),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          invoiceItems["description"],
                          style: TextStyle(color: blue, fontSize: 13),
                        ),
                        SizedBox(height: 3),
                        Text(
                          "Quantity: ${invoiceItems["qty"]}",
                          style: TextStyle(
                            color: blue,
                            fontSize: 10,
                          ),
                        )
                      ],
                    ),
                  ),
                  Text(
                    invoiceItems["price"],
                    style: TextStyle(
                      color: blue,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 0.0,
          top: -2.0,
          child: GestureDetector(
            onTap: (){
              setState(() {
                playList.removeWhere((element) => element == invoiceItems);

              });
            },
            child: Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                radius: 14.0,
                backgroundColor: Colors.white,
                child: Icon(Icons.close, color: orange),
              ),
            ),
          ),
        ),
      ],
    );
  }


  applyForInvoice() async{
    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result = await invoiceState.invoice(token: loginState.user.token, customer_email: customerEmail, invoice_note: addNote ?? "", invoice_number: invoiceNumber.text, due_date:  _dueDateController.text, items: playList, customer_name: invoiceTo, vat_amount: VAT, custPhone: customerPhone, loginState: loginState, currency: currencyType, business_uuid: businessState.business?.business_uuid, ChargeUser: chargeUser, fundWallet: payDirectly, cust_address: customerAddress, shipping_fee: shppingamountController.text..replaceAll(",", "").trim().split(".")[0]);
    Navigator.pop(context);
    if(result["error"] == false){
    pushTo(context, InvoiceSuccessfulPage());
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

      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:widget.scaffoldKey, snackColor: Colors.red );

    }
  }


  totalB(addVat){
    total += addVat;
  }


  @override
  void afterFirstLayout(BuildContext context) {
      getCurrency();
      getCounter();
  }






  void getCounter()async{
    var result = await invoiceState.generateInvoiceNum(token: loginState.user.token, business_uuid: businessState.business.business_uuid);
      if(result["error"] == false){
        setState(() {
         invoiceNum = result["num"];
         invoiceNumber.text = invoiceNum.invoice_no;
        });
      }

  }

  void getCurrency()async{
    setState(() {
      isCurrencyLoading = true;
    });
    var res  = await paymentLinkState.paymentLinkCurrency(token:loginState.user.token);
    setState(() {
      isCurrencyLoading = false;
    });
    if(res["error"] == false){

    }else{
      // CommonUtils.showMsg(body: res["message"]  ?? 'tt', context: context, scaffoldKey: _scaffoldKey, snackColor : Colors.red);
    toast("An error occurred");
    }
  }


}
