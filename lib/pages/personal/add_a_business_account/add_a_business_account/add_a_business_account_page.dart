import 'package:flutter/material.dart';
import 'package:glade_v2/pages/dashboard/dashboard_page.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/reuseables/dialogPopup.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:provider/provider.dart';

import 'stages/add_a_business_account_page_stage_1.dart';
import 'stages/add_a_business_account_page_stage_2.dart';

class AddABusinessAccountPage extends StatefulWidget {
  @override
  _AddABusinessAccountPageState createState() =>
      _AddABusinessAccountPageState();
}

class _AddABusinessAccountPageState extends State<AddABusinessAccountPage> {

  PageController pageController = PageController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  BusinessState addBusnessState;
  AppState appState;
  int index = 0;
  Map<String, dynamic> businessObject = {};

  Map<String, dynamic> compliance = {};
  LoginState  loginState;
  @override
  Widget build(BuildContext context) {
    addBusnessState = Provider.of<BusinessState>(context);
    loginState = Provider.of<LoginState>(context);
    appState = Provider.of(context);
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Column(
          children: [
            Header(
              preferredActionOnBackPressed: (){
            pop(context);

              },
              text: "",
            ),
            Expanded(
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: pageController,
                children: [
                  AddABusinessAccountStage1(formKey: _formKey, pageController: pageController, onAddBusinessPayload: (value){
                    setState(() {
                      businessObject = value;
                    });

                  },),
                  AddABusinessAccountStage2(formKey: _formKey, onAddCompliancePayload: (value){

                  setState(() {
                    compliance = value;
                  });
                  },),
                ],
              ),
            ),
            SizedBox(height: 10),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: CustomButton(
//                 onPressed: () {
//                     if(index == 0){
//                       if(_formKey.currentState.validate()){
//                         addBusiness();
//                        // addCompliance();
//
//                       }
//                     }else if(index == 1){
//                       if(_formKey.currentState.validate()){
//                   addCompliance();
//
//                       }
//                     }
// //                  pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeOutExpo);
//                 },
//                 color: cyan,
//                 text: "Proceed",
//               ),
//             ),
//             SizedBox(height: 10),
          ],
        ),
      ),
    );
  }


  addBusiness()async{
    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result =await  addBusnessState.addBusiness(businessCategory: businessObject["category"], buinessWebsite: businessObject["website"] ?? "" , businessAddress: businessObject["businessAddress"], state: businessObject["state"], country: businessObject["country"], businessEmail: businessObject["email"], businessName: businessObject["businessName"],businessDesc: businessObject["description"], token: loginState.user.token,makeDefault: businessObject["default"] ?? null );
    pop(context);
      if(result["error"] == false){
        // businessObject["default"] == true ?
        setState(() {
          index ++;
          CommonUtils.showAlertDialog(context: context, text: result["message"], onClose: () async{
            pop(context);
      pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeOutExpo);
          });
        });

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
      }
      else{
        CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );
      }


  }







  addCompliance()async{

    print("ksnjns$compliance");
    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result =await  addBusnessState.addBusinessCompliance(token: loginState.user.token,CAC: compliance["cac"], tinNumber: compliance["tin"] , registeredName: compliance["RegBusinessName"], rcOrBN: compliance["rcOrBn"], utiltyType: compliance["billType"], utitltyBill: compliance["utility"], Tin:compliance["tinCert"], DIrectorForm: compliance["director"], business_uuid: loginState.user.business_uuid,  );
    pop(context);
    if(result["error"] == false){
      var result2 = await loginState.getUser(token: loginState.user.token);
      if(result2["error"] == false){
        CommonUtils.showAlertDialog(context: context, text: result["message"], onClose: () async{
              pop(context);
          pushToAndClearStack(context, DashboardPage());
        });
      }
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
      CommonUtils.showMsg(body:result["message"] ?? "success", context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );
    }

  }


}
