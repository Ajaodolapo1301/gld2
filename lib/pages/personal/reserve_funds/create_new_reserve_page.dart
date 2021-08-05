import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:glade_v2/core/models/apiModels/Personal/ReserveFund/reserve.dart';
import 'package:glade_v2/pages/states/reserve_created.dart';
import 'package:glade_v2/provider/Personal/reserveState.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_drop_down.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateNewReservePage extends StatefulWidget {
  @override
  _CreateNewReservePageState createState() => _CreateNewReservePageState();
}

class _CreateNewReservePageState extends State<CreateNewReservePage> with AfterLayoutMixin<CreateNewReservePage> {
  StashType stashType;
  ReserveState reserveState;
  LoginState loginState;
  AppState appState;
  bool isLoading = false;
  var description;
  String _startdate;
  String _endDate;
  DateTime start;
  bool _datePicked = false;
  var title;
  TextEditingController _startController  = TextEditingController();
  TextEditingController _endDateController  = TextEditingController();
    MoneyMaskedTextController amountController = MoneyMaskedTextController(
      decimalSeparator: ".",  thousandSeparator: ",");

  MoneyMaskedTextController amountControllerAutomatic = MoneyMaskedTextController(
      decimalSeparator: ".",  thousandSeparator: ",");
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);
    reserveState = Provider.of<ReserveState>(context);
    loginState = Provider.of<LoginState>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 10),
              Header(
                text: "Create New Reserve",
              ),
              SizedBox(height: 10),
              Form(
                key: formKey,
                child: Expanded(
                  child: ListView(
                    children: [
                      CustomTextField(
                        header: "Enter Title",
                        hint: "School fees",
                        validator: (v){
                          if(v.isEmpty){
                            return "Field is required";
                          }
                          title = v;
                          return null;

                        },
                      ),
                      SizedBox(height: 15),
                      CustomTextField(

                          validator: (v){
                            if(v.isEmpty){
                              return "Field is required";
                            }
                            description = v;
                            return null;

                          },
                          hint: "Saving for my school fees",
                          header: "Enter Description"),
                      SizedBox(height: 15),
                      CustomTextField(
                        textEditingController: amountController,
                          validator: (v){
                            if(v =="0.00"){
                              return "Amount is required";
                            }
                            return null;

                          },
                          header: "Enter Amount"),
                      SizedBox(height: 15),
                      CustomDropDown<StashType>(
                        intialValue: CustomDropDownItem<StashType>(value:stashType , text: isLoading ? "Loading" : "Select Stash type"),
                        suffix: isLoading ? CupertinoActivityIndicator()  :null ,
                        items: reserveState.stashType.map((e) {
                          return CustomDropDownItem<StashType>(
                              text: e.stash_type_name,
                              value: e
                          );
                        }).toList(),
                        onSelected: (value) {
                          setState(() {
                        stashType   = value ;

                          });
                        },
                        header: "Select Stash type",
                      ),

                      SizedBox(height: 15),
      stashType != null &&  stashType?.stash_type_name  == "Automatic" ?
           Column(
             children: [
               CustomDropDown<String>(
                            intialValue: CustomDropDownItem<String>(value:"" , text: isLoading ? "Loading" : "Select Stash frequency"),
                            suffix: isLoading ? CupertinoActivityIndicator()  :null ,
                            items: [].map((e) {
                              return CustomDropDownItem<String>(
                                  text: e.stash_type_name,
                                  value: e
                              );
                            }).toList(),
                            onSelected: (value) {
                              setState(() {
                                // stashType   = value ;

                              });
                            },
                            header: "Select Stash frequency",
                          ),
               SizedBox(height: 15),
               CustomTextField(
                   textEditingController: amountControllerAutomatic,
                   validator: (v){
                     if(v =="0.00"){
                       return "Amount is required";
                     }
                     return null;

                   },
                   header: "Enter Amount to be deducted Automatically"),
             ],
           ): Container(),
                      SizedBox(height: 15),

                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                  validator: (value){
                                    if(value.isEmpty){
                                      return "Field is required";
                                    }
//                              invoiceTo = value;
                                    return null;

                                  },
                                textEditingController: _startController,
                                  onTap: (){
                                  _selectDate();
                                  },
                                  hint: "2021/7/2",
                                  header: "Start Date"),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: CustomTextField(
                                  validator: (value){
                                    if(value.isEmpty){
                                      return "Field is required";
                                    }

                                    return null;

                                  },
                                textEditingController: _endDateController,
                                  onTap: (){
                                  _EndDate();
                                  },

                                  hint: "2021/12/2",
                                  header: "End Date"),
                            )

                          ],
                        ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              CustomButton(
                text: "Create Stash",
                color: cyan,
                onPressed: () {
                if(formKey.currentState.validate()){
                  CreateReserve();
                }
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
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
          start = selectedDate;
        _startdate = dateFormat.format(selectedDate);
        _startController.text = _startdate;
        _datePicked = true;
      });
    }
  }

  Future _EndDate() async {
    DateTime today = DateTime.now();
    DateTime selectedDate = await showDatePicker(
        context: context,
        initialDate: start,
        firstDate: start,
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
        _endDate= dateFormat.format(selectedDate);
        _endDateController.text = _endDate;
        _datePicked = true;
      });
    }
  }


  fetchStashType()async{
    setState(() {
      isLoading = true;
    });
    var result = await  reserveState.getstashType(token: loginState.user.token);
    setState(() {
      isLoading = false;
    });

    if(result["error"] == false){


    }else{
      CommonUtils.showMsg(body: result["message"]  ?? 'tt', context: context, scaffoldKey: _scaffoldKey,snackColor : Colors.red );

    }
  }

  CreateReserve()async{
    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });

    var result = await  reserveState.CreateReserves(token: loginState.user.token, title: title, description: description, amount: amountController.text.replaceAll(",", "").split(".")[0], stash_type: stashType.stash_type_id, start_date: _startController.text, end_date: _endDateController.text, );
Navigator.pop(context);
    if(result["error"] == false){
    setState(() {
      pushTo(context, ReserveSuccessfulPage());

    });
    }else{
      CommonUtils.showMsg(body: result["message"]  ?? 'tt', context: context, scaffoldKey: _scaffoldKey,snackColor : Colors.red );

    }
  }





  @override
  void afterFirstLayout(BuildContext context) {
  if(reserveState?.stashType.isEmpty || reserveState?.stashType == null){
        fetchStashType();
  }
  }


}
