


import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:dio/dio.dart';
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
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCompliance extends StatefulWidget {
  GlobalKey<FormState> formKey;
  final Function(Map<String, dynamic>)onAddCompliancePayload;
  AddCompliance({this.formKey, this.onAddCompliancePayload});

  @override
  _AddComplianceState createState() => _AddComplianceState();
}

class _AddComplianceState extends State<AddCompliance> with AfterLayoutMixin<AddCompliance> {

  var regBusinessNaame;
  // var tinNumber;
  var rcOrBC;
  var utilityType;
bool isbusinessyUtility = false;

  AppState appState;
  FileClass cacFile = FileClass();
  TextEditingController cacFileEditor = TextEditingController();
  TextEditingController tinNumber = TextEditingController();
  BusinessState businessState;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int index = 0;

  LoginState  loginState;

  FileClass tinfile = FileClass();
  TextEditingController tinFileEditor = TextEditingController();


  TextEditingController  regName = TextEditingController();
  TextEditingController  rc0rBN = TextEditingController();

  FileClass utilityFile = FileClass();
  TextEditingController utilityFileEditor = TextEditingController();


  FileClass directorFile = FileClass();
  TextEditingController directorFileEditor = TextEditingController();
  @override
  void initState() {

    initTextScale();
    super.initState();
  }

  double textScale = 1.0;
  void initTextScale() async {
    var pref = await SharedPreferences.getInstance();
    setState(() {
      textScale = pref.getDouble("textScaleFactor") ?? 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    businessState = Provider.of<BusinessState>(context);

    loginState = Provider.of<LoginState>(context);

    appState = Provider.of(context);



    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: textScale),
      child: Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Form(
              key: _formKey ,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Header(
                      text: "Add Compliance",
                      preferredActionOnBackPressed: (){
                        pop(context);

                      },
                    ),
                    // SizedBox(height: 10,),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.end,
                    //   children: [
                    //     Expanded(
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text(
                    //             "Add a Business Compliance",
                    //             style: TextStyle(
                    //                 fontWeight: FontWeight.w600,
                    //                 color: blue,
                    //                 fontSize: 21),
                    //           ),
                    //           SizedBox(height: 2),
                    //           Text(
                    //             "Create  a new business account in minutes by telling us about your business.",
                    //             style: TextStyle(
                    //               color: blue,
                    //               fontSize: 12,
                    //             ),
                    //           ),
                    //           SizedBox(height: 8),
                    //         ],
                    //       ),
                    //     ),
                    //     Image.asset(
                    //       "assets/images/bicycle_man.png",
                    //       width: 100,
                    //     )
                    //   ],
                    // ),
                    SizedBox(height: 10),
                    Column(
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
                              return "Field should be at least 8";
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
                          // suffix: isStateLoading ? CupertinoActivityIndicator() : null,
                          intialValue: CustomDropDownItem(value: "", text:  "Select Utility "),

                          header: "Select Utility Bills Type",
                          items: businessState.utilityBills.map((e) {
                            return CustomDropDownItem(
                                text: e,
                                value: e
                            );
                          }).toList(),
                          onSelected: (v) {
                            setState(() {
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
                              directorFileEditor.text   =   basename( directorFile.file.path);

                            });
                          },

                          header: "Upload Director Form (Recommended PDF)",),
                        // SizedBox(height: 35,),
                        SizedBox(height: 15),
                        Container(
                          // padding: EdgeInsets.symmetric(horizontal: 20),
                          child: CustomButton(
                            onPressed: () {
                              if(_formKey.currentState.validate()){
                                addCompliance(context);
                              }
                            },
                            color: cyan,
                            text: "Proceed",
                          ),
                        ),
                        SizedBox(height: 20),

                      ],
                    ),
                    // SizedBox(height: 10),
                    // Container(
                    //   // padding: EdgeInsets.symmetric(horizontal: 20),
                    //   child: CustomButton(
                    //     onPressed: () {
                    //         if(_formKey.currentState.validate()){
                    //           addCompliance(context);
                    //         }
                    //     },
                    //     color: cyan,
                    //     text: "Proceed",
                    //   ),
                    // ),
                    // SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  addCompliance(context)async{
    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result =await  businessState.addBusinessCompliance(token: loginState.user.token,CAC: cacFile, tinNumber:tinNumber.text , registeredName: regName.text, rcOrBN: rc0rBN.text, utiltyType: utilityType, utitltyBill: utilityFile, Tin:tinfile, DIrectorForm: directorFile, business_uuid:businessState.business.business_uuid );
    pop(context);
    if(result["error"] == false){
      showDialog(
          context: this.context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Preloader();
          });

      var result2 =await  businessState.getBusiness(token: loginState.user.token, business_uuid:businessState.business.business_uuid );
      var result =  await loginState.getUser(token: loginState.user.token);
      pop(context);
      if(result2["error"] == false){

        setState(() {

          CommonUtils.showAlertDialog(context: context, text: result["message"] ?? "Successfully Added Compliance", onClose: () async{
            // pop(context);
            pushToAndClearStack(context, DashboardPage());

          });
        });
      }else{

        CommonUtils.showMsg(body:"Compliance submitted but an error occurred while trying to get business Information", context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );
      }

    }else{
      CommonUtils.showMsg(body:result["message"] ?? "failed", context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );
    }

  }




  Future<File> getFile({File file}) async {
  appState.selectingFile = true;
//    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if(result != null) {
      File file = File(result.files.single.path);
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
    getBusinesscategories(context);
  }

  getBusinesscategories(context)async{
    print("call businessCat");
    setState(() {
      isbusinessyUtility = true;
    });
    var result = await businessState.fetchBillTypes(token: loginState.user.token,);
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

}
