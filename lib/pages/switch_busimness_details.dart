
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:glade_v2/core/models/apiModels/Auth/allBusiness.dart';
import 'package:glade_v2/core/models/apiModels/Business/LoanAndOverdraft/loanHistory.dart';
import 'package:glade_v2/pages/personal/add_a_business_account/add_a_business_account/stages/add_compliace.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/Business/loanAndOverdraftState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/functions/bottom_sheet_utils.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard/dashboard_page.dart';

class SwitchAccountDetails extends StatefulWidget {

  AllBusiness business;

  SwitchAccountDetails({this.business});
  @override
  _SwitchAccountDetailsState createState() =>
      _SwitchAccountDetailsState();
}

class _SwitchAccountDetailsState extends State<SwitchAccountDetails> with TickerProviderStateMixin, AfterLayoutMixin<SwitchAccountDetails> {
  LoanAndOverdraftState loanAndOverdraftState;
  TextEditingController note = TextEditingController();
  LoginState loginState;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String newNote;
  bool isLoading = false;
    BusinessState businessState;
  bool isGetNoteLoading = false;
  String reason;
  bool isCancelled = false;


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
    businessState = Provider.of<BusinessState>(context);
    loginState = Provider.of<LoginState>(context);

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
                  text: "Business Details",
                ),
                SizedBox(height: 30),
                Expanded(
                  child: ListView(
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Business name",
                                  style: TextStyle(
                                    color: blue,
                                  ),
                                ),
                              ),
                              Text(
                                widget.business.business_name,
                                style: TextStyle(
                                  color: blue,
                                ),
                              )
                            ],
                          ),
                          Divider(),
                          SizedBox(height: 20),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Email",
                                  style: TextStyle(
                                    color: blue,
                                  ),
                                ),
                              ),
                              Text(
                                CommonUtils.capitalize(widget.business.business_email),
                                style: TextStyle(
                                  color: blue,
                                ),
                              )
                            ],
                          ),
                          Divider(),
                          SizedBox(height: 20),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Business category",
                                  style: TextStyle(
                                    color: blue,
                                  ),
                                ),
                              ),
                              Text(
                              widget.business.business_category ,
                                style: TextStyle(
                                  color: blue,
                                ),
                              )
                            ],
                          ),
                          Divider(),
                          SizedBox(height: 20),
                        ],
                      ),
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Address",
                      style: TextStyle(
                        color: blue,
                      ),
                    ),
                  ),
                  // 'pending','under-review','awaiting-user-response','approved','active','paused','cancelled','rejected','closed'
                  Expanded(
                    child: Text(
                      CommonUtils.capitalize(widget.business.business_address),

                      // textAlign: TextAlign.center,
                      style: TextStyle(
                        color: blue,
                      ),
                    ),
                  )
                ],
              ),
              Divider(),
              SizedBox(height: 20),
            ],
          ),






                    ],
                  ),
                ),
                 widget.business.status == "pending" ? SizedBox() :   CustomButton(
                  text: isLoading ? "Adding ... Please Wait " : "Switch business",
                  onPressed: () {
                    switchBusiness(widget.business.business_uuid);
                  },
                  color: cyan,
                ),
                SizedBox(height: 10),
             widget.business.status == "cancelled" ? SizedBox() :      CustomButton(
                  onPressed: () {
                  setDefault(business_uuid: widget.business.business_uuid);
                  },
                  text: "Set as Default",
                  type: ButtonType.outlined,
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
    // getNewNote();
  }
  setDefault({business_uuid})async{

    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });

    // }
    var result = await businessState.setDefault(token: loginState.user.token, business_uuid:business_uuid );

    if(result["error"] == false){
      var result1 = await loginState.getUser(token: loginState.user.token);
      if(result1["error"] == false){
        var result2 = await businessState.getBusiness(token: loginState.user.token, business_uuid: business_uuid);
        pop(context);
        if(result2["error"] == false){
          CommonUtils.showAlertDialog(text:result["message"], context: context, onClose: (){
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => DashboardPage()),
                    (Route<dynamic> route) => false);
          });

        }else{
          // pop(context);
          CommonUtils.showMsg(body:result1["message"] ?? "Error", context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );


        }
      }else{
        // pop(context);
        CommonUtils.showMsg(body:result1["message"] ?? "Error", context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );

      }




    }else{
      pop(context);
      CommonUtils.showMsg(body:result["message"] ?? "Error", context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );

    }


  }

    switchBusiness(business_uuid)async {
    print("memee");
      showDialog(
          context: this.context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Preloader();
          });
    var result =await  businessState.getBusiness(token: loginState.user.token, business_uuid: business_uuid);
    pop(context);
    if(result["error"] == false){
      pushToAndClearStack(context, DashboardPage());
      // CommonUtils.showAlertDialog(text:result["message"] ?? "Business Switched", context: context, onClose: (){
      //   Navigator.pushAndRemoveUntil(
      //       context,
      //       MaterialPageRoute(builder: (context) => DashboardPage()),
      //           (Route<dynamic> route) => false);
      // });

    }else{
      // pop(context);
      CommonUtils.showMsg(body:result["message"] ?? "Error", context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );

    }
    }
}
