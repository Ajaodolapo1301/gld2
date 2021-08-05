import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glade_v2/pages/dashboard/dashboard_page.dart';
import 'package:glade_v2/pages/personal/go_live/go_live_personal_page.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/reuseables/dialogPopup.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_drop_down.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddABusinessAccountStage2 extends StatefulWidget {
  GlobalKey<FormState> formKey;
  final Function(Map<String, dynamic>)onAddCompliancePayload;
  AddABusinessAccountStage2({this.formKey, this.onAddCompliancePayload});

  @override
  _AddABusinessAccountStage2State createState() => _AddABusinessAccountStage2State();
}

class _AddABusinessAccountStage2State extends State<AddABusinessAccountStage2> with AfterLayoutMixin<AddABusinessAccountStage2> {

  var regBusinessNaame;
  // var tinNumber;
  var rcOrBC;
  String utilityType;
  bool isbusinessyUtility = false;

var business_uuid;

  BusinessState addBusnessState;

  LoginState loginState;

  AppState appState;
  FileClass cacFile = FileClass();
  TextEditingController cacFileEditor = TextEditingController();
  TextEditingController tinNumber = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  FileClass tinfile = FileClass();
  TextEditingController tinFileEditor = TextEditingController();


    TextEditingController  regName = TextEditingController();
  TextEditingController  rc0rBN = TextEditingController();

  FileClass utilityFile = FileClass();
  TextEditingController utilityFileEditor = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  FileClass directorFile = FileClass();
  TextEditingController directorFileEditor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    addBusnessState = Provider.of<BusinessState>(context);

    loginState = Provider.of<LoginState>(context);
    appState = Provider.of(context);
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 0),
        child: Form(
            key: _formKey ,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Submit your Business\nCompliance",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: blue,
                              fontSize: 21),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Submit your Documents to Activate Business Goodies.",
                          style: TextStyle(
                            color: blue,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                  Image.asset(
                    "assets/images/bicycle_man.png",
                    width: 100,
                  )
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: [

                    CustomTextField(
                textEditingController: regName,
                      validator: (value){
                        if(value.isEmpty){
                          return "Field is required";
                        }else if(value.isEmpty){
                          return "Field Should have at least 20 Characters";
                        }

                        regBusinessNaame = value;
                        return null;
                      },
                      header: "Registered Business Name",),
                    SizedBox(height: 15,),

                    CustomTextField(
                        textEditingController: rc0rBN,
                      validator: (value){
                        if(value.isEmpty){
                          return "Field is required";
                        }

                    rcOrBC = value;
                        return null;
                      },
                      header: "RC or BN Number",),

                    SizedBox(height: 15,),
                    CustomTextField(
                readOnly: true,
                        validator: (value){
                          if(value.isEmpty){
                            return "Field is required";
                          }


                          return null;
                        },
                      onTap: () async {
                  print("hb");
                        // if (cacFile.file == null) {
                       cacFile.file = await getFile();
                          setState(() {
                    cacFileEditor.text   =  basename(cacFile.file.path);
                          });
                        },
                      // },
                      header: "Upload CAC Certificate (Recommended PDF)",
                      textEditingController: cacFileEditor

                    ),
                    SizedBox(height: 15,),
                    CustomTextField(
                      textEditingController: tinNumber,
                      validator: (value){
                        if(value.isEmpty){
                          return "Field is required";
                        }else if(value.length < 8){
                          return "Field should be at least 8 Characters";
                        }
                        // tinNumber = value;
                        return null;
                      },
                      header: "Enter TIN Number",),
                    SizedBox(height: 15,),
                    CustomTextField(
                        readOnly: true,
                      textEditingController: tinFileEditor,
                        header: "Upload TIN Certificate",
                        validator: (value){
                          if(value.isEmpty){
                            return "Field is required";
                          }

                          return null;
                        },
                      onTap: () async {
                     tinfile.file = await getFile();
                          setState(() {
                     tinFileEditor.text   =   basename(tinfile.file.path);
                          });
                        }

                    ),
                    SizedBox(height: 15,),
                    CustomDropDown(
                      suffix: isbusinessyUtility ? CupertinoActivityIndicator() : null,
                      intialValue: CustomDropDownItem(value: "", text:  "Select Utility "),

                      header: "Select Utility Bills Type",
                      items: addBusnessState.utilityBills.map((e) {
                        return CustomDropDownItem(
                            text: e,
                            value: e
                        );
                      }).toList(),
                      onSelected: (v) {
                        setState(() {
                          print(v);
                          utilityType = v;
                        });

                      },
                    ),
                    SizedBox(height: 15,),
                    CustomTextField(
                      readOnly: true,
                      validator: (value){
                        if(value.isEmpty){
                          return "Field is required";
                        }


                        return null;
                      },
                        textEditingController: utilityFileEditor,
                      onTap: () async {
                        utilityFile.file = await getFile();
                        setState(() {
                          utilityFileEditor.text   =   basename(utilityFile.file.path);
                        });
                      },

                      header: "Upload Utility Bill (Recommended PDF)",),

                    SizedBox(height: 15,),
                    CustomTextField(
                      readOnly: true,
                      validator: (value){
                        if(value.isEmpty){
                          return "Field is required";
                        }

                        return null;
                      },
                      textEditingController: directorFileEditor,
                      onTap: () async {
                        directorFile.file = await getFile();
                        setState(() {
                       directorFileEditor.text   =   basename( directorFile.file?.path);
                       // widget.onAddCompliancePayload({
                       //   "RegBusinessName" : regName.text,
                       //   "rcOrBn" : rc0rBN.text,
                       //   "cac" : cacFile,
                       //   "tin" : tinNumber.text,
                       //   "tinCert" : tinfile,
                       //   "billType" : utilityType,
                       //   "utility" : utilityFile,
                       //   "director" : directorFile
                       // });
                        });
                      },

                      header: "Upload Director Form (Recommended PDF)",),
                    SizedBox(height: 15,),
                    // SizedBox(height: 35,),
                    Container(
                      // padding: EdgeInsets.symmetric(horizontal: 20),
                      child: CustomButton(
                        onPressed: () {
                          //   if(index == 0){
                          if(_formKey.currentState.validate()){
                            addCompliance(context);
                            // addCompliance();
                          }
                          //   }else if(index == 1){
                          //     if(_formKey.currentState.validate()){
                          // addCompliance();
                          //
                          //     }
                          //   }
//                  pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeOutExpo);
                        },
                        color: cyan,
                        text: "Proceed",
                      ),
                    ),
                    SizedBox(height: 15,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<File> getFile({File file}) async {
  appState.selectingFile = true;
//    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if(result != null) {
      File file = File(result.files.single.path);
      return file;
    } else {
      return null;
    }

  }

  @override
  void afterFirstLayout(BuildContext context) async{
  getBusinesscategories(context);

  final pref = await SharedPreferences.getInstance();
      setState(() {
        business_uuid = pref.getString("business_uuid");
      });

      print(business_uuid);
    }

  getBusinesscategories(context)async{

    setState(() {
      isbusinessyUtility = true;
    });
    var result = await addBusnessState.fetchBillTypes(token: loginState.user.token,);
    setState(() {
      isbusinessyUtility = false;
    });

    if(result["error"] == false){

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

      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );

    }
  }



  addCompliance(context)async{




    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result =await  addBusnessState.addBusinessCompliance(token: loginState.user.token,CAC: cacFile, tinNumber: tinNumber.text, registeredName: regName.text, rcOrBN: rc0rBN.text, utiltyType: utilityType, utitltyBill: utilityFile, Tin:tinfile, DIrectorForm: directorFile, business_uuid: business_uuid,  );

    if(result["error"] == false){

      var result2 = await  addBusnessState.getBusiness(token: loginState.user.token, business_uuid:business_uuid );
      pop(context);
          getuser(context, result);

      // setState(() {
      //   CommonUtils.showAlertDialog(context: context, text: result["message"], onClose: () async{
      //     pop(context);
      //    // pushToAndClearStack(context, DashboardPage());
      //
      //   });
      // });

    }else if (result["error"] == true && result["statusCode"] == 401){
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
      CommonUtils.showMsg(body:result["message"] , context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );
    }

  }

  getuser(context, result)async{
    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result2 = await loginState.getUser(token: loginState.user.token);
    pop(context);
    if(result2["error"] == false){
      CommonUtils.showAlertDialog(context: context, text: result["message"], onClose: () async{
        pop(context);
        pushToAndClearStack(context, DashboardPage());
      });
    }
  }

}
