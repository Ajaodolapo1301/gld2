import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glade_v2/core/models/apiModels/Personal/GoLive/IdcardTypes.dart';
import 'package:glade_v2/core/models/apiModels/Personal/GoLive/StateAndLGA.dart';
import 'package:glade_v2/provider/Personal/goliveState.dart';
import 'package:glade_v2/provider/Personal/posState.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/widgets/custom_drop_down.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../go_live_personal_page.dart';
import 'package:path/path.dart';
class GoLivePersonalStage1 extends StatefulWidget {

  GlobalKey<ScaffoldState> scaffoldKey;
  GlobalKey<FormState> formkey;
  Function(Map<String, dynamic> )onFormFilled;
  GoLivePersonalStage1({this.scaffoldKey, this.formkey, this.onFormFilled});
  @override
  _GoLivePersonalStage1State createState() => _GoLivePersonalStage1State();
}

class _GoLivePersonalStage1State extends State<GoLivePersonalStage1>  with AfterLayoutMixin<GoLivePersonalStage1>{

 GoLIveState goLIveState;
 LoginState loginState;
 AppState appState;
 bool isLoading = false;
 bool isLGALoading = false;
 bool isStateLoading = false;
 IdCardTypes idCardTypes;
// String idcardType;
String  idCardnum;
LGA lga;
POSState posState;
  States states;
// String state_id;

 TextEditingController idfileController = TextEditingController();

 TextEditingController addressGoLive = TextEditingController();

 File idFile;
  @override
  Widget build(BuildContext context) {
    goLIveState = Provider.of<GoLIveState>(context);
    loginState = Provider.of<LoginState>(context);
    appState = Provider.of<AppState>(context);
    posState = Provider.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
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
              type: FieldType.number,
              // textEditingController: idCardNumber,
              header: "Input Identity Card Number",
              validator: (value){
                if(value.isEmpty){
                  return "Field is required";
                }
                  idCardnum = value;
                return null;
              },

            ),
            SizedBox(height: 15),
            GestureDetector(

              child: CustomTextField(
                textEditingController: idfileController,
                readOnly: true,
                  onTap: () async {
                      idfileController.clear();
                    // if (idFile == null) {
                      idFile = await getFile();
                      final appDir = await getApplicationDocumentsDirectory();
                      final fileName = await basename(idFile.path);
                      final File savedimage = await idFile.copy('${appDir.path}/$fileName');

                      setState(() {
                        idfileController.text = savedimage.path;
                      });
                    // }
                  },

                header: "Upload Identity Card",
              ),
            ),
            SizedBox(height: 15),
            CustomDropDown<States>(
              suffix: isStateLoading ? CupertinoActivityIndicator() : null,
                          intialValue: CustomDropDownItem(value: states, text:  "Select state"),

              header: "Select State",
              items: goLIveState.states.map((e) {
                return CustomDropDownItem(
                    text: e.state_name,
                    value: e
                );
              }).toList(),
              onSelected: (v) {
          setState(() {
            states = v;
            getLGA(states.state_id);
          });
              },
            ),
            SizedBox(height: 15),
            CustomDropDown<LGA>(
              intialValue: CustomDropDownItem(value: lga , text: "Select LGA"),
              items: goLIveState.lga == null ? [] : goLIveState.lga.map((e) {
                return CustomDropDownItem(
                    text: e.city_name ,
                    value: e
                );
              }).toList(),
              onSelected: (item) {
                lga = item;
              },
              header: "Select LGA",
            ),

    //       ),
            SizedBox(height: 15),
            CustomTextField(
              textEditingController: addressGoLive,
              header: "Enter your Residential Address",
              validator: (value){
              if(value.isEmpty){
                return "Field is required";
              }else if(value.length < 20) {
                return "Field Should have at least 20 characters  ";
              }
                widget.onFormFilled({
                  "address": addressGoLive.text,
                  "lGA":lga.city_name,
                  "state":states.state_name,
                  "idUpload": idFile,
                  "idNumber":idCardnum,
                  "idType":idCardTypes.type_name
                });
              return null;
            },),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
      if(goLIveState.idCardTypes?.isEmpty ||goLIveState.idCardTypes == null ){
        getDocTypes();
      }
      if(goLIveState.states?.isEmpty ||goLIveState.idCardTypes == null ){
        getState();
      }

  }

 Future<File> getFile({File file}) async {


  // appState.selectingFile = true;
  PickedFile pickedFile = await ImagePicker().getImage(
     source: ImageSource.gallery,
     maxWidth: 1800,
     maxHeight: 1800,
   );

  if (pickedFile != null) {
    File imageFile = File(pickedFile.path);
    File file = File(imageFile.path);
    int sizeInBytes = file.lengthSync();
    if(sizeInBytes < 3000000){
      return file;
    }else{
      toast("Files too large, maximum is 5mb");
    }
  }else{
    return null;
  }

   // if(result != null) {
   //
   //
   // } else {
   //
   // }

 }


  // bool _pickInProgress = false;
  // _pickPhoto(ImageSource source) async {
  //   if (_pickInProgress) {
  //     return;
  //   }
  //   _pickInProgress = true;
  //   var image = await ImagePicker.pickImage(source: source);
  //   if (image != null) {
  //     setState(() {
  //       images.add(image);
  //     });
  //   }
  //   _pickInProgress = false;
  // }


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

  // getLGa() async{
  //   var result = await posState.getLGAs(token: loginState.user.token,state_id: states.state_name );
  //   if(result["error"] == false){
  //     setState(() {
  //     });
  //   }else{
  //     CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:widget.scaffoldKey, snackColor: Colors.red );
  //   }
  // }

}
