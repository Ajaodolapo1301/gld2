import 'package:after_layout/after_layout.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glade_v2/core/models/apiModels/Auth/allBusiness.dart';
import 'package:glade_v2/core/models/apiModels/Personal/GoLive/StateAndLGA.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/Personal/goliveState.dart';
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
import 'package:provider/provider.dart';

class AddABusinessAccountStage1 extends StatefulWidget {
  GlobalKey<FormState> formKey;
  PageController pageController;
  final Function(Map<String, dynamic>)onAddBusinessPayload;
  AddABusinessAccountStage1({this.formKey,this.onAddBusinessPayload, this.pageController });


  @override
  _AddABusinessAccountStage1State createState() => _AddABusinessAccountStage1State();
}

class _AddABusinessAccountStage1State extends State<AddABusinessAccountStage1>  with AfterLayoutMixin<AddABusinessAccountStage1>{
  var  buinessName;
  var businessCategory;
  var  buinessWebsite;
  bool makedefault = false;
  var businessDescription;
  GoLIveState goLIveState;
  var country;
  bool isCountryLoading = false;
  bool isbusinessCategories = false;
  var state;
  States states;
  CountryModel countryModel;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var businessAddress;
  var businessEmail;
  LoginState loginState;
  AppState appState;
  BusinessState businessState;

    List<String> _businesscat = [
     "FinTech",
      "SME"
    ];

  bool isStateLoading = false;

  @override
  Widget build(BuildContext context) {
    loginState = Provider.of<LoginState>(context);
    goLIveState = Provider.of<GoLIveState>(context);
    appState = Provider.of(context);




    businessState = Provider.of<BusinessState>(context);
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 0),
        child: Form(
        key: _formKey,
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
                          "Add a Business\nAccount",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: blue,
                              fontSize: 21),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Create  a new business account in minutes by telling us about your business.",
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomDropDown(
                      suffix: isbusinessCategories ? CupertinoActivityIndicator() : null,
                  intialValue: CustomDropDownItem(value: "", text:  "Select Business Category"),

                  header: "Select Business Category",
                  items: businessState.businesscat.map((e) {
                    return CustomDropDownItem(
                      text: e,
                       value: e
                    );
                  }).toList(),
                  onSelected: (v) {
            setState(() {
              businessCategory = v;
            });

                  },
              ),
                      SizedBox(height: 15,),
                      CustomTextField(
                        type: FieldType.text,
                        header: "Enter Registered Business Name",
                          validator: (value){
                              if(value.isEmpty){
                                return "Field is required";
                              }

                          buinessName = value;
                              return null;
                          },
                      ),
                      SizedBox(height: 15,),
                      CustomTextField(header: "Enter Registered Business Email",
                      type: FieldType.email,
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return "Email is required";
                          } else if (!EmailValidator.validate(
                              value.replaceAll(" ", "").trim())) {
                            return "Email is invalid";
                          }
                          // appState.businessEmail = value;
                          businessEmail = value;
                          return null;
                        },
                      ),
                      SizedBox(height: 15,),
                      CustomTextField(header: "Business Description",
                        validator: (value){
                          if(value.isEmpty){
                            return "Field is required";
                          }else if(value.length < 15){

                            return "business description must be at least 15 characters";
                          }
                          // appState.businessDescription = value;
                          businessDescription = value;
                          return null;
                        },
                      ),
                      SizedBox(height: 15,),
                      CustomDropDown<CountryModel>(
                        suffix: isCountryLoading ? CupertinoActivityIndicator() : null,
                        intialValue: CustomDropDownItem(value: countryModel, text:  "Select country"),

                        header: "Select Country",
                        items: businessState.countryModel.map((e) {
                          return CustomDropDownItem(
                              text: e.country_name,
                              value: e
                          );
                        }).toList(),
                        onSelected: (v) {
                          countryModel = v;
                          // getLGA();
                        },
                      ),
                      SizedBox(height: 15,),
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
                          states = v;
                          // getLGA();
                        },
                      ),
                      SizedBox(height: 15,),
                      CustomTextField(
                        type: FieldType.text,
                        header: "Registered Business Address",
                        validator: (value){
                          if(value.isEmpty){
                            return "Field is required";
                          }else if(value.length <= 20 ){
                            return "Field Should have at least 20 Characters";
                          }


                          businessAddress = value;
                          widget.onAddBusinessPayload({
                            "category": businessCategory,
                            "businessName" : buinessName,
                            "description" : businessDescription,
                            "email" : businessEmail,
                            "country" :countryModel.country_name,
                            "state": states.state_name,
                            "businessAddress" : businessAddress,
                            "default" : makedefault,
                            "website" : buinessWebsite ?? "",


                          });
                          return null;
                        },
                      ),
                      SizedBox(height: 15,),
                      CustomTextField(header: "Business Website (Optional)",
                    onChanged: (value){
                        setState(() {

                          buinessWebsite = value;
                        widget.onAddBusinessPayload({
                          "category": businessCategory,
                          "businessName" : buinessName,
                          "description" : businessDescription,
                          "email" : businessEmail,
                          "country" :country,
                          "state": states.state_name,
                          "businessAddress" : businessAddress,
                            "default" : makedefault,
                            "website" : buinessWebsite,


                        });
                        });

                    },

                      ),
                      Transform.scale(
                        scale: 0.8,
                        child: CheckboxListTile(
                          value:makedefault,
                          controlAffinity: ListTileControlAffinity.trailing,
                          onChanged: (value) {
                            setState(() {
                              makedefault = value;
                              widget.onAddBusinessPayload({
                                "category": businessCategory,
                                "businessName" : buinessName,
                                "description" : businessDescription,
                                "email" : businessEmail,
                                "country" :country,
                                "state": states.state_name,
                                "businessAddress" : businessAddress,
                              "default" : makedefault


                              });
                            });
                          },
                          title: Text(
                            "Make Business Default.",
                            style: TextStyle(
                                color: blue,
                                fontSize: 13
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15,),
                      // SizedBox(height: 35,),
                      Container(
                        // padding: EdgeInsets.symmetric(horizontal: 20),
                        child: CustomButton(
                          onPressed: () {
                            //   if(index == 0){
                                if(_formKey.currentState.validate()){
                                  addBusiness();
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
              ),

            ],
          ),
        ),
      ),
    );
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

 } else if(result["error"] == true && result["statusCode"] == 401){


   }

   else{

     CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );

   }
 }

  getBusinesscategories()async{
    print("call businessCat");
    setState(() {
     isbusinessCategories = true;
    });
    var result = await businessState.fetchBusinesscategory(token: loginState.user.token,);
    setState(() {
      isbusinessCategories = false;
    });

    if(result["error"] == false){

    } else if(result["error"] == true && result["statusCode"] == 401){


    }

    else{

      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );

    }
  }

  getCountries()async{
    print("call coutries");
    setState(() {
      isCountryLoading = true;
    });
    var result = await businessState.fetchCountry(token: loginState.user.token,);
    setState(() {
      isCountryLoading = false;
    });

    if(result["error"] == false){

    } else if(result["error"] == true && result["statusCode"] == 401){


    }

    else{

      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );

    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if(goLIveState.states?.isEmpty || goLIveState.states == null){
      getState();
    }

    if(businessState.countryModel?.isEmpty || businessState.countryModel == null){
      getCountries();
    }

    if(businessState.businesscat?.isEmpty || businessState.businesscat == null){
      getBusinesscategories();
    }
  }



  addBusiness()async{
    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    // "category": businessCategory,
    // "businessName" : buinessName,
    // "description" : businessDescription,
    // "email" : businessEmail,
    // "country" :country,
    // "state": states.state_name,
    // "businessAddress" : businessAddress,
    // "default" : makedefault,
    // "website" : buinessWebsite,
    var result =await  businessState.addBusiness(businessCategory:businessCategory, buinessWebsite: buinessWebsite ?? "" , businessAddress: businessAddress, state: states.state_name, country: countryModel.country_name, businessEmail: businessEmail, businessName:buinessName,businessDesc: businessDescription, token: loginState.user.token,makeDefault: makedefault ?? false );
    pop(context);
    if(result["error"] == false){
      // businessObject["default"] == true ?
      setState(() {
        // index ++;
        CommonUtils.showAlertDialog(context: context, text: result["message"], onClose: () async{
          pop(context);
       widget.pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeOutExpo);
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



}






