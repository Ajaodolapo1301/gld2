import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glade_v2/core/models/apiModels/Personal/ReserveFund/reserve.dart';
import 'package:glade_v2/pages/personal/reserve_funds/create_new_reserve_page.dart';
import 'package:glade_v2/pages/personal/reserve_funds/view_reserve/view_reserve_page.dart';
import 'package:glade_v2/provider/Personal/reserveState.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/reuseables/dialogPopup.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/myUtils/myUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:provider/provider.dart';

class ReserveFundsPage extends StatefulWidget {
  @override
  _ReserveFundsPageState createState() => _ReserveFundsPageState();
}

class _ReserveFundsPageState extends State<ReserveFundsPage>  with AfterLayoutMixin<ReserveFundsPage>{
  ReserveState reserveState;
  LoginState loginState;
  AppState appState;
  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);
    reserveState = Provider.of<ReserveState>(context);
    loginState = Provider.of<LoginState>(context);
    return Scaffold(
        key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: isLoading ? Center(child: CircularProgressIndicator()) : Column(
            children: [
              SizedBox(height: 10),
              Header(
                text: "Stash Funds",
              ),
              SizedBox(height: 10),

              Expanded(
                child: Builder(
                  builder: (context) {
                    bool isEmpty = false;
//
                    if (reserveState.reserve.isNotEmpty) {
                      return ListView.separated(
                        itemBuilder: (context, index) {
                          return reserveItem(

                            reserve: reserveState.reserve[index],
                            title: reserveState.reserve[index].title,
                            cost: reserveState.reserve[index].stash_amount,
                            amountSaved: reserveState.reserve[index].amount,
                            type: reserveState.reserve[index].stash_type == 1 ? "Automatic" : "Manual",
                            isActive: reserveState.reserve[index].reserve_status == 1 ? true : false,
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 20),
                        itemCount: reserveState.reserve.length,
                      );
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/images/pig.svg"),
                        SizedBox(height: 5),
                        Text(
                          "No Reserve Fund Yet.",
                          style: TextStyle(
                              color: blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                        Text(
                          "Click the button below to create new stash and \nget started",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: blue, fontSize: 11),
                        )
                      ],
                    );
                  },
                ),
              ),
              CustomButton(
                text: "Create New Reserve",
                color: cyan,
                onPressed: () {
                  pushTo(context, CreateNewReservePage());
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget reserveItem(
      {String title,
      String cost,
      String amountSaved,
      String type,
      bool isActive,
       Reserve reserve
      }) {
    return GestureDetector(
      onTap: (){
        pushTo(context, ViewReservePage(
          reserve: reserve,
        ));
      },
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: lightBlue,
          border: Border.all(
            color: borderBlue.withOpacity(0.05),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$title",
                    style: TextStyle(fontSize: 12, color: blue),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "NGN ${MyUtils.formatAmount(cost)}",
                    style: TextStyle(
                        color: blue, fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      text: "$type - ",
                      style: TextStyle(color: blue, fontSize: 12),
                      children: [
                        TextSpan(
                          text: isActive ? "ACTIVE" : "INACTIVE",
                          style: TextStyle(
                            color: isActive ? barGreen : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "NGN ${MyUtils.formatAmount(amountSaved)}",
                  style: TextStyle(color: barGreen, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Saved",
                  style: TextStyle(color: blue, fontSize: 11),
                )
              ],
            ),
            SizedBox(width: 10),
            Icon(
              Icons.arrow_forward_ios,
              size: 15,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }



  fetchreserves()async{
    setState(() {
      isLoading = true;
    });
    var result = await  reserveState.getReserves(token: loginState.user.token);
    setState(() {
      isLoading = false;
    });

    if(result["error"] == false){

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

  @override
  void afterFirstLayout(BuildContext context) {
//      if(reserveState.reserve?.isEmpty || reserveState.reserve == null){
        fetchreserves();
//      }
  }


}
