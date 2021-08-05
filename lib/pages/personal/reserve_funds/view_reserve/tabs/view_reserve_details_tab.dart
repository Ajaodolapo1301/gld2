import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:glade_v2/core/models/apiModels/Personal/ReserveFund/reserve.dart';
import 'package:glade_v2/provider/Personal/reserveState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/reuseables/dialogPopup.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_drop_down.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/stashDropDown.dart';
import 'package:provider/provider.dart';

class ViewReserveDetailsTab extends StatefulWidget {
  ReserveDetails reserveDetails;
  ViewReserveDetailsTab({this.reserveDetails});
  @override
  _ViewReserveDetailsTabState createState() => _ViewReserveDetailsTabState();
}

class _ViewReserveDetailsTabState extends State<ViewReserveDetailsTab>  with AfterLayoutMixin<ViewReserveDetailsTab>{
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController stashAmount = TextEditingController();
  ReserveState reserveState;
  LoginState loginState;
  ReserveDetails reserveDetails;
  bool isLoading = false;
  StashType stashType;
  MoneyMaskedTextController amountControllerAutomatic = MoneyMaskedTextController(
      decimalSeparator: ".",  thousandSeparator: ",");

  @override
  void initState() {
    title.text = widget.reserveDetails?.title;
    description.text = widget.reserveDetails?.description;
    stashAmount.text = widget.reserveDetails?.stash_amount;
    amount.text = widget.reserveDetails?.amount;
    // stashType = reserveState.stashType[reserveState.stashType.indexWhere((b) =>
    // "${b.stash_type_id}" == "${widget.reserveDetails.stash_type}")];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    reserveState = Provider.of<ReserveState>(context);
    loginState = Provider.of<LoginState>(context);
    return Container(
      child: Column(
        children: [
          SizedBox(height: 5),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 20),
              children: [
                CustomTextField(
                  validator: (v){
                    if(v.isEmpty){
                      return "Empty";
                    }
                    return  null;
                  },
                    textEditingController: title,
                    header: "Enter Title"
                ),
                SizedBox(height: 15),
                CustomTextField(

                    validator: (v){
                      if(v.isEmpty){
                        return "Empty";
                      }
                      return  null;
                    },
                    textEditingController: description,
                    header: "Enter Description"),
                SizedBox(height: 15),
                CustomTextField(
                    validator: (v){
                      if(v.isEmpty){
                        return "Empty";
                      }
                      return  null;
                    },
                    textEditingController: amount,
                    header: "Amount"),
                SizedBox(height: 15),
                CustomTextField(

                    validator: (v){
                      if(v.isEmpty){
                        return "Empty";
                      }
                      return  null;
                    },
                    textEditingController: stashAmount,
                    header: "Amount in stash"),
                SizedBox(height: 15),
                Container(

                  child: StashDropDownField(
                    dataSource: reserveState.stashType ,
                    value: stashType,
                    fillColor: Color(0xffF5F9FF),
                    titleText: "Type",
                    hintText: "",
                    textField: 'name',
                    valueField: 'code',
                    onChanged: (value) {
                      print("bills category: $value");
                      setState(() {
                        stashType = value;
                      });


                    },
                  ),
                ),

                SizedBox(height: 15),
                stashType?.stash_type_name  == "Automatic" ?
                Column(
                  children: [
                    CustomDropDown<String>(
                      intialValue: CustomDropDownItem<String>(value:"" , text: isLoading ? "Loading" : "Select Stash frequency"),
                      suffix: isLoading ? CupertinoActivityIndicator()  :null ,
                      items: [].map((e) {
                        return CustomDropDownItem<String>(
                            text: e.stash_type_name,
                            value: e
                        );
                      }).toList(),
                      onSelected: (value) {
                        setState(() {
                          // stashType   = value ;

                        });
                      },
                      header: "Select Stash frequency",
                    ),

                    SizedBox(height: 15),
                    CustomTextField(

                        textEditingController: amountControllerAutomatic,
                        validator: (v){
                          if(v =="0.00"){
                            return "Amount is required";
                          }
                          return null;

                        },
                        header: "Enter Amount to be deducted Automatically"),
                  ],
                ): Container(),
                SizedBox(height: 20),
              ],
            ),
          ),
          CustomButton(
            text: "Update Reserve",
            color: cyan,
            onPressed: () {


            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // title.text = widget.reserveDetails?.title;
    // description.text = widget.reserveDetails?.description;
    // stashAmount.text = widget.reserveDetails.stash_amount;
    // amount.text = widget.reserveDetails?.amount;



    // if(reserveState.stashType?.isEmpty || reserveState.stashType == null){
      fetchStashType();
    // }



  }



  fetchStashType()async{
    setState(() {
      isLoading = true;
    });
    var result = await  reserveState.getstashType(token: loginState.user.token);
    setState(() {
      isLoading = false;
    });

    if(result["error"] == false){
      stashType = reserveState.stashType[reserveState.stashType.indexWhere((b) =>
      "${b.stash_type_id}" == "${widget.reserveDetails.stash_type}")];
      print("stp $stashType");

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
//      CommonUtils.showMsg(body: result["message"]  ?? 'tt', context: context, scaffoldKey: _scaffoldKey,snackColor : Colors.red );

    }
  }
}
