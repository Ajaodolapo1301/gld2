import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:glade_v2/core/models/apiModels/Personal/Budget/budget.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_drop_down.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:glade_v2/provider/Personal/budgetState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';

import 'package:provider/provider.dart';
class UpdateBudgetPage extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldKey;
  UpdateBudgetPage({this.scaffoldKey});
  @override
  _UpdateBudgetPageState createState() => _UpdateBudgetPageState();
}

class _UpdateBudgetPageState extends State<UpdateBudgetPage> with AfterLayoutMixin<UpdateBudgetPage> {
 bool isCycleLoading = false;
 bool isActionLoading = false;
 BudgetState budgetState;
 LoginState loginState;
 GlobalKey<FormState> formKey = GlobalKey<FormState>();
 final _scaffoldKey = GlobalKey<ScaffoldState>();
  MoneyMaskedTextController amountController = MoneyMaskedTextController(
      decimalSeparator: ".", leftSymbol: "NGN ", thousandSeparator: ",");
  Cycle cycle;
  ActionModel actionModel;

  // List<Cycle> allcycle = [
  //   Cycle(
  //     cycle_id: "1",
  //     cycle_name: "monthly"
  //   ),
  //   Cycle(
  //       cycle_id: "2",
  //       cycle_name: "yearly"
  //   )
  // ];

 //
 // List<ActionModel> allActions = [
 //   ActionModel(
 //       action_id: "1",
 //       action_name: "once"
 //   ),
 //   ActionModel(
 //       action_id: "2",
 //       action_name: "Twice"
 //   )
 // ];

  @override
  Widget build(BuildContext context) {
    budgetState = Provider.of<BudgetState>(context);
    loginState = Provider.of<LoginState>(context);
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
                text: "Budgeting",
              ),
              SizedBox(height: 10),
              Expanded(
                child: Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      CustomTextField(
                        validator: (v){
                          if(v == "0.00"){
                            return "Empty";
                          }
                          return null;
                        },
                        textEditingController: amountController,
                        header: "Enter Amount",
                      ),
                      SizedBox(height: 15),
                      CustomDropDown<Cycle>(
                        suffix:  isCycleLoading ? CupertinoActivityIndicator() : null,
                                    intialValue: CustomDropDownItem(value: cycle , text:  isCycleLoading ? "Loading" : "hmm"),

                        header: "Cycle",

                       items: budgetState.cycle.map((e) {
                         return CustomDropDownItem(
                             text: e.cycle_name,
                             value: e
                         );
                       }).toList(),

                        // items: allcycle.map((e) {
                        //   return CustomDropDownItem(
                        //     text: e.cycle_name,
                        //     value: e
                        //     );
                        // }).toList(),
                        onSelected: (v) {
                          cycle = v;
                        },
                      ),
                      SizedBox(height: 15),
                      CustomDropDown<ActionModel>(
                        suffix:  isActionLoading ? CupertinoActivityIndicator() : null,
                                    intialValue: CustomDropDownItem(value: actionModel, text: isActionLoading ? "Loading.." : "Select an action"),

                        header: "Action when budget is exceeded?",


                         items: budgetState.actionList.map((e) {
                           return CustomDropDownItem(
                               text: e.action_name,
                               value: e
                           );
                         }).toList(),

                        // items: allActions.map((e) {
                        //   return CustomDropDownItem(
                        //     text: e.action_name,
                        //      value: e
                        //   );
                        // }).toList(),
                        onSelected: (v) {
                          actionModel = v;
              },
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
              CustomButton(
                text: "Update Budget",
                onPressed: () {
                    if(formKey.currentState.validate()){
                      updateBudget();
                    }

                },
              ),
              SizedBox(height: 10),
              CustomButton(
                text: "Reset Budget",
                type: ButtonType.outlined,
                onPressed: () {
                  resetBudget();
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }


  getCycle()async{
    setState(() {
      isCycleLoading = true;
    });
    var result = await budgetState.getCycle(token: loginState.user.token);
    setState(() {
      isCycleLoading = false;
    });
    if(result["error"] == false){
      setState(() {

      });
    }else{

      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );
    }

  }

  getAction()async{
    setState(() {
      isActionLoading = true;
    });
    var result = await budgetState.getAction(token: loginState.user.token);
    setState(() {
      isActionLoading = false;
    });
    if(result["error"] == false){
      setState(() {

      });
    }else{

      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );
    }

  }

 resetBudget()async{
   showDialog(
       context: this.context,
       barrierDismissible: false,
       builder: (BuildContext context) {
         return Preloader();
       });
   var result = await budgetState.deleteBudget(token: loginState.user.token);
Navigator.pop(context);
   if(result["error"] == false){

     setState(() {
       CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.green );
       Future.delayed(const Duration(milliseconds: 500), () {
      pop(context);
       });
     });
   }else{

     CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );
   }

 }

 updateBudget()async{
   showDialog(
       context: this.context,
       barrierDismissible: false,
       builder: (BuildContext context) {
         return Preloader();
       });
   var result = await budgetState.updateBudget(token: loginState.user.token, cycle_id: cycle.cycle_name.toLowerCase(), action_id: actionModel.action_id, amount:amountController.text.replaceAll("NGN", "").replaceAll(",", ""));
   Navigator.pop(context);
   if(result["error"] == false){
     setState(() {
       Navigator.pop(context);

       CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:widget.scaffoldKey, snackColor: Colors.green );
     });
   }else{

     CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );
   }

 }


  @override
  void afterFirstLayout(BuildContext context) {
      getAction();
          getCycle();
  }




}
