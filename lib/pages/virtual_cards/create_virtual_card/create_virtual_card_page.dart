import 'package:flutter/material.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/virtualCardDesign.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/virtualCardTitle.dart';
import 'package:glade_v2/pages/authentication/login_page.dart';
import 'package:glade_v2/pages/dashboard/dashboard_page.dart';
import 'package:glade_v2/pages/virtual_cards/view_virtual_card/view_virtual_card_page.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/Business/virtualCardState.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/reuseables/dialogPopup.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:provider/provider.dart';

import 'stages/create_virtual_card_stage_1.dart';
import 'stages/create_virtual_card_stage_2.dart';
import 'stages/create_virtual_card_stage_3.dart';

class CreateVirtualCardPage extends StatefulWidget {
  @override
  _CreateVirtualCardPageState createState() => _CreateVirtualCardPageState();
}

class _CreateVirtualCardPageState extends State<CreateVirtualCardPage> {
  PageController controller = PageController();
AppState appState;
  int index = 0;
VirtualCardTitle virtualCardTitle;
Map<String, dynamic> amountAndCurrencyObject = {};
String ColorCode;
VirtualCardState virtualCardState;
BusinessState businessState;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
LoginState loginState;
  @override
  Widget build(BuildContext context) {
    appState =Provider.of<AppState>(context);
    loginState =Provider.of<LoginState>(context);

    businessState =Provider.of<BusinessState>(context);
    virtualCardState =Provider.of<VirtualCardState>(context);
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
                text: index == 2 ? "Card Design" : "Create New Card",
                preferredActionOnBackPressed: (){
                  if(index == 0){
                    pop(context);
                  }
                  controller.previousPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeOutExpo,
                  );
                  setState(() {
                    index--;
                  });
                },
              ),
              SizedBox(height: 20),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Form(
                    key: _formKey,
                    child: Container(
                      color: Colors.white,
                      child: PageView(
                        controller: controller,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          CreateVirtualCardStage1(onTitleSelected: (VirtualCardTitle v){
                            setState(() {
                              virtualCardTitle = v;

                            });
                          },),
                          CreateVirtualCardStage2(
                          onItemSelected: (v){
                            setState(() {
                              amountAndCurrencyObject = v;
                            });

                            print(amountAndCurrencyObject);

                          },
                          ),
                          CreateVirtualCardStage3(
                      onDesignSelected: (v){
                        setState(() {
                          ColorCode = v;
                        });

                      },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: CustomButton(
                  onPressed: () async {
                    if(index == 0){
                      controller.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeOutExpo,
                      );
                      setState(() {
                        index++;
                      });
                    }else if(index == 1 ){
                        if(_formKey.currentState.validate()){
                          controller.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeOutExpo,
                          );
                          setState(() {
                            index++;
                          });
                        }
                    } else{
                    createVirtualCard();
                    }
                  },
                  text: index == 2 ? "Create Card" : "Proceed",
                  color: cyan,
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }


  createVirtualCard() async{
    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result = await virtualCardState.createVcard(card_title: virtualCardTitle.card_title, currency: amountAndCurrencyObject["currency"],
        amount: amountAndCurrencyObject["amount"], design_code: ColorCode ?? "#000000", token: loginState.user.token, business_uuid:businessState.business?.business_uuid ?? "", isPersonal: appState.isPersonal, country: amountAndCurrencyObject["country"] );
    pop(context);
    if(result["error"] == false){
      setState(() {
        CommonUtils.showAlertDialog(text:result["message"] ?? "Virtual created successfully" , context: context, onClose: (){
          pop(context);
            pushReplacementTo(context, ViewVirtualCardPage(
              virtualCardId: result["card_id"],
            ));
        });
      });
    }else if(result["error"] == true && result["statusCode"] == 401){
      // showDialog(
      //     barrierDismissible: false,
      //     context: context,
      //     child: dialogPopup(
      //       context: context,
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

      CommonUtils.showMsg(body:result["message"] ?? "Error", context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );

    }
  }

}




