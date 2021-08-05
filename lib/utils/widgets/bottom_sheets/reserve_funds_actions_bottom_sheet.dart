import 'package:flutter/material.dart';
import 'package:glade_v2/core/models/apiModels/Personal/ReserveFund/reserve.dart';
import 'package:glade_v2/pages/personal/reserve_funds/fund_reserve.dart';
import 'package:glade_v2/pages/personal/reserve_funds/reserve_funds_page.dart';
import 'package:glade_v2/pages/personal/reserve_funds/view_reserve/withdraw_reserve.dart';
import 'package:glade_v2/pages/virtual_cards/view_virtual_card/options/withdraw_from_virutal_card_page.dart';
import 'package:glade_v2/provider/Personal/reserveState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import '../custom_button.dart';

class ReserveFundsActionBottomSheet extends StatefulWidget {
  final Color textColor;
   final ReserveDetails reserveDetails;

  const ReserveFundsActionBottomSheet({Key key, this.textColor, this.reserveDetails})
      : super(key: key);

  @override
  _ReserveFundsActionBottomSheetState createState() => _ReserveFundsActionBottomSheetState();
}

class _ReserveFundsActionBottomSheetState extends State<ReserveFundsActionBottomSheet> {

  ReserveState reserveState;
  LoginState loginState;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    reserveState = Provider.of<ReserveState>(context);
    loginState = Provider.of<LoginState>(context);
    return Container(
      height: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.reserveDetails.title,
            style: TextStyle(
                color: blue, fontSize: 15, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: "Fund",
                  onPressed: widget.reserveDetails.reserve_status == 0  ? null : ()  {
                    pushTo(context, FundReserve(reserveDetails: widget.reserveDetails,));
                  },
                  color: cyan,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: CustomButton(
                  onPressed: widget.reserveDetails.reserve_status == 0  ? null : ()  {
                    pushTo(context, WithdrwReserve(reserveDetails: widget.reserveDetails,));
                  },
                  text: "Withdraw",

                  color: blue,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [

              Expanded(
                child: CustomButton(
                  text: isLoading ? "Loading..." :  widget.reserveDetails.reserve_status == 0  ? "Enable" : "Disable",
                  onPressed: () {

                    widget.reserveDetails.reserve_status == 0  ? enableReserve() :      disableReserve();

                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  disableReserve() async{
    setState(() {
     isLoading = true;

    });
    var result = await reserveState.disableReserve(token: loginState.user.token, reserve_id: widget.reserveDetails.id);
    setState(() {
      isLoading = false;
    });
      if(result["error"] == false){
        toast("Disabled!");
        Future.delayed(const Duration(milliseconds: 500), () {
          pop(context);
          pop(context);
          pushReplacementTo(context, (ReserveFundsPage()), PushStyle.cupertino);
        });
      }else{


      }
  }

  enableReserve() async{
    setState(() {
      isLoading = true;

    });
    var result = await reserveState.enableReserve(token: loginState.user.token, reserve_id: widget.reserveDetails.id);
    setState(() {
      isLoading = false;
    });
    if(result["error"] == false){
      toast("Enabled!");
      Future.delayed(const Duration(milliseconds: 500), () {
        pop(context);
        pop(context);
        pushReplacementTo(context, (ReserveFundsPage()), PushStyle.cupertino);
      });
    }else{


    }
  }









}
