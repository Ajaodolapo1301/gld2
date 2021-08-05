import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:glade_v2/pages/dashboard/dashboard_page.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/Personal/goliveState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:provider/provider.dart';

import 'stages/go_live_stage_1.dart';
import 'stages/go_live_stage_2.dart';

class GoLivePage extends StatefulWidget {
  @override
  _GoLivePageState createState() => _GoLivePageState();
}

class _GoLivePageState extends State<GoLivePage> {
  PageController controller = PageController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  GoLIveState goLIveState;
  LoginState loginState;
  int index = 0;
  Map<String, dynamic> formsfilled = {};
  // FileClass
  XFile selfie;
  BusinessState businessState;
  // = FileClass();


  @override
  Widget build(BuildContext context) {
    loginState = Provider.of<LoginState>(context);
    goLIveState = Provider.of<GoLIveState>(context);
    businessState = Provider.of<BusinessState>(context);
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Header(
                  text: "Go-Live Personal",
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: controller,
                    children: [
                      GoLivePersonalStage1(
                        scaffoldKey: _scaffoldKey,
                        onFormFilled: (v) {
                          setState(() {
                            formsfilled = v;
                            print
                              (formsfilled);
                          });
                        },
                      ),
                      GoLivePersonalStage2(
                        onSelfieSnapped: (v) {
                          setState(() {
                            selfie = v;
                            print(v);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),


              index == 1 && selfie == null ? SizedBox() :     Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomButton(
                  text: index == 1 ? "Submit" : "Proceed",
                  color: index == 1 ? orange : cyan,
                  onPressed: () {
                    if (index == 0) {
                      if (_formKey.currentState.validate()) {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          index++;
                        });
                        controller.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeOutExpo,
                        );
                      }
                    } else if (index == 1) {
                      if (selfie != null) {
                        print(selfie);
                        go();
                      }
                    }
                  },
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void go() async {


// print(   formsfilled["idUpload"],);
// print(  formsfilled["idNumber"],);
//     print( formsfilled['idType'],);
// print(  formsfilled["state"],);
//    print(formsfilled["lGA"],);
//  print(formsfilled["address"],);
//  print(selfie);
showDialog(
    context: this.context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Preloader();
    });
    var result = await goLIveState.goLive(
        token: loginState.user.token,
        id_image: formsfilled["idUpload"],
        id_number: formsfilled["idNumber"],
        id_type_id: formsfilled['idType'],
        state_id: formsfilled["state"],
        lga_id: formsfilled["lGA"],
        residential_address: formsfilled["address"],
        selfie_image: selfie);
    pop(context);
    if(result["error"] == false){
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
            pushToAndClearStack(context, DashboardPage());
          });
        }else{
          CommonUtils.showMsg(body:"Your compliance has been submitted,", context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );

        }

    }



    else {
      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );
    }



  }
}

class FileClass {
  File file;

  @override
  String toString() {
    super.toString();
    return "${file.path}";
  }

  void changeFile(File newFile) {
    file = newFile;
  }
}
