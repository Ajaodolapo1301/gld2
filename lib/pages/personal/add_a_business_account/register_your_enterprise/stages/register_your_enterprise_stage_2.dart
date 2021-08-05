import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';

class RegisterYourEnterpriseStage2 extends StatefulWidget {
  int type;
  Function(Map<String, dynamic> value)onSelected;
  RegisterYourEnterpriseStage2({this.onSelected, this.type});
  @override
  _RegisterYourEnterpriseStage2State createState() =>
      _RegisterYourEnterpriseStage2State();
}

class _RegisterYourEnterpriseStage2State
    extends State<RegisterYourEnterpriseStage2> {

  GlobalKey<FormState> formkey;
  String BusinessName1;
  String BusinessName2;
  String BusinessName3;
String BusinessAddress;

String BusinessEmail;
  String Companyobj;
  String CompanyDesc;
  String shareCapital;
  String CapitalperShare;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            CustomTextField(
                validator: (v){
                  if(v.isEmpty){
                    return "Field is Required";
                  }
                  BusinessName1 =  v;
                  return null;
                },
                header: " ${widget.type == 0 ? "Business" : "Company"} Name 1st Option"),

            SizedBox(height: 15),
            CustomTextField(
                validator: (v){
                  if(v.isEmpty){
                    return "Field is Required";
                  }
                  BusinessName2 =  v;
                  return null;
                },
                header: " ${widget.type == 0 ? "Business" : "Company"} Name 2nd Option"),
            SizedBox(height: 15),
            CustomTextField(
                validator: (v){
                  if(v.isEmpty){
                    return "Field is Required";
                  }
                  BusinessName3 =  v;
                  return null;
                },

                header: "${widget.type == 0 ? "Business" : "Company"} Name 3rd Option"
            ),
            SizedBox(height: 15),
            CustomTextField(
                validator: (v){
                  if(v.isEmpty){
                    return "Field is Required";
                  }
                  BusinessAddress =  v;
                  return null;
                },
                header: "${widget.type == 0 ? "Business" : "Company"} Address"),
            SizedBox(height: 15),
            CustomTextField(
              type: FieldType.email,
                hint: "doe@gmail.com",
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return "Email is required";
                  } else if (!EmailValidator.validate(
                      value.replaceAll(" ", "").trim())) {
                    return "Email is invalid";
                  }
                  BusinessEmail = value;
                  return null;
                },
                header: "${widget.type == 0 ? "Business" : "Company"} Email Address"),
            SizedBox(height: 15),
            CustomTextField(
                validator: (v){
                  if(v.isEmpty){
                    return "Field is Required";
                  }
                  Companyobj =  v;
                  return null;
                },
                header: "${widget.type == 0 ? "Business" : "Company"} Objective"),
            SizedBox(height: 15),
            CustomTextField(
                validator: (v){
                  if(v.isEmpty){
                    return "Field is Required";
                  }
                  CompanyDesc =  v;
                  widget.onSelected({
                    "BusinessName1" : BusinessName1,
                    "BusinessName2":  BusinessName2,
                    "BusinessName3" : BusinessName3,
                    "BusinessAddress": BusinessAddress,
                    "BusinessEmail" : BusinessEmail,
                    "Companyobj": Companyobj,
                    "CompanyDesc": CompanyDesc,
                  });
                  return null;
                },
                header: "${widget.type == 0 ? "Business" : "Company"} Description"),
            SizedBox(height: 15),
         widget.type == 0 ? SizedBox() :       Column(
                  children: [
                    CustomTextField(
                        type: FieldType.number,
                        validator: (v){
                          if(v.isEmpty){
                            return "Field is Required";
                          }
                          shareCapital =  v;
                          return null;
                        },
                        header: "Share Capital"),
                    SizedBox(height: 15),
                    CustomTextField(

                      type: FieldType.number,
                        validator: (v){
                          if(v.isEmpty){
                            return "Field is Required";
                          }
                          CapitalperShare =  v;


                          widget.onSelected({
                            "BusinessName1" : BusinessName1,
                            "BusinessName2":  BusinessName2,
                            "BusinessName3" : BusinessName3,
                            "BusinessAddress": BusinessAddress,
                            "BusinessEmail" : BusinessEmail,
                            "Companyobj": Companyobj,
                            "CompanyDesc": CompanyDesc,
                            "shareCapital": shareCapital,
                            "CapitalperShare": CapitalperShare
                          });
                          return null;
                        },
                        header: "Capital Per Share"),
                  ],
                ),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
