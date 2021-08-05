import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glade_v2/core/models/apiModels/Personal/GoLive/IdcardTypes.dart';
import 'package:glade_v2/provider/Personal/goliveState.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_drop_down.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';
class RegisterYourEnterpriseStage3 extends StatefulWidget {

  Function(Map<String, dynamic> value)onSelected;
  Function(File value)onImage;
  RegisterYourEnterpriseStage3({this.onSelected, this.onImage});
  @override
  _RegisterYourEnterpriseStage3State createState() =>
      _RegisterYourEnterpriseStage3State();
}

class _RegisterYourEnterpriseStage3State
    extends State<RegisterYourEnterpriseStage3>  with AfterLayoutMixin<RegisterYourEnterpriseStage3>{

  String DirectorsName;
  String DirectorsEmail;
  String DirectorsPhone;
  String DirectorsDoB;
  String _startdate;
  bool _datePicked = false;
  IdCardTypes idCardTypes;
  bool isLoading = false;
  GoLIveState goLIveState;
  LoginState loginState;
  String idCardnum;
AppState appState;


  TextEditingController idfileController = TextEditingController();


  File idFile;
  TextEditingController _startController  = TextEditingController();
  DateTime start;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    goLIveState = Provider.of<GoLIveState>(context);
    loginState = Provider.of(context);
    appState = Provider.of(context);
    return Scaffold(

      key: _scaffoldKey,
      body:  Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              // CustomTextField(
              //     validator: (v){
              //       if(v.isEmpty){
              //         return "Field is Required";
              //       }
              //       // DirectorsInfo =  v;
              //       return null;
              //     },
              //     header: "Directors Information"),
              // SizedBox(height: 15),
              CustomTextField(
                  hint: "John Doe",
                  validator: (value) {
                    if(value.trim().isEmpty){
                      return "Name is required";
                    }
                    if(!value.trim().contains(" ")){
                      return "Add space then add the last name";
                    }
                    DirectorsName = value;
                    return null;
                  },
                  header: "Director's Full Name"),
              SizedBox(height: 15),
              CustomTextField(
                type: FieldType.email,
                  hint: "doe@gmail.com",
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return "Email is required";
                    } else if (!EmailValidator.validate(
                        value.replaceAll(" ", "").trim())) {
                      return "Email is invalid";
                    }
                    DirectorsEmail  = value;
                    return null;
                  },
                  header: "Director's Email Address"),
              SizedBox(height: 15),
              CustomTextField(
                  type: FieldType.number,
                  textInputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    new LengthLimitingTextInputFormatter(11),
                  ],
                  validator: (v){
                    if(v.isEmpty){
                      return "Field is Required";
                    }
                    DirectorsPhone =  v;
                    return null;
                  },

                  hint: "08000000000",
                  header: "Director's Phone Number"),
              SizedBox(height: 15),
              CustomTextField(
                  textEditingController: _startController,
                  onTap: (){
                    _selectDate(context);
                  },
                  validator: (v){
                    if(v.isEmpty){
                      return "Field is Required";
                    }

                    return null;
                  },
                  hint: "2021/7/2",
                  header: "Director's Date Of Birth"),
              SizedBox(height: 15),
              CustomDropDown<IdCardTypes>(
                suffix: isLoading ? CupertinoActivityIndicator() : null,
                intialValue: CustomDropDownItem(value: idCardTypes, text: isLoading ? "Loading.." :  "hmm"),

                header: "Select Identity Card Type",

                items: goLIveState.idCardTypes.map((e) {
                  return CustomDropDownItem(
                      text: e.type_name,
                      value: e
                  );
                }).toList(),

                onSelected: (v) {
                  idCardTypes = v;

                },
              ),
              SizedBox(height: 15),
              CustomTextField(

                  validator: (value){


                    if(value.isEmpty){
                      return "Field is required";
                    }
                    idCardnum = value;
                    return null;
                  },
                  hint: "0984383334e",
                  header: "ID Card Number"),
              SizedBox(height: 15),
              CustomTextField(
              //     String DirectorsName;
              // String DirectorsEmail;
              // String DirectorsPhone;
              // String DirectorsDoB;
                  validator: (v){
                    if(v.isEmpty){
                      return "Field is Required";
                    }
                    // 6624
                    widget.onSelected({


                    });
                    widget.onImage(idFile);
                    return null;
                  },
                  textEditingController: idfileController,
                  readOnly: true,
                  onTap: () async {
                    // if (idFile.file == null) {
                    idFile = await getFile();

                    if(idFile != null){
                    setState(() {
                      idfileController.text   =  basename(idFile.path);
                    });
                    }


                  },
                  header: "Upload Identity Card"),
              SizedBox(height: 25),
            ],
          ),
        ),
      )
    );
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
        start = selectedDate;
        _startdate = dateFormat.format(selectedDate);
        _startController.text = _startdate;
        _datePicked = true;
      });
    }
  }



  getDocTypes()async{
    setState(() {
      isLoading = true;
    });
    var result = await goLIveState.getIdCardTypes(token: loginState.user.token);
    setState(() {
      isLoading = false;
    });

    if(result["error"] == false){

    }else{

      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );

    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if(goLIveState.idCardTypes?.isEmpty ||goLIveState.idCardTypes == null ){
      getDocTypes();
    }
  }
}
