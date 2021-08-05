import 'package:flutter/material.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/VirtualCardModel.dart';
import 'package:glade_v2/pages/dashboard/dashboard_page.dart';
import 'package:glade_v2/pages/virtual_cards/view_virtual_card/options/withdraw_from_virutal_card_page.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/Business/virtualCardState.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import '../custom_button.dart';

class MoreFromVirtualCardBottomSheet extends StatefulWidget {
  final Color textColor;
  final VirtualCardModel virtualCardModel;
    final  GlobalKey scaffoldKey;
  const MoreFromVirtualCardBottomSheet({Key key, this.textColor, this.virtualCardModel, this.scaffoldKey})
      : super(key: key);

  @override
  _MoreFromVirtualCardBottomSheetState createState() => _MoreFromVirtualCardBottomSheetState();
}

class _MoreFromVirtualCardBottomSheetState extends State<MoreFromVirtualCardBottomSheet> {
  VirtualCardState virtualCardState;
  LoginState loginState;
  AppState appState;
  BusinessState businessState;
  @override
  Widget build(BuildContext context) {
    virtualCardState = Provider.of<VirtualCardState>(context);
    loginState = Provider.of<LoginState>(context);

    businessState = Provider.of<BusinessState>(context);
    appState = Provider.of<AppState>(context);
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
            "More",
            style: TextStyle(
                color: blue, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          CustomButton(
            text: "Withdraw Funds",
            onPressed: () {

              pop(context);
              pushTo(context, WithdrawFromVirtualCardPage(
                virtualCardModel: widget.virtualCardModel ,
              ));
            },
            type: ButtonType.outlined,
          ),
          SizedBox(height: 10),
          CustomButton(
            text: "Terminate Card",
            onPressed: () {
          pop(context);
          terminateVcard();
        // print("terminate");
//          Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

terminateVcard()async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result = await  virtualCardState.terminateCard(card_id: widget.virtualCardModel.card_id, token: loginState.user.token, isPersonal: appState.isPersonal, business_uuid: businessState.business?.business_uuid ?? "");
    pop(context);
    if(result["error"] == false){
      toast("Terminated successful");

      pop(context);
      pushReplacementTo(context, DashboardPage(
        // virtualCardId: widget.virtualCardModel.card_id,
      ));

    }else{
      CommonUtils.showMsg(body: result["message"] , context: context, scaffoldKey: widget.scaffoldKey,snackColor : Colors.red );
    }
  }
}
