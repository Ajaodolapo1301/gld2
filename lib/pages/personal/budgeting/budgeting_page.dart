import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:glade_v2/core/models/apiModels/Personal/Budget/budget.dart';
import 'package:glade_v2/pages/personal/budgeting/update_budget_page.dart';
import 'package:glade_v2/provider/Personal/budgetState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/reuseables/dialogPopup.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/myUtils/myUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class BudgetingPage extends StatefulWidget {
  @override
  _BudgetingPageState createState() => _BudgetingPageState();
}

class _BudgetingPageState extends State<BudgetingPage>  with AfterLayoutMixin<BudgetingPage>{
  BudgetState budgetState;
  LoginState loginState;
Budget budget;
  bool isLoading= false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
      budgetState = Provider.of<BudgetState>(context);
      loginState = Provider.of<LoginState>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body:   SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 10),
              Header(
                text: "Budgeting",
              ),
              SizedBox(height: 10),
              isLoading ? Center(child: CircularProgressIndicator(),) :  budget == null   ? Center(child: Text("Something went Wrong "),) :     Expanded(
                child: Column(
                  children: [
                    Card(
                      elevation: 10,
                      shadowColor: Colors.grey[50].withOpacity(0.4),
                      child: Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: Text(
                                  "Set a Budget",
                                  style: TextStyle(fontSize: 12, color: cyan),
                                ),
                                decoration: BoxDecoration(
                                    color: lightBlue,
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            ),
                            SizedBox(height: 1),
                            Text(
                              "Available Budget",
                              style: TextStyle(color: blue, fontSize: 13),
                            ),
                            SizedBox(height: 2),



                            Text(
                              budget.available == null ? "NGN 0.00" : "NGN ${budget.available}",
                              style: TextStyle(
                                color: blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            SizedBox(height: 10),
                            LinearPercentIndicator(
                              // width: 200,
                              width: MediaQuery.of(context).size.width / 1.3,
                              animation: true,
                              backgroundColor: Colors.green.withOpacity(0.3),
                              lineHeight: 20.0,
                              animationDuration: 2500,
                              // percent: 0.0,
                              percent: budget.available_percentage == null ? 0.0 :  0.3,
                              // double.parse( budget.available_percentage),
                              // center: Text("80.0%"),
                              linearStrokeCap: LinearStrokeCap.roundAll,
                              progressColor: Colors.green,
                            ),
                            SizedBox(height: 10),
                            RichText(
                              text: TextSpan(
                                text:  " NGN  ${budget?.spent != null ? MyUtils.formatAmount(budget.spent) : "0.00"}",
                                style: TextStyle(
                                  color: barGreen,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'DMSans'
                                ),
                                children: [
                                  TextSpan(
                                    text: " spent of NGN  ${budget?.budget != null ? MyUtils.formatAmount(budget.budget) : "0.00"}",
                                    style: TextStyle(
                                      color: blue,
                                      fontWeight: FontWeight.normal
                                    )
                                  )
                                ]
                              ),
                            )
                          ],
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Spacer(),
                    CustomButton(
                      text: "Set a budget",
                      onPressed: () {
                        pushTo(context, UpdateBudgetPage(scaffoldKey: _scaffoldKey,)).then((value) {

                          getBudget();
                        });
                      },
                      color: cyan,
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              )

              // Expanded(
              //   child: FutureBuilder(
              //     future: budgetState.getBudget(token: loginState.user.token),
              //     builder: (context, snapshot){
              //             if( snapshot.connectionState == ConnectionState.waiting){
              //             return  Center(child: Text('Please wait its loading...'));
              //             }else{
              //             if (snapshot.hasError){
              //               print(snapshot.hasError);
              //               return Center(child: Text('Error: ${snapshot.error}'));
              //             }
              //
              //             else{
              //               print(snapshot.data);
              //               Budget budget = snapshot.data["budgets"];
              //               return Column(
              //                 children: [
              //                   Card(
              //                     elevation: 10,
              //                     shadowColor: Colors.grey[50].withOpacity(0.4),
              //                     child: Container(
              //                       width: double.maxFinite,
              //                       padding: EdgeInsets.all(15),
              //                       child: Column(
              //                         crossAxisAlignment: CrossAxisAlignment.start,
              //                         children: [
              //                           Align(
              //                             alignment: Alignment.centerRight,
              //                             child: Container(
              //                               padding: EdgeInsets.symmetric(
              //                                   vertical: 10, horizontal: 10),
              //                               child: Text(
              //                                 "Set a Budget",
              //                                 style: TextStyle(fontSize: 12, color: cyan),
              //                               ),
              //                               decoration: BoxDecoration(
              //                                   color: lightBlue,
              //                                   borderRadius: BorderRadius.circular(5)),
              //                             ),
              //                           ),
              //                           SizedBox(height: 1),
              //                           Text(
              //                             "Available Budget",
              //                             style: TextStyle(color: blue, fontSize: 13),
              //                           ),
              //                           SizedBox(height: 2),
              //
              //
              //
              //                           Text(
              //                             budget?.available == null ? "NGN 0.00" : "NGN ${budget.available}",
              //                             style: TextStyle(
              //                               color: blue,
              //                               fontWeight: FontWeight.bold,
              //                               fontSize: 25,
              //                             ),
              //                           ),
              //                           SizedBox(height: 10),
              //                           LinearPercentIndicator(
              //                             // width: 200,
              //                             width: MediaQuery.of(context).size.width / 1.3,
              //                             animation: true,
              //                             backgroundColor: Colors.green.withOpacity(0.3),
              //                             lineHeight: 20.0,
              //                             animationDuration: 2500,
              //                             percent: 0.5,
              //                             // budget.available_percentage == null ? 0.0 :  double.parse( budget.available_percentage),
              //                             // center: Text("80.0%"),
              //                             linearStrokeCap: LinearStrokeCap.roundAll,
              //                             progressColor: Colors.green,
              //                           ),
              //                           //   AnimatedContainer(
              //                           //   height: 10,
              //                           //   width: 5,
              //                           //   color: barGreen,
              //                           //   duration: Duration(seconds: 1),
              //                           // ),
              //                           SizedBox(height: 10),
              //                           RichText(
              //                             text: TextSpan(
              //                                 text: "NGN${MyUtils.formatAmount(budget?.spent)}",
              //                                 style: TextStyle(
              //                                     color: barGreen,
              //                                     fontWeight: FontWeight.bold,
              //                                     fontFamily: 'DMSans'
              //                                 ),
              //                                 children: [
              //                                   TextSpan(
              //                                       text: " spent of NGN ${MyUtils.formatAmount(budget.budget)}",
              //                                       style: TextStyle(
              //                                           color: blue,
              //                                           fontWeight: FontWeight.normal
              //                                       )
              //                                   )
              //                                 ]
              //                             ),
              //                           )
              //                         ],
              //                       ),
              //                     ),
              //                     shape: RoundedRectangleBorder(
              //                       borderRadius: BorderRadius.circular(10),
              //                     ),
              //                   ),
              //                   Spacer(),
              //                   CustomButton(
              //                     text: "Set a budget",
              //                     onPressed: () {
              //                       pushTo(context, UpdateBudgetPage(scaffoldKey: _scaffoldKey,));
              //                     },
              //                     color: cyan,
              //                   ),
              //                   SizedBox(height: 20),
              //                 ],
              //               );
              //             }
              //            // / snapshot.data  :- get your object which is pass from your downloadData() function
              //             }
              //
              //
              //
              //     },
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
  getBudget();
  }





    getBudget()async{
    setState(() {
      isLoading = true;
    });
    var result = await budgetState.getBudget(token: loginState.user.token);
    setState(() {
      isLoading = false;
    });
        if(result["error"] == false){
          setState(() {
    budget = result["budgets"];
          });
        }else if (result["statusCode"] == 401){
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
          CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );
        }

  }
}
