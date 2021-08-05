import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glade_v2/core/models/apiModels/Auth/allBusiness.dart';
import 'package:glade_v2/core/models/apiModels/Personal/GoLive/StateAndLGA.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/Personal/goliveState.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_drop_down.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class RegisterYourEnterpriseStage4 extends StatefulWidget {

  Function(Map<String, dynamic> value)onSelected;
  RegisterYourEnterpriseStage4({this.onSelected});
  @override
  _RegisterYourEnterpriseStage4State createState() =>
      _RegisterYourEnterpriseStage4State();
}

class _RegisterYourEnterpriseStage4State
    extends State<RegisterYourEnterpriseStage4>  with AfterLayoutMixin<RegisterYourEnterpriseStage4>{

  String ResAddress;
List<String> gender = [
  "Male",
  "Female"
];

  LGA lga;
String selectedGender;
  AppState appState;
  States states;
  bool isLoading = false;
  GoLIveState goLIveState;
  LoginState loginState;
BusinessState businessState;
  CountryModel countryModel;
  bool isLGALoading = false;
  bool isStateLoading = false;

  bool isCountryLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    goLIveState = Provider.of<GoLIveState>(context);
    loginState = Provider.of(context);
    appState = Provider.of(context);
    businessState = Provider.of(context);
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              CustomTextField(
                  validator: (value){

                    if(value.isEmpty){
                      return "Field is required";
                    }
                    ResAddress = value;
                    widget.onSelected({
                      "director_address" : ResAddress,
                      "director_gender": selectedGender,
                      "director_country": countryModel.country_name,
                      "director_state" : states.state_name,
                      "director_lga" : lga.city_name
                    });
                    return null;
                  },
                  header: "Residential Address"),
              SizedBox(height: 15),
              CustomDropDown<String>(

                intialValue: CustomDropDownItem(value:"", text:   "Select gender"),

                header: "Select Gender",

                items: gender.map((e) {
                  return CustomDropDownItem(
                      text: e,
                      value: e
                  );
                }).toList(),

                onSelected: (v) {
                  selectedGender = v;

                },
              ),
              SizedBox(height: 15),
              CustomDropDown<CountryModel>(
                suffix: isCountryLoading ? CupertinoActivityIndicator() : null,
                intialValue: CustomDropDownItem(value: countryModel, text:  "Select state"),

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
              SizedBox(height: 25),
            ],
          ),
        ),
      )
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

    }else{

      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );

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
    if(goLIveState.states?.isEmpty ||goLIveState.idCardTypes == null ){
      getState();
    }


    if(businessState.countryModel?.isEmpty || businessState.countryModel == null){
      getCountries();
    }
  }

}
