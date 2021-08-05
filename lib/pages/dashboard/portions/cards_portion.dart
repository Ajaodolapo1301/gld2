import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/virtualCardList.dart';
import 'package:glade_v2/pages/virtual_cards/create_virtual_card/create_virtual_card_page.dart';
import 'package:glade_v2/pages/virtual_cards/view_virtual_card/view_virtual_card_page.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/Business/virtualCardState.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/reuseables/dialogPopup.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/myUtils/myUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/account_details_view.dart';
import 'package:glade_v2/utils/widgets/body_modal_not_live.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class CardsPortion extends StatefulWidget {
  const CardsPortion({Key key}) : super(key: key);

  @override
  _CardsPortionState createState() => _CardsPortionState();
}

class _CardsPortionState extends State<CardsPortion> with  AfterLayoutMixin<CardsPortion> {
 LoginState loginState;
 VirtualCardState virtualCardState;
 bool isEmpty = true;

 AppState appState;
  List<VirtualCardList> virtualCardList = [];
  bool isLoading = false;
BusinessState businessState;
 final _formKey = GlobalKey<FormState>();
 final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // super.build(context);
    virtualCardState = Provider.of<VirtualCardState>(context);
    businessState = Provider.of<BusinessState>(context);
    loginState = Provider.of<LoginState>(context);
    appState = Provider.of<AppState>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(height: 20),
          Text(
            "Virtual Cards",
            style: TextStyle(
                color: blue, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Builder(builder: (context) {
            if(isLoading){
              return Center(
                child: CircularProgressIndicator(backgroundColor: blue,),
              );

            }else if (virtualCardList.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 5),
                    Text(
                      "No Virtual Card Found",
                      style: TextStyle(
                          color: blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                    Text(
                      "Click \"Create New Card\" below to \ncreate a Virtual Card",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: blue, fontSize: 11),
                    )
                  ],
                );
              }
              return ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                  height: 20,
                ),
                itemCount: virtualCardState.virtualCardList.length,
                itemBuilder: (context, index) {
                  if (index == 9) {
                    return SizedBox(height: 40);
                  }
                  // else if(virtualCardList[index].card_status == 0){
                  //   return null;
                  // }
                  return cardItem(context, virtualCardState.virtualCardList[index]);
                },
              );
            }),
          ),
       isLoading ? SizedBox():   CustomButton(
            text: "Create New Card",
            onPressed: () {
                if(loginState.user.compliance_status == "approved"){
                  pushTo(context, CreateVirtualCardPage());
                }else{
                  CommonUtils.modalBottomSheetMenu(context: context,  body: buildModal(text: "Oh, Merchant not enabled for transaction!", subText: "dbfhbdf", status: loginState.user.compliance_status));
                }
            },
            color: cyan,
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget cardItem(BuildContext context, VirtualCardList virtualCardList) {
    return GestureDetector(
      onTap: () {
        pushTo(context, ViewVirtualCardPage(
          virtualCardId: virtualCardList.card_id,
        ));
      },
      child: Container(
        padding: EdgeInsets.all(20),
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
                    MyUtils.formatDate(virtualCardList.created_at,),
                    style: TextStyle(color: blue, fontSize: 10),
                  ),
                  SizedBox(height: 3),
                  Text(
                    virtualCardList.masked_pan,
                    style: TextStyle(color: blue),
                  )
                ],
              ),
            ),
            Text(
              virtualCardList.card_status == 1 ? "Active" : "Inactive",
              style: TextStyle(color: blue, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 10),
            Icon(
              Icons.arrow_forward_ios,
              size: 10,
            )
          ],
        ),
      ),
    );
  }

  // @override
  // bool get wantKeepAlive => true;

  @override
  void afterFirstLayout(BuildContext context) {
    getallVcards();
  }


  getallVcards()async{

    setState(() {
      isLoading = true;
    });
    var result = await virtualCardState.getListOfCard(token: loginState.user.token, business_uuid: businessState?.business?.business_uuid ?? "", isPersonal: businessState.business == null ? true: appState.isPersonal );
    setState(() {
      isLoading = false;
    });
      if(result["error"] == false){
        setState(() {
          virtualCardList = result['virtualCardList'];
        });
      }else if(result["error"] == true && result["statusCode"] ==401) {
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
        CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );
      }

  }

}
