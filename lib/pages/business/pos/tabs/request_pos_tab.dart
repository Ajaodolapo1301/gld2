import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glade_v2/core/models/apiModels/Personal/GoLive/StateAndLGA.dart';
import 'package:glade_v2/core/models/apiModels/Personal/POS/pos.dart';
import 'package:glade_v2/pages/dashboard/dashboard_page.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/Personal/goliveState.dart';
import 'package:glade_v2/provider/Personal/posState.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_drop_down.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:provider/provider.dart';

class RequestPOSTab extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldKey;
  RequestPOSTab({this.scaffoldKey});
  @override
  _RequestPOSTabState createState() => _RequestPOSTabState();
}

class _RequestPOSTabState extends State<RequestPOSTab>  with AfterLayoutMixin<RequestPOSTab>{

  POSState posState;
  LoginState loginState;

  AppState  appState;
  String lga;
  Revenue revenue;
  BusinessState businessState;
bool  isLGALoading = false;
  Sales sales;
  String quantity;
  States states;
bool isStateLoading = false;
GoLIveState goLIveState;
  var revenueAmount;
  var salesRange;
  var deliveryAddress;

  bool salesLoading = false;
  bool revenueLoading = false;
  var additionalNote;
  // final List<Revenue> monthlyRevenueOpts = [
  //   Revenue(
  //     revenue_amount:    "NGN 300,000 - NGN 500,000",
  //     revenue_id: "1"
  //   ),
  //   Revenue(
  //       revenue_amount:        "NGN 500,000 - NGN 700,000",
  //       revenue_id: "2"
  //   ),
  //   Revenue(
  //       revenue_amount:    "NGN 700,000 - NGN 1,000,000",
  //       revenue_id: "3"
  //   ),
  //
  //   Revenue(
  //       revenue_amount:    "Above NGN 1,000,000",
  //       revenue_id: "4"
  //   )
  //
  // ];


  String selectedMonthlyRevenue;



  LGA lga_id;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    businessState = Provider.of<BusinessState>(context);
    posState = Provider.of<POSState>(context);
    loginState = Provider.of<LoginState>(context);
    appState = Provider.of<AppState>(context);
    goLIveState = Provider.of(context);
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  CustomDropDown<Revenue>(

                                intialValue: CustomDropDownItem(value: revenue, text: "Select revenue"),
                    suffix: revenueLoading ? CupertinoActivityIndicator() : null,

                   items: posState.revenue.map((e){
                     return  CustomDropDownItem(
                         value: e, text: e.revenue_amount);
                   }).toList(),
                    onSelected: (item) {
                      revenue = item;
                    },
                    header: "What is your Average Monthly Revenue?",
                  ),
                  SizedBox(height: 15),
                  CustomDropDown<Sales>(
                                intialValue: CustomDropDownItem(value: sales, text: "Select sales"),

                  suffix: salesLoading ? CupertinoActivityIndicator() : null,
                                     items:posState.sales.map((e){
                     return  CustomDropDownItem(
                         value: e, text: e.sales_range);
                   }).toList(),

                    onSelected: (item) {
                setState(() {
                  sales = item;
                });

                    },
                    header: "How Many Sales do you Maker per Day?",
                  ),
                  SizedBox(height: 15),
                  CustomDropDown<String>(
                    intialValue: CustomDropDownItem(value: "Quantity", text: "Select Quantity "),

                    items:['1','2', '3', '4', '5'].map((e){
                      return  CustomDropDownItem(
                          value: e, text: e);
                    }).toList(),

                    onSelected: (item) {
                      setState(() {
                        quantity = item;
                      });

                    },
                    header: "How Many Terminals do you need?",
                  ),

                  SizedBox(height: 15),
                  CustomTextField(
                    hint: "Enter your address",
                    validator: (value){
                      if(value.isEmpty){
                        return "Field is required";
                      }
                      deliveryAddress = value;
                      return null;

                    },
                    header: "What Address Should we Deliver the POS to?",
                  ),
                  SizedBox(height: 15),


                  CustomDropDown<States>(
                                intialValue: CustomDropDownItem(value: states, text: "Select States"),


                    items: goLIveState.states.map((e) {
                      return CustomDropDownItem(
                        text: e.state_name ,
                        value: e
                      );
                    }).toList(),
                    onSelected: (item) {
                        setState(() {

                          states = item;
                          if(states != null) {
                            getLGA(states?.state_id);
                          }

                          // lgas = nigeriaLocalGovernmentAreas[item];
                        });
                    },
                    header: "Select State",
                  ),
                  SizedBox(height: 15),
                  CustomDropDown<LGA>(
                                intialValue: CustomDropDownItem(value: lga , text: "Select LGA"),

//                                  items: posState.lga.map((e){
//                    return  CustomDropDownItem(
//                        value: e, text: e.revenue_amount);
//                  }).toList(),


                    items: goLIveState.lga == null ? [] : goLIveState.lga.map((e) {
                      return CustomDropDownItem(
                          text: e.city_name ,
                          value: e
                      );
                    }).toList(),
                    onSelected: (item) {
                    setState(() {
                      lga_id = item;
                    });
                    // print(lga_id.id);
                    },
                    header: "Select LGA",
                  ),




                  SizedBox(height: 15),
                  CustomTextField(
                    hint: "Any Comment?",
                    validator: (value){
                      if(value.isEmpty){
                        return "Field is required";
                      }
                      additionalNote = value;
                      return null;

                    },
                    header: "Additional Note",
                  ),
                  SizedBox(height: 40),

                  CustomButton(
                    text: "Submit",
                    onPressed: () {
                      if(_formKey.currentState.validate()) {
                        applyForPos();
                      }
                      // print(pi/4);
                    },
                    color: cyan,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          //   CustomButton(
          //     text: "Submit",
          //     onPressed: () {
          //       if(_formKey.currentState.validate()) {
          //         applyForPos();
          //       }
          // // print(pi/4);
          //     },
          //     color: cyan,
          //   ),
          //   SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
//    if (posState?.revenue.isEmpty || posState?.revenue == null) {
 getMonthlyRevenue();
//    }

  getSales();
  getState();

  }

  getLGA(state)async{
    print("call LGA");
    setState(() {
      isLGALoading = true;
    });
    var result = await goLIveState.getLGAs(token: loginState.user.token, country_id: "NG", state_id: state.toString(), );
    setState(() {
      isLGALoading = false;
    });

    if(result["error"] == false){

    }else{

      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:widget.scaffoldKey, snackColor: Colors.red );

    }
  }

  getMonthlyRevenue() async{
    setState(() {
     revenueLoading = true;
    });

    var result = await posState.getRevenue(token: loginState.user.token);

    setState(() {
      revenueLoading = false;
    });

    if(result["error"] == false){
      setState(() {
      });
    }else{
      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:widget.scaffoldKey, snackColor: Colors.red );
    }
  }






  getSales() async{
    setState(() {
      salesLoading = true;
    });
    var result = await posState.getSales(token: loginState.user.token);
    setState(() {
      salesLoading = false;
    });
    if(result["error"] == false){
      setState(() {
      });
    }else{
      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:widget.scaffoldKey, snackColor: Colors.red );
    }
  }



  getState()async{
    print("call state");
    setState(() {
      isStateLoading = true;
    });
    var result = await goLIveState.getStates(token: loginState.user.token, country_id: "NG");
    setState(() {
      isStateLoading = false;
    });

    if(result["error"] == false){

    }else{

      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:widget.scaffoldKey, snackColor: Colors.red );

    }
  }


  // getLGa() async{
  //   var result = await posState.getLGAs(token: loginState.user.token,state_id: states.state_name );
  //   if(result["error"] == false){
  //     setState(() {
  //     });
  //   }else{
  //     CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:widget.scaffoldKey, snackColor: Colors.red );
  //   }
  // }

  applyForPos()async{
    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result =  await posState.POS(token: loginState.user.token, revenue_id: revenue.revenue_id , sales_id: sales.sales_id, state: states.state_id , delivery_address: deliveryAddress,additional_note: additionalNote, lga: lga_id.id, quantity: quantity, business_uuid: businessState?.business?.business_uuid  ?? "", isPersonal: appState.isPersonal);
    Navigator.pop(context);
    if(result["error"] == false){
      CommonUtils.showAlertDialog(context: context, text: result["message"], onClose: () async{
        pushToAndClearStack(context, DashboardPage());
      });
    }else{
      CommonUtils.showMsg(body:result["message"]?? "ff", context: context, scaffoldKey:widget.scaffoldKey, snackColor: Colors.red );
    }
  }


}
