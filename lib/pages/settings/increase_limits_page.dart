import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glade_v2/core/models/apiModels/Business/increaseLimit/billsType.dart';
import 'package:glade_v2/core/models/apiModels/Business/increaseLimit/limits.dart';
import 'package:glade_v2/pages/personal/go_live/go_live_personal_page.dart';
import 'package:glade_v2/provider/Business/increaseLimitState.dart';
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
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IncreaseLimitsPage extends StatefulWidget {
  @override
  _IncreaseLimitsPageState createState() => _IncreaseLimitsPageState();
}

class _IncreaseLimitsPageState extends State<IncreaseLimitsPage> with AfterLayoutMixin<IncreaseLimitsPage> {

  Limit limit;
  BillsType billsType;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
IncreaseLimitState increaseLimitState;
LoginState loginState;
AppState appState;
  TextEditingController attachment  = TextEditingController();
  var reason;
bool isBillsLoading = false;
  bool islimitLoading = false;
  FileClass utilityBills = FileClass();
  List<Limit> allLimit = [
    Limit(
      limit_amount: "500",
      limit_name: "First",
      limit_id: "1"

    ),
  Limit(
  limit_amount: "5000",
  limit_name: "Second",
  limit_id: "2"

  ),
  Limit(
  limit_amount: "50000",
  limit_name: "Third",
  limit_id: "3"

  ),

  ];




  List<BillsType> allBills = [
    BillsType(
      type_id: "1",
      type_name: "Nepa"

    ),
    BillsType(
        type_id: "2",
        type_name: "Water"

    ),
    BillsType(
        type_id: "3",
        type_name: "Internet"

    ),

  ];



  double textScale = 1.0;
  void initTextScale() async {
    var pref = await SharedPreferences.getInstance();
    setState(() {
      textScale = pref.getDouble("textScaleFactor") ?? 1.0;
    });
  }

  @override
  void initState() {
    initTextScale();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    increaseLimitState = Provider.of<IncreaseLimitState>(context);
    loginState = Provider.of<LoginState>(context);
    appState = Provider.of<AppState>(context);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: textScale),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 10),
                Header(
                  text: "Increase Limits",
                  preferredActionOnBackPressed: (){

                    pop(context);
                  },
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Form(
                    key: formKey,
                    child: ListView(
                      children: [
                        CustomDropDown<Limit>(
                    suffix: islimitLoading ?  CupertinoActivityIndicator() : null,
                          header: "Select Amount Limit",
                          intialValue: CustomDropDownItem<Limit>(

                              value: limit,
                              text: "Loading..."
                          ),

//                items: increaseLimitState.limitList.map((e){
//                  return CustomDropDownItem(
//                    text: e.limit_name,
//                    value: e
//                  );
//
//            }).toList()



                          items:allLimit.map((e){
                            return CustomDropDownItem<Limit>(
                                text: e.limit_name,
                                value: e

                            );
                          }).toList(),
                          onSelected: (v) {
                            setState(() {
                              limit = v;

                            });
                          },
                        ),

                        SizedBox(height: 15),
                        SizedBox(
                          height: 15,
                        ),
                        CustomDropDown<BillsType>(
                    suffix: isBillsLoading ?  CupertinoActivityIndicator() : null,
                          header: "Select Utility Bills",
                          intialValue: CustomDropDownItem<BillsType>(

                              value: billsType ,
                              text: "Loading..."
                          ),

//                items: increaseLimitState.billsType.map((e){
//                  return CustomDropDownItem(
//                    text: e.type_name,
//                    value: e
//                  );
//
//            }).toList()



                          items:allBills.map((e){
                            return CustomDropDownItem<BillsType>(
                                text: e.type_name,
                                value: e

                            );
                          }).toList(),
                          onSelected: (v) {

                            setState(() {
                              billsType = v;

                            });
                          },
                        ),

                        SizedBox(height: 15),
                        SizedBox(
                          height: 15,
                        ),
                        CustomTextField(
                          textEditingController: attachment,
                          suffix: Icon(Icons.attach_file_outlined, size: 20, color: orange,),
                          onTap: () async {
                            if (utilityBills.file == null) {
                              utilityBills.file = await getFile();
                              setState(() {
                            attachment.text = utilityBills.file.path;
                              });
                            }

                          },
                          validator: (value){
                            if(value.isEmpty){
                              return "Field is required";
                            }
                            return null;
                          },
                          header: "Upload Utility Bill",
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        CustomTextField(

                          validator: (value){
                            if(value.isEmpty){
                              return "Field is required";
                            }
                            reason = value;
                            return null;
                          },
                          header: "Reason for Increase",
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                CustomButton(
                  text: "Apply",
                  onPressed: () {
                    if(formKey.currentState.validate()){
                      apply();

                    }
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    fetchBillTypes();
    fetchLimit();
  }



  apply()async{
    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
   var result = await  increaseLimitState.limit(token: loginState.user.token, limit_id: limit.limit_id, bill_image: attachment.text, bill_type_name: billsType.type_name, reason_for_inncrease: reason);
   Navigator.pop(context);

      if(result["error"] == false ){
          setState(() {
            CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.green );
          });

      }else{
        CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );
      }
  }


  Future<File> getFile({File file}) async {
  appState.selectingFile = true;
//    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path);
      return file;
    } else {
      return null;
    }
  }
  fetchBillTypes()async{

    setState(() {

      isBillsLoading = true;

    });
    var result = await increaseLimitState.getBillTypes(token: loginState.user.token);

    setState(() {
      isBillsLoading = false;

    });
    if(result["error"] == false){
      setState(() {


      });

    }else{
      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey: _scaffoldKey, snackColor: Colors.red );

    }

  }

  fetchLimit()async{

    setState(() {

      islimitLoading = true;

    });
    var result = await increaseLimitState.getLimits(token: loginState.user.token);

    setState(() {
      islimitLoading = false;

    });
    if(result["error"] == false){
      setState(() {


      });

    }else{
      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );

    }

  }
}
