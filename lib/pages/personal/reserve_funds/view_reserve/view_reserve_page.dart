import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glade_v2/core/models/apiModels/Personal/ReserveFund/reserve.dart';
import 'package:glade_v2/pages/personal/reserve_funds/view_reserve/tabs/missedReserve.dart';
import 'package:glade_v2/pages/personal/reserve_funds/view_reserve/tabs/reserve_transaction_page.dart';
import 'package:glade_v2/pages/personal/reserve_funds/view_reserve/tabs/view_reserve_details_tab.dart';
import 'package:glade_v2/provider/Personal/reserveState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/reuseables/dialogPopup.dart';
import 'package:glade_v2/utils/functions/bottom_sheet_utils.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:provider/provider.dart';

class ViewReservePage extends StatefulWidget {
  Reserve reserve;
  ViewReservePage({this.reserve});
  @override
  _ViewReservePageState createState() => _ViewReservePageState();
}

class _ViewReservePageState extends State<ViewReservePage>
    with TickerProviderStateMixin, AfterLayoutMixin<ViewReservePage> {
  TabController tabController;
  ReserveState reserveState;
  LoginState loginState;
  ReserveDetails reserveDetails;
 bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    appState = Provider.of<AppState>(context);
    reserveState = Provider.of<ReserveState>(context);
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
                text: "Your Reserve",
              ),
              SizedBox(height: 10),
              TabBar(
                controller: tabController,
                isScrollable: true,
                indicatorColor: orange,
                labelColor: blue,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  Tab(
                    text: "Details",
                  ),
                  Tab(text: "Transactions"),
                  Tab(text: "Missed"),
                ],
              ),
              GestureDetector(
                onTap: isLoading ? null : ()   {
                 showReserveActionsBottomSheet(context, reserveDetails);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SvgPicture.asset(
                        "assets/images/virtual_cards/more.svg",
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Action",
                        style: TextStyle(
                          color: blue,
                        ),
                      )
                    ],
                  ),
                ),
              ),
     isLoading ? CupertinoActivityIndicator():         Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    ViewReserveDetailsTab( reserveDetails:reserveDetails),
                    ReserveTransactionsTab(),
                    ReserveMissed(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    fetchreservesDetails();
  }

  fetchreservesDetails()async{
    setState(() {
      isLoading = true;
    });
    var result = await  reserveState.getReserveDetails(token: loginState.user.token, id: widget.reserve.id);
    setState(() {
      isLoading = false;
    });

    if(result["error"] == false){
        setState(() {
          reserveDetails  = result["reserveDetails"];
        });

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
      CommonUtils.showMsg(body: result["message"]  ?? 'An Error occurred', context: context, scaffoldKey: _scaffoldKey,snackColor : Colors.red );

    }
  }


}
