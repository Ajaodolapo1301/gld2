import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class RequestLoanStage2 extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldKey;
  final Function(Map<String, dynamic> value)onGuarantorPayload;

  RequestLoanStage2({this.scaffoldKey, this.onGuarantorPayload});
  @override
  _RequestLoanStage2State createState() => _RequestLoanStage2State();
}

class _RequestLoanStage2State extends State<RequestLoanStage2> {
  TextEditingController name  = TextEditingController();
  var GuarantorPhone;
  var GuarantorName;
  var GuarantorEmail;
  var GuarantorAddress;
  AppState appState;

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                CustomTextField(
                  // textEditingController: GuarantorName,
                    header: "Name of Guarantor",
                  validator: (value) {
                    if(value.trim().isEmpty){
                      return "Name is required";
                    }
                    if(!value.trim().contains(" ")){
                      return "Add space then add the last name";
                    }
                    GuarantorName = value;
                    return null;
                  },
                ),
                SizedBox(height: 15),
                CustomTextField(

                    type: FieldType.phone,
                    textInputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11)
                    ],
                    validator: (value){
                      if(value.isEmpty){
                        return "Field is required";
                      }
                      GuarantorPhone = value;
                      return null;
                    },
                    header: "Enter Phone Number"),
                SizedBox(height: 15),
                CustomTextField(
                    // textEditingController: GuarantorEmail,
                  type: FieldType.email,
                    validator: (value){
                      if(value.isEmpty){
                        return "Field is required";
                      }
                      GuarantorEmail = value;
                      return null;
                    },
                    header: "Enter Email Address"),
                SizedBox(height: 15),

                CustomTextField(
                  // textEditingController: appState.GuarantorAddress,
                  header: "Residential Address",
                  validator: (value){
                    if(value.isEmpty){
                      return "Field is required";
                    }
                    GuarantorAddress = value;
                    widget.onGuarantorPayload({
                      "address":GuarantorAddress,
                        "guaEmail": GuarantorEmail,
                        "guaPhone": GuarantorPhone,
                          "guaName": GuarantorName
                    });

                    return null;
                  },

                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
