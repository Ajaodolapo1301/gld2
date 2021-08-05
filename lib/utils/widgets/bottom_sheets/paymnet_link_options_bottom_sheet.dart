import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glade_v2/core/models/apiModels/Business/PaymentLink/paymentLinkhistory.dart';
import 'package:glade_v2/core/models/apiModels/paymentLink/paymentLink.dart';
import 'package:glade_v2/main.dart';
import 'package:glade_v2/pages/business/payment_link/tabs/create_payment_link_tab.dart';
import 'package:glade_v2/pages/virtual_cards/view_virtual_card/options/withdraw_from_virutal_card_page.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/Business/paymentLinkState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/reuseables/dialogPopup.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../custom_button.dart';

class PaymentLinkOptionsBottomSheet extends StatefulWidget {
  final Color textColor;
  final PaymentLinkItem paymentLinkHistory;
  const PaymentLinkOptionsBottomSheet({Key key, this.textColor, this.paymentLinkHistory})
      : super(key: key);

  @override
  _PaymentLinkOptionsBottomSheetState createState() => _PaymentLinkOptionsBottomSheetState();
}

class _PaymentLinkOptionsBottomSheetState extends State<PaymentLinkOptionsBottomSheet> {
  PaymentLinkState paymentLinkState;
  LoginState loginState;
  BusinessState businessState;
  @override
  Widget build(BuildContext context) {
    paymentLinkState = Provider.of<PaymentLinkState>(context);
    businessState = Provider.of<BusinessState>(context);
    loginState = Provider.of(context);
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
            widget.paymentLinkHistory.name,
            style: TextStyle(
                color: blue, fontSize: 15, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: "Visit Link",
                  onPressed: () {
              _launchURL(widget.paymentLinkHistory);
                  },
                  color: cyan,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: CustomButton(
                  text: "Copy Link",
                  onPressed: () {
                    pop(context);
                    Clipboard.setData(
                      new ClipboardData(
                        text:  "https://pay.glade.ng/${widget.paymentLinkHistory.link}"
                      ),
                    );
                    toast("Copied to Clipboard");
                  },
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
                  text: "Edit",
                  onPressed: () {
                    pushTo(context, CreatePaymentLinkTab(paymentLink: widget.paymentLinkHistory,));
                  },
                  color: blue,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: CustomButton(
                  text: "Delete",
                  onPressed: () {
                    // pop(context);
                    delete(widget.paymentLinkHistory, context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

   delete(PaymentLinkItem paymentLinkItem, context ) async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var res = await paymentLinkState.deleteLink(token: loginState.user.token, link_id:paymentLinkItem.id, business_uuid:businessState.business.business_uuid);
      pop(context);
      if(res["error"] == false){
        CommonUtils.showAlertDialog(context: context, text: res["message"], onClose: (){
            pop(context);
                pop(context);
            pop(context);
        });
      }else if(res["error"] == true && res["statusCode"] == 401){
        // showDialog(
        //     barrierDismissible: false,
        //     context: context,
        //     child: dialogPopup(
        //         context: context,
        //         body: res["message"]
        //     ));
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_)=> dialogPopup(
                context: context,
                body: res["message"]
            )

        );
      }
  }

  _launchURL(PaymentLinkItem paymentLinkHistory) async {
    var url = "https://pay.glade.ng/${paymentLinkHistory.link}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
