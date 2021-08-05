import 'dart:async';
import 'dart:io';


import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'package:glade_v2/core/models/apiModels/Business/PaymentLink/paymentLinkhistory.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/VirtualcardCurrency.dart';
import 'package:glade_v2/core/models/apiModels/paymentLink/paymentLink.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/Business/paymentLinkState.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/reuseables/paymentLinkComponent.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';

import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_drop_down.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:stream_transform/stream_transform.dart';
class CreatePaymentLinkTab extends StatefulWidget {
  PaymentLinkItem paymentLink;
  CreatePaymentLinkTab({this.paymentLink});
  @override
  _CreatePaymentLinkTabState createState() => _CreatePaymentLinkTabState();
}

class _CreatePaymentLinkTabState extends State<CreatePaymentLinkTab> with AfterLayoutMixin<CreatePaymentLinkTab> {
  File LogoFile;
  String _dateDue;
  bool fixAmount = false;
  bool acceptQuality =false;
  bool linkUrlIsGood ;
  bool acceptNumber =false;
  bool enableTicketing =false;
  bool payCharges = false;
  String currencyType;
  Ticketing ticketingComponent;
  PaymentLinkState paymentLinkState;
  StreamController<String> streamController = StreamController();
  BusinessState businessState;
  LoginState loginState;
  bool _datePicked = true;
  PaymentLinkCurrency currency;
  MoneyMaskedTextController amountController = MoneyMaskedTextController(
      decimalSeparator: ".",  thousandSeparator: ",");
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool       isCurrencyLoading = false;
  TextEditingController _dueDateController  = TextEditingController();
  TextEditingController logoController = TextEditingController();
  TextEditingController linkName = TextEditingController();
  TextEditingController linkurl = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController thankYouNote = TextEditingController();
AppState appState;

  final _quantityFormKey = GlobalKey<FormState>();
  bool       isUrlLoading = false;
  bool amountFixed = false;
  final FixedAmount fixedAmountComponent = FixedAmount();

  List<String> paymentTypes = ["One Time Payment", "Recurring Payment"];
  String selectedPaymentType;
  final RecurringPayment recurringPayment = RecurringPayment();

  bool acceptPhoneNumber = false;

  bool acceptQuantity = false;
  final TextEditingController quantityController = TextEditingController();

  bool splitPayment = false;

  bool chargeCustomer = false;
  // List<String> paymentTypes = ["One Time Payment", "Recurring Payment"];
  bool showAdvanced = false;
  final AdvancedOptions advancedOptionsComponent = AdvancedOptions();



  @override
  void initState() {



    super.initState();
    // appState = AppState.of(this.context);
    ticketingComponent = Ticketing();
    if (widget.paymentLink == null) {
      selectedPaymentType = paymentTypes.first;
    } else {
      // for editing payment links
      print(widget.paymentLink.image);
      linkName.text = widget.paymentLink.name;
      description.text = widget.paymentLink.description ?? "";
      selectedPaymentType = (widget.paymentLink.frequency == null
          ? paymentTypes.first
          : paymentTypes.last);

      // payment type
      if (widget.paymentLink.frequency != null) {
        recurringPayment.selectedRecurringTime =
        "${widget.paymentLink.frequency[0].toString().toUpperCase()}${widget.paymentLink.frequency.toString().substring(1)}";
        recurringPayment.selectedFrequency = widget.paymentLink.value;
      }

      // if ticketing is enabled
      enableTicketing = widget.paymentLink.isTicket == 1 ? true : false;
      ticketingComponent.ticketDatas = widget.paymentLink.ticketData ?? "";
      ticketingComponent.eventDatas = widget.paymentLink.eventData ?? "";

      // if amount is fixed
      amountFixed = widget.paymentLink.isFixed == 1 ? true : false;
      fixedAmountComponent.defaultAmountDetails.selectedCurrency =
          widget.paymentLink.currency;
      fixedAmountComponent.defaultAmountDetails.amountController.text =
      "${widget.paymentLink.amount.toString().replaceAll(",", "")}.00";
      fixedAmountComponent.extraAmount = widget.paymentLink.extraAmount;
      fixedAmountComponent.extraCurrency = widget.paymentLink.extraCurrency;

      // accept phone number
      acceptPhoneNumber =
      widget.paymentLink.acceptPhonenumber == 1 ? true : false;

      // quantity
      acceptQuantity = widget.paymentLink.showQuantity == 1 ? true : false;
      quantityController.text = widget.paymentLink.quantity != null
          ? widget.paymentLink.quantity == "null"
          ? ""
          : "${widget.paymentLink.quantity}"
          : "";

      // customer should pay for charges
      chargeCustomer = widget.paymentLink.bearer == "customer" ? true : false;

      // advanced options
      advancedOptionsComponent.linkurl.text = widget.paymentLink.link;
      advancedOptionsComponent.redirectLinkController.text = widget.paymentLink.redirectLink == null
          ? ""
          : widget.paymentLink.redirectLink.replaceAll("\"", "");
      advancedOptionsComponent.customerMessageController.text =
      widget.paymentLink.customMessage == null
          ? ""
          : widget.paymentLink.customMessage.replaceAll("\"", "");
      advancedOptionsComponent.notificationEmailController.text =
      widget.paymentLink.notificationEmail == null
          ? ""
          : widget.paymentLink.notificationEmail.replaceAll("\"", "");
    }
  }


  @override
  void dispose() {
    // _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    paymentLinkState = Provider.of<PaymentLinkState>(context);
    loginState = Provider.of<LoginState>(context);
    businessState = Provider.of<BusinessState>(context);
    appState = Provider.of(context);
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 10),
              widget.paymentLink != null
                  ?         Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Header(
            text: "Edit Payment Link",
          ),
        ): SizedBox(),
              SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: [
                    Row(
                      children: [
                        Expanded(child: CustomTextField(
                          textEditingController: logoController,
                          readOnly: true,
                          onTap: () async {
                            // if (idFile.file == null) {
                            LogoFile = await getFile();
                            setState(() {
                              logoController.text   =  basename(LogoFile?.path);
                            });

                          },
                          // },

                          header: "Upload Logo",
                        ),),

                      ],
                    ),
                    SizedBox(height: 15),
                    CustomTextField(
                      hint: "My link name",
                      textEditingController: linkName,
                        validator: (value){
                          if(value.isEmpty){
                            return "Field is required";
                          }
//                              invoiceTo = value;
                          return null;

                        },
                        header: "Enter Name of Payment Link"),
                    SizedBox(height: 15),
                    CustomTextField(
                      hint: "My Description",
                        textEditingController: description,
                        validator: (value){
                          if(value.isEmpty){
                            return "Field is required";
                          }
//                              invoiceTo = value;
                          return null;

                        },
                        header: "Enter Description"),

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
  //               CustomTextField(
  //                 prefix: Text(currencyType ?? "", style: TextStyle(color:blue),),
  //                 textEditingController: amountController,
  //                   validator: (v){
  //               if(v.isEmpty || v == "0.00"){
  //                 return "Amount is required";
  //
  //               }
  //               return null;
  // },
  //                 header: "Enter Amount",
  //                 hint: "Enter Amount eg ₦5,000",
  //                 // outerSuffix: Container(
  //                 //   padding:
  //                 //       EdgeInsets.symmetric(vertical: 12.5, horizontal: 15),
  //                 //   decoration: BoxDecoration(
  //                 //     color: lightBlue,
  //                 //     border: Border.all(
  //                 //       color: borderBlue.withOpacity(0.5),
  //                 //     ),
  //                 //     borderRadius: BorderRadius.only(
  //                 //       topRight: Radius.circular(8),
  //                 //       bottomRight: Radius.circular(8),
  //                 //     ),
  //                 //   ),
  //                 //   child: Row(
  //                 //     children: [
  //                 //       Text(
  //                 //         "NGN",
  //                 //         style: TextStyle(color: blue, fontSize: 12),
  //                 //       ),
  //                 //       SizedBox(width: 3),
  //                 //       Icon(
  //                 //         Icons.keyboard_arrow_down_rounded,
  //                 //         color: orange,
  //                 //       ),
  //                 //     ],
  //                 //   ),
  //                 // ),
  //               ),
  //               SizedBox(height: 15),
                    Divider(
                      height: 15,
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Enable Ticketing",
                            style: TextStyle(color: blue),
                          ),
                        ),
                        Transform(
                          transform: Matrix4.identity()
                            ..scale(0.5)
                            ..translate(20.0, 20.0),
                          child: CupertinoSwitch(
                            value: enableTicketing,
                            activeColor: blue,
                            onChanged: (value) {
                              setState(() {
                                enableTicketing = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    enableTicketing ? ticketingComponent : SizedBox(),
                    // SizedBox(height: 15),
                    enableTicketing
                        ? SizedBox()
                        :
                    CustomDropDown<String>(
                      intialValue: CustomDropDownItem(value:  selectedPaymentType, text: "Select Payment type"),

                      items: paymentTypes.map((e) {

                        return CustomDropDownItem(
                            value: e,
                            text: e
                        );
                      }).toList(),
                      onSelected: (v) {
                        setState(() {
                          selectedPaymentType = v;
                        });
                      },
                      header: "Select Payment type",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    selectedPaymentType == paymentTypes[1]
                        ? recurringPayment
                        : SizedBox(),
                    // Container(
                    //   margin: EdgeInsets.symmetric(horizontal: 20),
                    //   child: Column(
                    //     children: <Widget>[
                    //       Align(
                    //         alignment: Alignment.centerLeft,
                    //         child: Text(
                    //           "Select Payment Type",
                    //           style: TextStyle(
                    //               fontSize: 15,
                    //               color: Colors.black),
                    //         ),
                    //       ),
                    //       SizedBox(
                    //         height: 5,
                    //       ),
                    //       GestureDetector(
                    //         onTap: () {
                    //           // showPaymentTypeOptions();
                    //         },
                    //         child: Container(
                    //           height: 50,
                    //           decoration: BoxDecoration(
                    //               color: blue,
                    //               borderRadius:
                    //               BorderRadius.circular(5)),
                    //           padding: EdgeInsets.all(9),
                    //           child: Align(
                    //             alignment: Alignment.center,
                    //             child: Row(
                    //               mainAxisAlignment:
                    //               MainAxisAlignment.spaceBetween,
                    //               children: <Widget>[
                    //                 Text(
                    //                   selectedPaymentType,
                    //                   style: TextStyle(
                    //                       fontSize: 15,
                    //                       color: Colors.black),
                    //                 ),
                    //                 Icon(
                    //                   Icons.arrow_drop_down,
                    //                   color: blue
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       SizedBox(
                    //         height: 8,
                    //       ),
                    //       selectedPaymentType == paymentTypes[1]
                    //           ? recurringPayment
                    //           : SizedBox()
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                     Row(
              children: [
                Expanded(
                  child: Text(
                    "Should amount be fixed",
                    style: TextStyle(color: blue),
                  ),
                ),
                Transform(
                  transform: Matrix4.identity()
                    ..scale(0.5)
                    ..translate(20.0, 20.0),
                  child: CupertinoSwitch(
                    value: fixAmount,
                    activeColor: blue,
                    onChanged: (value) {
                      setState(() {
                        fixAmount = value;
                      });
                    },
                  ),
                ),
              ],
            ),
                    fixAmount ? fixedAmountComponent : SizedBox(),

                    // CustomDropDown(
                    //   intialValue: CustomDropDownItem(value: "hmm", text: "hmm"),
                    //   items: [
                    //     CustomDropDownItem(
                    //       value: "Test",
                    //       text: "Test",
                    //     ),
                    //   ],
                    //   onSelected: (v) {},
                    //   header: "Select transfer method",
                    // ),





                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Accept Phone number",
                            style: TextStyle(color: blue),
                          ),
                        ),
                        Transform(
                          transform: Matrix4.identity()
                            ..scale(0.5)
                            ..translate(20.0, 20.0),
                          child: CupertinoSwitch(
                            value: acceptPhoneNumber,
                            activeColor: blue,
                            onChanged: (value) {
                              setState(() {
                                acceptPhoneNumber = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Accept Quantity",
                            style: TextStyle(color: blue),
                          ),
                        ),
                        Transform(
                          transform: Matrix4.identity()
                            ..scale(0.5)
                            ..translate(20.0, 20.0),
                          child: CupertinoSwitch(
                            value: acceptQuantity,
                            activeColor: blue,
                            onChanged: (value) {
                              setState(() {
                                acceptQuantity = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),

                    acceptQuantity
                        ? Column(
                      children: <Widget>[
//                          Align(
//                            alignment: Alignment.centerLeft,
//                            child: Text(
//                              "Enter the maximum number of quantity for this link.",
//                              style: TextStyle(
//                                  fontSize: 15, fontWeight: FontWeight.w500),
//                            ),
//                          ),
//                          SizedBox(
//                            height: 8,
//                          ),
                        Form(
                          key: _quantityFormKey,
                          child: CustomTextField(
                            header:
                            "Enter the maximum number of quantity for this link.",
                            hint: "Quantity",
                            validator: (v) {
                              if (v.isEmpty) {
                                return ("Quantity required");
                              }
                              return null;
                            },
                            textEditingController: quantityController,
//                                    onChanged: (value) {
//                                      setState(() {
//                                        quantityController.text = value;
//                                      });
//                                    },
                          ),
                        ),

                      ],
                    )
                        : SizedBox(),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Customer Should Pay for Charges?",
                            style: TextStyle(color: blue),
                          ),
                        ),
                        Transform(
                          transform: Matrix4.identity()
                            ..scale(0.5)
                            ..translate(20.0, 20.0),
                          child: CupertinoSwitch(
                            value: payCharges,
                            activeColor: blue,
                            onChanged: (value) {
                              setState(() {
                                payCharges = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),

                    GestureDetector(
                      onTap: () {
                        setState(() {
//                  ticketDetails.add(TicketDetails());
                          showAdvanced = !showAdvanced;
                        });
                      },
                      child: Align(
                        child: Container(
                          width: 240,
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25)),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Show Advanced Options",
                                style: TextStyle(
                                    color: blue,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    // fontFamily: "GoogleSans"
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Center(
                                child: Icon(
                                  showAdvanced
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: blue,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: showAdvanced ? 15 : 30,
                    ),
                    showAdvanced ? advancedOptionsComponent : SizedBox(),

                    CustomButton(
                      text: "Proceed",
                      color: cyan,
                      onPressed: () {
                        if(validateFields()){
                          creatPaymentLink(context);
                        }
                      },
                    ),
                    SizedBox(height: 10)

                  ],
                ),
              ),
              // CustomButton(
              //   text: "Proceed",
              //   color: cyan,
              //   onPressed: () {
              //     if(validateFields()){
              //       creatPaymentLink(context);
              //     }
              //   },
              // ),
              // SizedBox(height: 10)
            ],
          ),
        ),
      ),
    );
  }


  Future _selectDate(context) async {
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

  Future<File> getFile({File file}) async {
  appState.selectingFile = true;
    File  result = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(result != null) {
      File file = File(result.path);
      int sizeInBytes = file.lengthSync();
      
      if(sizeInBytes < 3000000){
        return file;
      }else{
        toast("Files too large, maximum is 5mb");
      }

    } else {
      return null;
    }

  }

  @override
  void afterFirstLayout(BuildContext context) {
     if(paymentLinkState.currencies?.isEmpty || paymentLinkState.currencies == null){
       getCurrency();
     }
  }

  String getRecurringFrequency({selectedRecurringTime}) {
    // daily = 1
    // weekly = 2
    // monthly = 3
    String v = "";
    switch (selectedRecurringTime) {
      case "Daily":
        v = "1";
        break;
      case "Weekly":
        v = "2";
        break;
      case "Monthly":
        v = "3";
        break;
    }
    return v;
  }

  bool validateFields() {
    bool isValidated = true;
    // validate name of link and description
    _formKey.currentState.validate();
    isValidated = isValidated && _formKey.currentState.validate();

    // validate ticketing if enabled
    if (enableTicketing) {
      ticketingComponent.validate();
      isValidated = isValidated && ticketingComponent.validate();
    }

    // validate fixed amount
    if (amountFixed) {
      fixedAmountComponent.validate();
      isValidated = isValidated && fixedAmountComponent.validate();
    }

    // validating quantity
    if (acceptQuantity) {
      _quantityFormKey.currentState.validate();
      isValidated = isValidated && _quantityFormKey.currentState.validate();
    }

    // validating recurring payment
    if (selectedPaymentType == paymentTypes.last) {
      recurringPayment.formKey.currentState.validate();
      isValidated =
          isValidated && recurringPayment.formKey.currentState.validate();
    }

    // validating advanced
    if (showAdvanced) {
      advancedOptionsComponent.validate();
      isValidated = isValidated && advancedOptionsComponent.validate();
    }
    return isValidated;
  }



  creatPaymentLink(context) async{
    if (validateFields()) {
      // amount
      // if fixed amount is enabled
      String defaultAmount = "";
      String defaultCurrency = "NGN";
      List<String> amounts = [];
      List<String> currencies = [];
      if (amountFixed) {
        defaultAmount = fixedAmountComponent
            .defaultAmountDetails.amountController.text
            .trim()
            .replaceAll(",", "");
        defaultCurrency =
            fixedAmountComponent.defaultAmountDetails.selectedCurrency ?? "";
        if (fixedAmountComponent.extraAmountDetails.isNotEmpty) {
          fixedAmountComponent.extraAmountDetails.forEach((extra) {
            amounts.add(extra.amountController.text.trim().replaceAll(",", ""));
            currencies.add(extra.selectedCurrency);
          });
        }
      }

      String customURL = "";
      String linkAfterPayment = "";
      String msgToCustomer = "";
      String notificationEmail;
      List<String> extraInfos;
      if (showAdvanced) {
        extraInfos = [];
        customURL = advancedOptionsComponent.customUrlController.text;
        linkAfterPayment = advancedOptionsComponent.redirectLinkController.text;
        msgToCustomer = advancedOptionsComponent.customerMessageController.text;
        notificationEmail =
            advancedOptionsComponent.notificationEmailController.text;
        if (advancedOptionsComponent.extraInfos.isNotEmpty) {
          advancedOptionsComponent.extraInfos.forEach((info) {
            extraInfos.add(info.fieldController.text);
          });
        }
      }

      // if ticketing is enabled
      String ticketCurrency;
      List<String> ticketCategories;
      List<String> ticketPrices;
      List<String> eventKeys;
      List<String> eventValues;

      if (enableTicketing) {
        ticketCurrency =
        enableTicketing ? ticketingComponent.selectedCurrency : "";
        ticketCategories = [
          ticketingComponent.defaultTicketDetails.ticketNameController.text
        ];
        ticketPrices = [
          ticketingComponent.defaultTicketDetails.priceController.text
        ];
        ticketingComponent.ticketDetails.forEach((ticket) {
          ticketCategories.add(ticket.ticketNameController.text);
          ticketPrices.add(ticket.priceController.text);
        });
        eventKeys = [
          ticketingComponent.defaultEventDetails.eventController.text
        ];
        eventValues = [
          ticketingComponent.defaultEventDetails.detailsController.text
        ];
        ticketingComponent.eventDetails.forEach((event) {
          eventKeys.add(event.eventController.text);
          eventValues.add(event.detailsController.text);
        });
      }

//      print("Ticketing: $ticketCurrency, $ticketCategories, $ticketPrices, $eventKeys, $eventValues");

      showDialog(
          context: this.context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Preloader();
          });

      var result = await paymentLinkState.paymentLink(token: loginState.user.token, business_uuid: businessState.business.business_uuid,
        quantity: quantityController.text,
        show_quantity: acceptQuantity,
        title: linkName.text,
        state: widget.paymentLink != null ? "${widget.paymentLink.id}" : "0",
        description: description.text,
        amount: amountFixed ? fixedAmountComponent.defaultAmountDetails.amountController.text
            .trim()
            .replaceAll(",", "")
            : "",
        currency: amountFixed ? currencyType : "NGN",
        is_fixed: amountFixed,
        accept_number: acceptPhoneNumber,
        event_data: eventValues,
        redirect_url: linkAfterPayment,
         type: selectedPaymentType == paymentTypes.first ? "1" : "2",

      frequency: selectedPaymentType == paymentTypes.last
          ? getRecurringFrequency(
          selectedRecurringTime: recurringPayment.selectedRecurringTime)
          : "",
          frequency_value: selectedPaymentType == paymentTypes.last
              ? recurringPayment.selectedFrequency
              : "",
          payer_bears_fees: chargeCustomer,
          custom_link: customURL,
          custom_message: msgToCustomer,
          image: LogoFile != null ? LogoFile : null,
          ticket_currency: ticketCurrency,
          ticket_data:ticketCategories,
          is_ticket: enableTicketing,

      );
      pop(context);
      if(result["error"] == false){
          setState(() {
            CommonUtils.showAlertDialog(context: context, text: result["message"], onClose: (){
              pop(context);
              pop(context);
            });
          });

      }else{
        CommonUtils.showMsg(scaffoldKey: _scaffoldKey, context: context, snackColor: Colors.red, body: result["message"]);
      }
    print(result);


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
CommonUtils.showMsg(body: res["message"]  ?? 'tt', context: context, scaffoldKey: _scaffoldKey, snackColor : Colors.red);

    }
}
}
