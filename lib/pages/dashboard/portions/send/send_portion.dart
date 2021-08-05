import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/BankTransferMode.dart';
import 'package:glade_v2/pages/dashboard/portions/send/tabs/bulk_transfer_tab.dart';
import 'package:glade_v2/pages/dashboard/portions/send/tabs/fund_transfer_tab.dart';
import 'package:glade_v2/pages/dashboard/portions/send/tabs/fund_transfer_history_tab.dart';
import 'package:glade_v2/provider/Business/fundTransferState.dart';
import 'package:glade_v2/provider/Personal/fundAccountState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
class SendPortion extends StatefulWidget {
  @override
  _SendPortionState createState() => _SendPortionState();
}

class _SendPortionState extends State<SendPortion>
    with TickerProviderStateMixin, AfterLayoutMixin<SendPortion> {
  TabController tabController;
  FundTransferState fundTransferState;
  List<BankTransferMode>  transferMode =  [];
  LoginState loginState;
  bool isLoadingMode = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isBanksLoading = false;
  bool isCountriesLoading = false;
  bool isTransferMethodLoading = false;
  bool isBeneficiaryListLoading = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loginState = Provider.of<LoginState>(context);
    fundTransferState = Provider.of<FundTransferState>(context);

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              "Fund Transfer",
              style: TextStyle(
                color: blue,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
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
                  text: "Fund transfer",
                ),
                Tab(text: "Bulk Transfer"),
                Tab(text: "History"),
              ],
            ),
             Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  FundTransferTab(),
                  BulkTransferTab(),
                  FundTransferHistoryTab(scaffoldKey: _scaffoldKey,)
                ],
              ),
            ),
          ],
        ),
      )
    );
  }



  @override
  void afterFirstLayout(BuildContext context) {
//   if(fundTransferState.bankTransferMode.isEmpty || fundTransferState.bankTransferMode == null){
//
// //  fetchbanks();
// //  fetchCountries();
// //   fetchbeneficiaryList();
//   }






  }












}
