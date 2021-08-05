import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:glade_v2/core/models/apiModels/Business/PaymentLink/paymentLinkhistory.dart';
import 'package:glade_v2/core/models/apiModels/paymentLink/paymentLink.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/Business/paymentLinkState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/reuseables/form.dart';
import 'package:glade_v2/reuseables/roundedCorner.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_drop_down.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


final Color fillColor = Colors.white;

// ================= Switch ===================


bool validator({List<dynamic> values, List<List<dynamic>> listValues}) {
  bool isValidated = true;
  values.forEach((v) {
    v.formKey.currentState
        .validate(); // doesn't validate everything in values without this
    isValidated = isValidated && v.formKey.currentState.validate();
  });

  listValues.forEach((v) {
    v.forEach((e) {
      e.formKey.currentState.validate();
      isValidated = e.formKey.currentState.validate();
    });
  });

  return isValidated;
}

// ============== Ticketing ==============
class Ticketing extends StatefulWidget {
  // final bool isDark;
  String selectedCurrency = "NGN";
  final TicketDetails defaultTicketDetails = TicketDetails();
  List<TicketDetails> ticketDetails = [];
  var defaultEventDetails = EventDetails();
  List<EventDetails> eventDetails = [];

  // for editing
  // default would be first in the array
  List<EventData> eventDatas;
  List<TicketData> ticketDatas;

  Ticketing({this.ticketDatas, this.eventDatas,});
  // defaultEventDetails
  // eventDetails
  bool validate() {
    return validator(
        values: [defaultTicketDetails, ],
        listValues: [ticketDetails, ]);
  }

  @override
  State<StatefulWidget> createState() {
    defaultEventDetails = EventDetails(
      // isDark: isDark,
    );
    if (ticketDatas != null && eventDatas != null) {
      if (ticketDatas.isNotEmpty || eventDatas.isNotEmpty) {
        defaultTicketDetails.ticketNameController.text =
            ticketDatas.first.ticketName;
        defaultTicketDetails.priceController.text =
            ticketDatas.first.ticketPrice;
        if (ticketDatas.length > 1) {
          for (int i = 1; i < ticketDatas.length; i++) {
            ticketDetails.add(TicketDetails(
              ticketName: ticketDatas[i].ticketName,
              price: ticketDatas[i].ticketPrice,
            ));
          }
        }

        defaultEventDetails.eventController.text =
            eventDatas.first.eventDetails;
        defaultEventDetails.detailsController.text =
            eventDatas.first.valueDetails;
        if (eventDatas.length > 1) {
          for (int i = 1; i < eventDatas.length; i++) {
            eventDetails.add(EventDetails(
              event: eventDatas[i].eventDetails,
              details: eventDatas[i].valueDetails,
            ));
          }
        }
      }
    }

    return _TicketingState();
  }
}

class _TicketingState extends State<Ticketing> {
  List<String> currencies = ["NGN", "USD"];
  // Dimens dimens;

  bool isDark = true;
  PaymentLinkState paymentLinkState;
  LoginState loginState;
  PaymentLinkCurrency currency;
  String currencyType;
  // void initDark() async {
  //   var pref = await SharedPreferences.getInstance();
  //   setState(() {
  //     isDark = pref.getBool("isDark") ?? false;
  //   });
  // }
  //
  // @override
  // void initState() {
  //   initDark();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // dimens = Dimens(context);
    paymentLinkState = Provider.of<PaymentLinkState>(context);
    loginState = Provider.of<LoginState>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      // margin: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: lightBlue,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(


        children: <Widget>[
          // SizedBox(
          //   height: 8,
          // ),
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          //   child: Align(
          //     alignment: Alignment.centerLeft,
          //     child: Text(
          //       "Select Ticket Currency",
          //       style: TextStyle(
          //         fontSize: 15,
          //         fontWeight: FontWeight.w600,
          //         color: blue
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   height: 8,
          // ),
          // CustomDropDown<PaymentLinkCurrency>(
          //
          //   color: Colors.white,
          //               intialValue: CustomDropDownItem(value: currency, text: "Select Currency"),
          //
          //   items: paymentLinkState.currencies.map((e) {
          //
          //     return CustomDropDownItem(
          //       value: e,
          //       text: e.currency
          //     );
          //   }).toList(),
          //   onSelected: (v) {
          //   setState(() {
          //     currencyType = v.symbol;
          //   });
          //   },
          //   header: "Ticket Currency",
          // ),
          // SizedBox(
          //   height: 20,
          // ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Ticket Name/Category & Price",
                style: TextStyle(
                  color:  blue,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          SizedBox(
            height:10,
          ),
//          defaultTicketDetails,
          widget.defaultTicketDetails,
          SizedBox(
            height: 15,
          ),
          widget.ticketDetails.isEmpty
              ? SizedBox()
              : Column(
            children: <Widget>[
              for (int i = 0; i < widget.ticketDetails.length; i++)
                Container(
                  margin: EdgeInsets.only(top: 3),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerRight,
                        child: FlatButton(
                          onPressed: () {
                            setState(() {
                              widget.ticketDetails.removeAt(i);
                            });
                          },
                          child: Text(
                            "DELETE",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      widget.ticketDetails[i]
                    ],
                  ),
                )
            ],
          ),
          SizedBox(
            height: widget.ticketDetails.isEmpty ? 0 : 15,
          ),
          FlatButton.icon(
            onPressed: () {
              setState(() {
                widget.ticketDetails.add(TicketDetails());
              });
            },
            label: Text(
              "Add More Tickets",
              style: TextStyle(
                color: blue,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontFamily: "GoogleSans",
              ),
            ),
            icon: Icon(Icons.add, color: blue),
          ),
          SizedBox(
            height: 15,
          ),
          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          //   child: Align(
          //     alignment: Alignment.centerLeft,
          //     child: Text(
          //       "Event Details",
          //       style: TextStyle(
          //         color: blue,
          //         fontWeight: FontWeight.w600,
          //         fontSize: 15,
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   height: 10,
          // ),
          // widget.defaultEventDetails,
          // SizedBox(
          //   height: 15,
          // ),
          // widget.eventDetails.isEmpty
          //     ? SizedBox()
          //     : Column(
          //   children: <Widget>[
          //     for (int i = 0; i < widget.eventDetails.length; i++)
          //       Container(
          //         margin: EdgeInsets.only(top: 10),
          //         child: Column(
          //           children: <Widget>[
          //             Align(
          //               alignment: Alignment.centerRight,
          //               child: FlatButton(
          //                 onPressed: () {
          //                   setState(() {
          //                     widget.eventDetails.removeAt(i);
          //                   });
          //                 },
          //                 child: Text(
          //                   "DELETE",
          //                   style: TextStyle(
          //                     color: Colors.red,
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //             widget.eventDetails[i]
          //           ],
          //         ),
          //       ),
          //   ],
          // ),
          SizedBox(
            height: widget.eventDetails.isEmpty ? 0 : 15,
          ),
          // FlatButton(
          //   onPressed: () {
          //     setState(() {
          //       widget.eventDetails.add(EventDetails(
          //         // isDark: isDark,
          //       ));
          //     });
          //   },
          //   child: Text(
          //     "Add Event Info",
          //     style: TextStyle(
          //       color: blue,
          //       fontSize: 15,
          //       fontWeight: FontWeight.w500,
          //       fontFamily: "GoogleSans",
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  // showCurrencyOptions() {
  //   showCupertinoModalPopup(
  //       context: context,
  //       builder: (context) {
  //         return RoundConnerBottomSheet(
  //           Container(
  //             height: dimens.height * 0.15,
  //             width: dimens.width,
  //             child: ListView.separated(
  //                 padding: EdgeInsets.symmetric(vertical: 25),
  //                 itemBuilder: (context, i) {
  //                   return GestureDetector(
  //                     onTap: () {
  //                       setState(() {
  //                         widget.selectedCurrency = currencies[i];
  //                       });
  //                       Navigator.pop(context);
  //                     },
  //                     child: Align(
  //                       child: Container(
  //                         width: dimens.width,
  //                         color: Colors.white,
  //                         alignment: Alignment.center,
  //                         child: Text(
  //                           currencies[i],
  //                           style: TextStyle(
  //                               fontSize: 20,
  //                               fontFamily: "GoogleSans",
  //                               color: Colors.black,
  //                               inherit: false),
  //                         ),
  //                       ),
  //                     ),
  //                   );
  //                 },
  //                 separatorBuilder: (context, int) {
  //                   return SizedBox(
  //                     height: 15,
  //                   );
  //                 },
  //                 itemCount: currencies.length),
  //           ),
  //         );
  //       });
  // }
}

class TicketDetails extends StatefulWidget {
  final TextEditingController ticketNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // for editing
  String ticketName;
  String price;

  TicketDetails({this.ticketName, this.price});

  @override
  State<StatefulWidget> createState() {
    if (ticketName != null && price != null) {
      ticketNameController.text = ticketName;
      priceController.text = price;
    }

    return _TicketDetailsState();
  }
}

class _TicketDetailsState extends State<TicketDetails> {
//  final formKey = GlobalKey<FormState>();

  bool isDark = true;

  // void initDark() async {
  //   var pref = await SharedPreferences.getInstance();
  //   setState(() {
  //     isDark = pref.getBool("isDark") ?? false;
  //   });
  // }

  @override
  void initState() {
    // initDark();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: isDark ? Color(0xff121416) : textFieldBackgroundColor,
      child: Column(
        children: <Widget>[
          Form(
            key: widget.formKey,
            child: Column(
              children: <Widget>[
                CustomTextField(
                  // color: Colors.white,
                  color: Colors.white,
                  header: "Ticket Name eg. VIP Tickets",
                  hint: "Football Afrique",
                  onChanged: (value) {
                    setState(() {
                      widget.ticketNameController.text = value;
                    });
                  },
                  validator: (v) {
                    if (v.isEmpty) {
                      return ("Ticket name required");
                    }
                    return null;
                  },
                ),
//                    TextFormField(
//                      controller: widget.ticketNameController,
//                      validator: (v) {
//                        if (v.isEmpty) {
//                          return ("Ticket name required");
//                        }
//                        return null;
//                      },
//                      style: TextStyle(fontSize: 15, fontFamily: "GoogleSans"),
//                      decoration: InputDecoration(
//                          hintText: 'Ticket Name eg VIP Tickets',
//                          fillColor: fillColor,
//                          filled: true,
//                          border: FormBorder(
//                              cut: 0,
//                              borderRadius: BorderRadius.circular(25.0)),
//                          contentPadding: EdgeInsets.all(9),
//                          errorStyle: TextStyle(fontFamily: "GoogleSans")),
//                    ),
              SizedBox(height: 10,),

                CustomTextField(
                  color: Colors.white,
                  header: "Ticket Price",
                  hint: "1500",
                  // color: Colors.white,
                  onChanged: (value) {
                    setState(() {
                      widget.priceController.text = value;
                    });
                  },
                  validator: (v) {
                    if (v.isEmpty) {
                      return ("Ticket name required");
                    }
                    return null;
                  },
                  type: FieldType.phone,
                ),
//                    TextFormField(
//                      controller: widget.priceController,
//                      validator: (v) {
//                        if (v.isEmpty) {
//                          return ("Ticket Price required");
//                        }
//                        return null;
//                      },
//                      keyboardType: TextInputType.number,
//                      style: TextStyle(fontSize: 15, fontFamily: "GoogleSans"),
//                      decoration: InputDecoration(
//                          hintText: 'Ticket Price',
////                  fillColor: HexColor('#F7F7F7'),
//                          fillColor: fillColor,
//                          filled: true,
//                          border: FormBorder(
//                              cut: 0,
//                              borderRadius: BorderRadius.circular(25.0)),
//                          contentPadding: EdgeInsets.all(9),
//                          errorStyle: TextStyle(fontFamily: "GoogleSans")),
//                    ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class EventDetails extends StatefulWidget {
  // final bool isDark;
  final TextEditingController eventController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  // for editing
  String event;
  String details;

  EventDetails({this.event, this.details, });

  final formKey = GlobalKey<FormState>();

  @override
  State<StatefulWidget> createState() {
    if (event != null && details != null) {
      eventController.text = event;
      detailsController.text = details;
    }

    return _EventDetilasState();
  }
}

class _EventDetilasState extends State<EventDetails> {
  // void initDark() async {
  //   var pref = await SharedPreferences.getInstance();
  //   setState(() {
  //     isDark = pref.getBool("isDark") ?? false;
  //   });
  // }

  bool isDark = true;

  @override
  void initState() {
    // initDark();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: isDark ? Color(0xff121416) : textFieldBackgroundColor,
        child: Form(
          key: widget.formKey,
          child: Column(
            children: <Widget>[
              CustomTextField(
                color: Colors.white,
                header: "Venue",
                hint: 'Venue',
                // color: Colors.white,
                validator: (v) {
                  if (v.isEmpty) {
                    return ("Venue required");
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    widget.eventController.text = value;
                  });
                },
              ),
              SizedBox(height: 10,),
              CustomTextField(
                color: Colors.white,
                header: "Details",
                hint: 'Details',
                // color: Colors.white,
                validator: (v) {
                  if (v.isEmpty) {
                    return ("Details required");
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    widget.detailsController.text = value;
                  });
                },
              ),

//              TextFormField(
//                controller: widget.eventController,
//                validator: (v) {
//                  if (v.isEmpty) {
//                    return ("Venue required");
//                  }
//                  return null;
//                },
//                style: TextStyle(fontSize: 15, fontFamily: "GoogleSans"),
//                decoration: InputDecoration(
//                    hintText: 'Venue',
//                    fillColor: fillColor,
//                    filled: true,
//                    border: FormBorder(
//                        cut: 0, borderRadius: BorderRadius.circular(25.0)),
//                    contentPadding: EdgeInsets.all(9),
//                    errorStyle: TextStyle(fontFamily: "GoogleSans")),
//              ),
//              TextFormField(
//                controller: widget.detailsController,
//                validator: (v) {
//                  if (v.isEmpty) {
//                    return ("Details required");
//                  }
//                  return null;
//                },
//                style: TextStyle(fontSize: 15, fontFamily: "GoogleSans"),
//                decoration: InputDecoration(
//                    hintText: 'Details',
////                  fillColor: HexColor('#F7F7F7'),
//                    fillColor: fillColor,
//                    filled: true,
//                    border: FormBorder(
//                        cut: 0, borderRadius: BorderRadius.circular(25.0)),
//                    contentPadding: EdgeInsets.all(9),
//                    errorStyle: TextStyle(fontFamily: "GoogleSans")),
//              ),
            ],
          ),
        ));
  }
}

// ======================= Fixed Amount =======================
class FixedAmount extends StatefulWidget {
  final FixedAmountDetails defaultAmountDetails = FixedAmountDetails();
  List<FixedAmountDetails> extraAmountDetails = [];

  bool validate() {
    return validator(
        values: [defaultAmountDetails], listValues: [extraAmountDetails]);
  }

//  // editing
  List<String> extraCurrency;
  List<String> extraAmount;

  @override
  State<StatefulWidget> createState() {
    if (extraCurrency != null &&
        extraAmount != null &&
        extraCurrency.isNotEmpty &&
        extraAmount.isNotEmpty) {
      for (int i = 0; i < extraAmount.length; i++) {
        if (extraAmount[i].length > 1 && extraCurrency[i].length > 1) {
          extraAmountDetails.add(FixedAmountDetails(
            amount: extraAmount[i],
            selectedCurrency: extraCurrency[i],
          ));
        }
      }
    }

    return _FixedAmountState();
  }
}

class _FixedAmountState extends State<FixedAmount> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: lightBlue,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: Text(
          //     "Choose Currency & Amount:",
          //     style: TextStyle(
          //       fontSize: 15,
          //       fontWeight: FontWeight.bold,
          //       color: headerColor,
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 10,
          ),
          widget.defaultAmountDetails,
          SizedBox(
            height: 15,
          ),
          widget.extraAmountDetails.isEmpty
              ? SizedBox()
              : Column(
            children: <Widget>[
              for (int i = 0; i < widget.extraAmountDetails.length; i++)
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.extraAmountDetails.removeAt(i);
                            });
                          },
                          child: Text(
                            "DELETE",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      widget.extraAmountDetails[i]
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(
            height: widget.extraAmountDetails.isEmpty ? 0 : 15,
          ),
          // FlatButton(
          //   color: cyan,
          //   onPressed: () {
          //     setState(() {
          //       widget.extraAmountDetails.add(FixedAmountDetails());
          //     });
          //   },
          //   shape:
          //   RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          //   child: Text(
          //     "Add Multiple Amount",
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontSize: 15,
          //       fontWeight: FontWeight.w500,
          //       // fontFamily: "GoogleSans",
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class FixedAmountDetails extends StatefulWidget {
  MoneyMaskedTextController amountController =
  MoneyMaskedTextController(decimalSeparator: ".", thousandSeparator: ",");
  String selectedCurrency;
PaymentLinkCurrency paymentLinkCurrency;
  FixedAmountDetails({String amount, this.selectedCurrency, this.paymentLinkCurrency}) {
    if (amount != null) {
      amountController.text = "$amount";
    }
  }

  final formKey = GlobalKey<FormState>();

  @override
  State<StatefulWidget> createState() {
    return _FixedAmountDetailsState();
  }
}

class _FixedAmountDetailsState extends State<FixedAmountDetails> {
  // List<String> currencies = ["NGN", "USD"];
  // Dimens dimens;

  @override
  void initState() {
    super.initState();
    if (widget.selectedCurrency == null) {
      // widget.selectedCurrency = currencies.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    // dimens = Dimens(context);

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // GestureDetector(
          //   onTap: () {
          //     showCurrencyOptions();
          //   },
          //   child: Container(
          //     height: 50,
          //     width: 80,
          //     decoration: BoxDecoration(
          //         color: fillColor, borderRadius: BorderRadius.circular(25)),
          //     padding: EdgeInsets.all(9),
          //     child: Align(
          //       alignment: Alignment.center,
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: <Widget>[
          //           Text(
          //             widget.selectedCurrency,
          //             style: TextStyle(fontSize: 15, fontFamily: "GoogleSans"),
          //           ),
          //           Icon(
          //             Icons.arrow_drop_down,
          //             color: orange,
          //           )
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   width: 15,
          // ),
          Expanded(
            child: Form(
              key: widget.formKey,
              child: CustomTextField(
                // prefix: Text(currencyType ?? "", style: TextStyle(color:blue),),
                textEditingController: widget.amountController,
                validator: (v){
                  if(v.isEmpty || v == "0.00"){
                    return "Amount is required";

                  }
                  return null;
                },
                header: "Enter Amount",
                hint: "Enter Amount eg ₦5,000",
                // outerSuffix: Container(
                //   padding:
                //       EdgeInsets.symmetric(vertical: 12.5, horizontal: 15),
                //   decoration: BoxDecoration(
                //     color: lightBlue,
                //     border: Border.all(
                //       color: borderBlue.withOpacity(0.5),
                //     ),
                //     borderRadius: BorderRadius.only(
                //       topRight: Radius.circular(8),
                //       bottomRight: Radius.circular(8),
                //     ),
                //   ),
                //   child: Row(
                //     children: [
                //       Text(
                //         "NGN",
                //         style: TextStyle(color: blue, fontSize: 12),
                //       ),
                //       SizedBox(width: 3),
                //       Icon(
                //         Icons.keyboard_arrow_down_rounded,
                //         color: orange,
                //       ),
                //     ],
                //   ),
                // ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // showCurrencyOptions() {
  //   showCupertinoModalPopup(
  //       context: context,
  //       builder: (context) {
  //         return RoundConnerBottomSheet(
  //           Container(
  //             height: 100,
  //             width: double.infinity,
  //             // height: dimens.height * 0.15,
  //             // width: dimens.width,
  //             child: ListView.separated(
  //                 padding: EdgeInsets.symmetric(vertical: 25),
  //                 itemBuilder: (context, i) {
  //                   return GestureDetector(
  //                     onTap: () {
  //                       setState(() {
  //                         widget.selectedCurrency = currencies[i];
  //                       });
  //                       Navigator.pop(context);
  //                     },
  //                     child: Align(
  //                       child: Container(
  //                         // width: dimens.width,
  //                         color: Colors.white,
  //                         alignment: Alignment.center,
  //                         child: Text(
  //                           currencies[i],
  //                           style: TextStyle(
  //                               fontSize: 20,
  //                               fontFamily: "GoogleSans",
  //                               color: Colors.black,
  //                               inherit: false),
  //                         ),
  //                       ),
  //                     ),
  //                   );
  //                 },
  //                 separatorBuilder: (context, int) {
  //                   return SizedBox(
  //                     height: 15,
  //                   );
  //                 },
  //                 itemCount: currencies.length),
  //           ),
  //         );
  //       });
  // }
}

// ========================== Quantity =======================

class Quantity extends StatefulWidget {
  final TextEditingController quantityController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool validate() {
    return formKey.currentState.validate();
  }

  @override
  State<StatefulWidget> createState() {
    quantityController.text = "1";
    return _QuantityState();
  }
}

class _QuantityState extends State<Quantity> {
  @override
  void initState() {
    super.initState();
//    widget.quantityController.text = "1";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Enter the maximum number of quantity for this link.",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Form(
            key: widget.formKey,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: TextFormField(
                controller: widget.quantityController,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v.isEmpty) {
                    return ("Quantity required");
                  }
                  return null;
                },
                style: TextStyle(fontSize: 15, fontFamily: "GoogleSans"),
                decoration: InputDecoration(
                    hintText: 'Quantity',
                    fillColor: fillColor,
                    filled: true,
                    border: FormBorder(
                        cut: 0, borderRadius: BorderRadius.circular(25.0)),
                    contentPadding: EdgeInsets.all(9),
                    errorStyle: TextStyle(fontFamily: "GoogleSans")),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================== Recurring Payment ================
class RecurringPayment extends StatefulWidget {
  String selectedRecurringTime;
  String selectedFrequency;
  final formKey = GlobalKey<FormState>();

  @override
  State<StatefulWidget> createState() {
    return _RecurringPaymentState();
  }
}

class _RecurringPaymentState extends State<RecurringPayment> {
  List<String> recurringTimes = ["Daily", "Weekly", "Monthly"];
  List<int> dailyFrequency = List.generate(25, (index) => index, growable: false);
  List<int> weeklyFreqyency =
  List.generate(7, (index) => index + 1, growable: false);
  List<int> monthlyFrequency =
  List.generate(30, (index) => index + 1, growable: false);
  List<int> frequency = [];
  int selectedFrequency;

  @override
  void initState() {
    super.initState();
    if (widget.selectedRecurringTime != null) {
      selectedFrequency = int.parse(widget.selectedFrequency);
      triggerFrequency(
          v: "${widget.selectedRecurringTime[0].toUpperCase()}${widget.selectedRecurringTime.substring(1)}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: CustomDropDown<String>(
              intialValue: CustomDropDownItem(value:  widget.selectedRecurringTime, text: "Select Recurring  time"),

              items: recurringTimes.map((e) {

                return CustomDropDownItem(
                    value: e,
                    text: e
                );
              }).toList(),
              onSelected: (v) {
                setState(() {
                  widget.selectedRecurringTime = v;
                  triggerFrequency(v: v);
                });
              },
              header: "Select Recurring time",
            ),
          ),
          SizedBox(width: 10,),
          Expanded(
            child: CustomDropDown<int>(
              intialValue: CustomDropDownItem<int>(value: 0 ,  text: "Select frequency"),

              items: frequency.map((e) {

                return CustomDropDownItem<int>(
                    value: e,
                    text: e.toString()
                );
              }).toList(),
              onSelected: (v) {
                setState(() {
                  widget.selectedFrequency = v.toString();
                });
              },
              header: "Select Payment type",
            ),
          ),
//           Column(
//             children: <Widget>[
//               Text(
//                 "Select Frequency",
//                 style: TextStyle(
//                   fontSize: 15,
//                   color: headerColor,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Container(
//                 width: 160,
// //                height: 40,
//                 padding: EdgeInsets.all(8),
//                 margin: EdgeInsets.only(top: 5),
//                 decoration: BoxDecoration(
// //                    color: Colors.grey.withOpacity(0.06),
//                     color: fillColor,
//                     borderRadius: BorderRadius.circular(16)),
//                 child: DropdownButtonFormField(
//                   hint: Text("Select an Option"),
//                   value: selectedFrequency,
//                   isExpanded: true,
//                   validator: (v) {
//                     if (v == null) {
//                       return "Select Frequency";
//                     }
//                     return null;
//                   },
//                   items: frequency.map((int value) {
//                     return DropdownMenuItem<int>(
//                       value: value,
//                       child: Text("$value"),
//                     );
//                   }).toList(),
//                   onChanged: (v) {
//                     setState(() {
//                       selectedFrequency = v;
//                       widget.selectedFrequency = "$v";
//                       WidgetsBinding.instance.focusManager.primaryFocus
//                           ?.unfocus();
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
        ],
      ),
    );
  }

  void triggerFrequency({String v}) {
    setState(() {
      switch (v) {
        case "Daily":
          frequency = dailyFrequency;
          break;
        case "Weekly":
          frequency = weeklyFreqyency;
          break;
        case "Monthly":
          frequency = monthlyFrequency;
          break;
      }
    });
  }
}

// ================== Advanced Options ====================
class AdvancedOptions extends StatefulWidget {
  final TextEditingController customUrlController = TextEditingController();
  final TextEditingController redirectLinkController = TextEditingController();
  final TextEditingController customerMessageController =

  TextEditingController();

  TextEditingController linkurl = TextEditingController();
  final TextEditingController notificationEmailController =
  TextEditingController();
  List<ExtraInfo> extraInfos = [];

//  _AdvancedOptionsState advancedOptionsState = _AdvancedOptionsState();
  final formKey = GlobalKey<FormState>();

  bool validate() {
    return validator(values: [this], listValues: [extraInfos]);
  }

  @override
  State<StatefulWidget> createState() {
    return _AdvancedOptionsState();
  }
}

class _AdvancedOptionsState extends State<AdvancedOptions> {
  bool collectMoreInfo = false;
  PaymentLinkState paymentLinkState;
  bool       isUrlLoading = false;
  LoginState loginState;
  BusinessState businessState;
  Timer _debounce;
  bool linkUrlIsGood ;

  _onSearchChanged(String query) {
    print(query);
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if(query.isNotEmpty){
        getUrl(query);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    paymentLinkState = Provider.of<PaymentLinkState>(context);
    businessState = Provider.of<BusinessState>(context);
    loginState = Provider.of<LoginState>(context);
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
      child: Form(
//        key: formKey,
        key: widget.formKey,
        child: Column(
          children: <Widget>[
            SizedBox(height: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(

                  header: "Enter payment link URL",
                  hint: "https://pay.gladepay.com/@",
                  readOnly: true,
                  outerSuffix: Expanded(
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 17),
                      decoration: BoxDecoration(
                        color: lightBlue,
                        border: Border.all(
                          color: borderBlue.withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(

                              onChanged: _onSearchChanged,
                              controller: widget.linkurl,
                              decoration: InputDecoration.collapsed(hintText: ""),
                              style: TextStyle(
                                color: blue,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                linkUrlIsGood == null || widget.linkurl.text.isEmpty  ? SizedBox() :         Text(linkUrlIsGood ? "Link is available, carry on" : "Link is Unavailable, Pick another", style: TextStyle(color: linkUrlIsGood ? Colors.green : Colors.red , fontSize: 9),)
              ],
            ),

      SizedBox(height: 10,),
//            TextFormField(
//              controller: widget.customUrlController,
//              validator: (v) {
//                if (v.isEmpty) {
//                  return "Please enter a valid URL";
//                }
//                return null;
//              },
//              style: TextStyle(fontSize: 15, fontFamily: "GoogleSans"),
//              decoration: InputDecoration(
//                  hintText: 'Enter your custom URL',
//                  fillColor: fillColor,
//                  filled: true,
//                  border: FormBorder(
//                      cut: 0, borderRadius: BorderRadius.circular(25.0)),
//                  contentPadding: EdgeInsets.all(9),
//                  errorStyle: TextStyle(fontFamily: "GoogleSans")),
//            ),
            Center(
//              child: Text("https://pay.gladepay.com/${widget.customUrlController.text.isEmpty ? "enter_custom_link" : widget.customUrlController.text}"),
              child: Linkify(
                onOpen: (link) async {
                  if (await canLaunch(link.url)) {
                    await launch(link.url);
                  }
                },
                text:
                "https://pay.gladepay.com/${widget.linkurl.text.isEmpty ? "enter_custom_link" : widget.linkurl.text}",
              ),
            ),
            SizedBox(height: 10,),
            CustomTextField(
              header: "Redirect Link",
              hint: "Redirect Link ad",
              validator: (v) {
                if (v.isEmpty) {
                  return "Please enter a valid URL";
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  widget.redirectLinkController.text = value;
                });
              },
            ),
//            TextFormField(
//              controller: widget.redirectLinkController,
//              validator: (v) {
//                if (v.isEmpty) {
//                  return "Please enter a valid URL";
//                }
//                return null;
//              },
//              style: TextStyle(fontSize: 15, fontFamily: "GoogleSans"),
//              decoration: InputDecoration(
//                  hintText: 'Redirect Link After Payment',
//                  fillColor: fillColor,
//                  filled: true,
//                  border: FormBorder(
//                      cut: 0, borderRadius: BorderRadius.circular(25.0)),
//                  contentPadding: EdgeInsets.all(9),
//                  errorStyle: TextStyle(fontFamily: "GoogleSans")),
//            ),
            SizedBox(
              height: 10,
            ),
            CustomTextField(
              hint: "Message to customer",
              header: "Message",
              validator: (v) {
                if (v.isEmpty) {
                  return "Please enter a message";
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  widget.customerMessageController.text = value;
                });
              },
            ),
//            TextFormField(
//              controller: widget.customerMessageController,
//              validator: (v) {
//                if (v.isEmpty) {
//                  return "Please enter a message";
//                }
//                return null;
//              },
//              style: TextStyle(fontSize: 15, fontFamily: "GoogleSans"),
//              decoration: InputDecoration(
//                  hintText: 'Messaage to Customer',
//                  fillColor: fillColor,
//                  filled: true,
//                  border: FormBorder(
//                      cut: 0, borderRadius: BorderRadius.circular(25.0)),
//                  contentPadding: EdgeInsets.all(9),
//                  errorStyle: TextStyle(fontFamily: "GoogleSans")),
//            ),
//            SizedBox(
//              height: 6,
//            ),
//            TextFormField(
//              controller: widget.notificationEmailController,
//              validator: (v) {
//                if (v.isEmpty) {
//                  return "Email required";
//                } else if (!EmailValidator.validate(v)) {
//                  return "Enter a valid email.";
//                }
//                return null;
//              },
//              style: TextStyle(fontSize: 15, fontFamily: "GoogleSans"),
//              decoration: InputDecoration(
//                  hintText: 'Notification Email',
//                  fillColor: fillColor,
//                  filled: true,
//                  border: FormBorder(
//                      cut: 0, borderRadius: BorderRadius.circular(25.0)),
//                  contentPadding: EdgeInsets.all(9),
//                  errorStyle: TextStyle(fontFamily: "GoogleSans")),
//            ),
//            SizedBox(
//              height: 12,
//            ),
            SizedBox(height: 10,),
            Center(
              child: Text(
                "Collect More User Info",
                style: TextStyle(
                  color: blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            // SizedBox(height: 10,),
            widget.extraInfos.isEmpty
                ? SizedBox()
                : Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                for (int i = 0; i < widget.extraInfos.length; i++)
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25)),
                    margin: EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: widget.extraInfos[i],
                        ),
                        Center(
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                widget.extraInfos.removeAt(i);
                              });
                            },
                            icon: Icon(Icons.close, color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                  )
              ],
            ),
            SizedBox(height: 10),
            FlatButton(
              onPressed: () {
                setState(() {
                  collectMoreInfo = !collectMoreInfo;
                  widget.extraInfos.add(ExtraInfo());
                });
              },
              child: Text(
                "Add Extra Field",
                style: TextStyle(
                  color: blue,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontFamily: "GoogleSans",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  void getUrl(v)async{
    setState(() {
      isUrlLoading = true;
    });
    var res  = await paymentLinkState.getAvailableLink(token:loginState.user.token, business_uuid: businessState.business.business_uuid, link:v );
    setState(() {
      isUrlLoading = false;
    });
    if(res["message"] == false){
      setState(() {
        linkUrlIsGood = true;
      });
      // showSimpleNotification(
      //     Text("Link is availablee, Carry on"),
      //
      //     background: Colors.green);
    }else{
      setState(() {
        linkUrlIsGood = false;
      });
      // showSimpleNotification(
      //     Text("Link already Exist, Choose another"),
      //     background: Colors.red);
    }
  }
}

class ExtraInfo extends StatefulWidget {
  TextEditingController fieldController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  State<StatefulWidget> createState() {
    return _ExtraInfoState();
  }
}

class _ExtraInfoState extends State<ExtraInfo> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
        child: TextFormField(
          controller: widget.fieldController,
          validator: (v) {
            if (v.isEmpty) {
              return "Please enter a field";
            }
            return null;
          },
          style: TextStyle(fontSize: 15, fontFamily: "GoogleSans"),
          decoration: InputDecoration(
              hintText: 'Name of field e.g. Address',
              fillColor: fillColor,
              filled: true,
              border:
              FormBorder(cut: 0, borderRadius: BorderRadius.circular(25.0)),
              contentPadding: EdgeInsets.all(9),
              errorStyle: TextStyle(fontFamily: "GoogleSans")),
        ),
      ),
    );
  }
}
