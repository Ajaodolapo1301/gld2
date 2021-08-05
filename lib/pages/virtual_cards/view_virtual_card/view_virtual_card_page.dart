import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/VirtualCardModel.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/VirtualTransaction.dart';
import 'package:glade_v2/pages/virtual_cards/view_virtual_card/options/fund_virutal_card_page.dart';
import 'package:glade_v2/pages/virtual_cards/view_virtual_card/options/see_more__virtual_card_transactions_page.dart';
import 'package:glade_v2/pages/virtual_cards/view_virtual_card/options/show_virtual_card_page.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/Business/virtualCardState.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/reuseables/dialogPopup.dart';
import 'package:glade_v2/reuseables/virtual_card_widget.dart';
import 'package:glade_v2/utils/functions/bottom_sheet_utils.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/myUtils/myUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/header.dart' show Header;
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:provider/provider.dart';

class ViewVirtualCardPage extends StatefulWidget {
  final virtualCardId;
  ViewVirtualCardPage({this.virtualCardId});
  @override
  _ViewVirtualCardPageState createState() => _ViewVirtualCardPageState();
}

class _ViewVirtualCardPageState extends State<ViewVirtualCardPage> with AfterLayoutMixin<ViewVirtualCardPage> {
  PageController controller = PageController();
LoginState loginState;
AppState appState;
BusinessState businessState;
  int index = 0;
  VirtualCardState virtualCardState;
  VirtualCardModel virtualCardModel;
 List<VirtualCardTransaction> virtualCardTransaction = [];
  bool isLoading = true;
  bool isTransactionLoading = false;
  bool freezed = false;
  var colorCode;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    loginState = Provider.of<LoginState>(context);
    virtualCardState = Provider.of<VirtualCardState>(context);
    appState =Provider.of<AppState>(context);
    businessState =Provider.of<BusinessState>(context);
    // print(virtualCardModel.is_active);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child:  Container(
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Header(
                  text: "Card",
                ),
              ),

              isLoading ? Center(child: CircularProgressIndicator()) :  virtualCardModel == null  ? Center(
                child: Text("Something went wrong"),
              )    :     Expanded(
                child: Column(
                    children: [
                      SizedBox(height: 30),
                      // Container(
                      //   margin: EdgeInsets.only(right: 20),
                      //   alignment: Alignment.centerRight,
                      //   child: Text(
                      //     virtualCardModel?.card_state,
                      //     style: TextStyle(
                      //       color: cyan,
                      //       fontSize: 13,
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 8),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${loginState.user.firstname} ${loginState.user.lastname} ",
                                    style: TextStyle(
                                        color: blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                   virtualCardModel?.card_title ?? "",
                                    style: TextStyle(color: blue),
                                  )
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                             "${virtualCardModel?.currency} ${MyUtils.formatAmount(virtualCardModel?.balance)} "?? "0.00",
                                  style: TextStyle(
                                      color: blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  "Balance",
                                  style: TextStyle(color: blue),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: ListView(
                          children: [
                            VirtualCardWidget(
                              virtualCardModel: virtualCardModel,
                              colorCode: colorCode,
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding:
                              EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      pushTo(context, ShowVirtualCardPage(
                                      virtualCardModel: virtualCardModel,
                                      ));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/images/virtual_cards/show.svg",
                                            width: 25,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            "Show",
                                            style: TextStyle(color: blue),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap:   freezed || virtualCardModel.is_active == false   ? null : () {
                                      pushTo(context, FundVirtualCardPage(
                                        virtualCardModel: virtualCardModel,
                                      ));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/images/virtual_cards/fund.svg",
                                            color:   freezed || virtualCardModel.is_active == false  ? orange.withOpacity(0.5): null,
                                            width: 20,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            "Fund",
                                            style: TextStyle(color: blue),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){

                                      freezed || virtualCardModel.is_active == false  ? unfreeze() :     freeze();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/images/virtual_cards/freeze.svg",
                                            width: 20,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                          freezed || virtualCardModel.is_active == false ? "UnFreeze" : "Freeze",
                                            style: TextStyle(color: blue),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap:     freezed || virtualCardModel.is_active == false  ? null : () {
                                      showMoreFromVirtualCardBottomSheet(context, virtualCardModel, _scaffoldKey);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/images/virtual_cards/more.svg",
                                       color:    freezed || virtualCardModel.is_active == false ? orange.withOpacity(0.5) : null,

                                            width: 20,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            "More",
                                            style: TextStyle(color:  blue),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              height: 40,
                              color: lightBlue,
                              child: Center(
                                child: Row(
                                  children: [
                                    SizedBox(width: 15),
                                    Text(
                                      "RECENT ACTIVITY",
                                      style: TextStyle(
                                          color: blue,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Builder(builder: (context) {
                              bool isEmpty = false;

                              if(isTransactionLoading){
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 50),
                                    CupertinoActivityIndicator()
                                  ],
                                );
                              }
                             else if (virtualCardTransaction.isEmpty) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 50),
                                    Text(
                                      "No activity yet.",
                                      style: TextStyle(
                                          color: blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                  ],
                                );
                              }
                              return Column(
                                children: List.generate(
                                  virtualCardTransaction.length > 3  ? 3 : virtualCardTransaction.length,
                                      (index) => Column(
                                    children: [
                                      transactionItem(context, virtualCardTransaction[index]
                                      ),

                                      Divider()
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
               virtualCardTransaction.isEmpty ? Container() :       TextButton(
                        onPressed: () {
                          pushTo(context, SeeMoreVirtualCardTransactionsPage(
                            virtualCardTransaction: virtualCardTransaction,
                          ));
                        },
                        child: Text(
                          "SEE MORE",
                          style: TextStyle(color: cyan),
                        ),
                      ),
                    ],
                  ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget transactionItem(BuildContext context, VirtualCardTransaction virtualCardTransaction) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    MyUtils.formatDate(virtualCardTransaction.created_at)  ,
                    style: TextStyle(color: blue, fontSize: 10),
                  ),
                  SizedBox(height: 3),
                  Text(
                    virtualCardTransaction.product,
                    style: TextStyle(color: blue),
                  )
                ],
              ),
            ),
            Text(
              "  ${virtualCardTransaction.currency} ${virtualCardTransaction.amount.toString()}",
              style: TextStyle(color: blue, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    getSingleCard();

    getSingleCardTransaction();
    getallVcards();
  }


  // methods
  getallVcards()async{

    setState(() {
      // isLoading = true;
    });
    var result = await virtualCardState.getListOfCard(token: loginState.user.token, business_uuid: businessState.business.business_uuid, isPersonal: appState.isPersonal );
    setState(() {
      // isLoading = false;
    });
    if(result["error"] == false){
      setState(() {
        // virtualCardList = result['virtualCardList'];
      });
    }else{
      // CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );
    }

  }

  void getSingleCard()async {
    var result = await virtualCardState.getCardDetails(cardId: widget.virtualCardId, token: loginState.user.token, isPersonal: appState.isPersonal, business_uuid: businessState.business.business_uuid );
   setState(() {
     isLoading = false;
   });
    if(result["error"] == false){
      setState(() {
        virtualCardModel = result["virtualDetails"];
       colorCode = virtualCardModel.design_code?.substring(1);
      });
    }else if(result["error"] == true && result["statusCode"]== 401){
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

    else {
      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );

      Future.delayed(const Duration(seconds: 2), () {
      pop(context);
      });
    }
  }


  void getSingleCardTransaction()async {
    setState(() {
      isTransactionLoading = true;
    });
    var result = await virtualCardState.transactionList(card_id: widget.virtualCardId, token: loginState.user.token, business_uuid: businessState.business.business_uuid, isPersonal: appState.isPersonal);
    setState(() {
      isTransactionLoading = false;
    });
    if(result["error"] == false){
      setState(() {
        virtualCardTransaction = result["virtualCardTransaction"];

      });
    }else{
      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );

    }
  }

  freeze()async{
    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result = await virtualCardState.freezeCard(card_id: widget.virtualCardId, token: loginState.user.token, business_uuid: businessState.business.business_uuid, isPersonal: appState.isPersonal);
   Navigator.pop(context);
    setState(() {
      isLoading = false;
    });
    if(result["error"] == false){
        freezed = true;
      getSingleCard();
        CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.green );
    }else{
      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );

    }
  }


  unfreeze()async{
    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result = await virtualCardState.unfreezeCard(card_id: widget.virtualCardId, token: loginState.user.token, business_uuid: businessState.business.business_uuid, isPersonal: appState.isPersonal);
  Navigator.pop(context);
    setState(() {
      isLoading = false;
    });
    if(result["error"] == false){
      freezed = false;
      getSingleCard();
      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.green );
    }else{
      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );

    }
  }






}





