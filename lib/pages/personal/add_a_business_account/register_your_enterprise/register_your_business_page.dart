import 'dart:io';

import 'package:flutter/material.dart';
import 'package:glade_v2/pages/dashboard/dashboard_page.dart';
import 'package:glade_v2/pages/personal/add_a_business_account/register_your_enterprise/stages/register_your_enterprise_stage_1.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/reuseables/dialogPopup.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'stages/register_your_enterprise_stage_2.dart';
import 'stages/register_your_enterprise_stage_3.dart';
import 'stages/register_your_enterprise_stage_4.dart';

class RegisterYourEnterprisePage extends StatefulWidget {
  @override
  _RegisterYourEnterprisePageState createState() =>
      _RegisterYourEnterprisePageState();
}

class _RegisterYourEnterprisePageState
    extends State<RegisterYourEnterprisePage> {
  PageController controller = PageController();
  Map<String,dynamic> businessInfo = {};

  Map<String,dynamic> directors = {};
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String,dynamic> directors1 = {};
BusinessState businessState;

LoginState loginState;
  int type;
  File Idcard;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    loginState = Provider.of<LoginState>(context);
    businessState = Provider.of<BusinessState>(context);
    return Scaffold(

      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Header(
                  text: headerText(type),
                  preferredActionOnBackPressed: (){
                      if(pageIndex != 0){
                        controller.previousPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeOutExpo);
                        setState(() {
                          pageIndex--;
                        });
                      }else{

                        pop(context);
                      }
                  },
                ),
              ),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: PageView(

                    physics: NeverScrollableScrollPhysics(),
                    controller: controller,
                    children: [
                      RegisterYourEnterpriseStage1(
                        onSelected: (v) {
                          type = v;
                        },
                      ),
                      RegisterYourEnterpriseStage2(

                        onSelected: (v){
                          print(v);
                          businessInfo = v;
                        },
                        type: type,
                      ),
                      RegisterYourEnterpriseStage3(
                        onImage: (value){
                          Idcard = value;
                        },
                        onSelected: (v){
                          directors1 = v;
                        },
                      ),
                      RegisterYourEnterpriseStage4(
                      onSelected:(v){
                        directors = {
                          ...directors1,
                          ...v,

                        };

                      },
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomButton(
                    text: "Continue",
                    color: cyan,
                    onPressed: () {
                      print(pageIndex);
                      if (pageIndex == 0) {
                        if (type != null) {
                          controller.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeOutExpo);
                          setState(() {
                            pageIndex++;
                          });
                        } else {
                          toast("Select type of registration");
                        }
                      }else if(pageIndex == 1){
                        if(_formKey.currentState.validate()){
                          controller.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeOutExpo);
                          setState(() {
                            pageIndex++;
                          });

                        }
                      }else if(pageIndex == 2){
                        if(_formKey.currentState.validate()){
                          controller.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeOutExpo);
                          setState(() {
                            pageIndex++;
                          });

                        }
                      }else if(pageIndex == 3){
                        if(_formKey.currentState.validate()){
                          registerBiz();

                        }
                      }
                    }),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String headerText(type ) {
    switch (pageIndex ) {
      case 0:
        return "Register Your Enterprise";
      case 1:
        return "${type == 0 ? "Business" : "Company"}  Information";
      case 2:
        return "Directors Information";
      default:
        return "Directors Information";
    }
  }

  int pageIndex = 0;


  void registerBiz()async{
    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result = await businessState.RegisterBusiness(registration_type: type == 0 ? "business" : "company",company_name: businessInfo["BusinessName1"], company_name_two: businessInfo["BusinessName2"],

        company_name_three: businessInfo["BusinessName3"],company_address: businessInfo["BusinessAddress"], company_description:
        businessInfo["CompanyDesc"], company_objective: businessInfo["Companyobj"],
        documents: Idcard, directors: directors, company_email: businessInfo["BusinessEmail"],  share_capital: businessInfo["shareCapital"] != null ? businessInfo["shareCapital"] : "", per_capital_share:  businessInfo["CapitalperShare"] != null ? businessInfo["CapitalperShare"] : "" , token: loginState.user.token);
    pop(context);
    if(result["error"] == false){
      CommonUtils.showAlertDialog(context: context, text: result["message"], onClose: () async{
        pushToAndClearStack(context, DashboardPage());
      });
    }else if(result["error"] == true && result["statusCode"] == 401){
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
      CommonUtils.showMsg(body: result["message"]  ?? 'tt', context: context, scaffoldKey: _scaffoldKey,snackColor : Colors.red );

    }

  }




}
