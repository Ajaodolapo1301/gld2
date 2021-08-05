import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:glade_v2/api/AirtimeAndBills/BillsSingleton.dart';
import 'package:glade_v2/core/models/apiModels/AirtimeAndBills/airtimeAndBills.dart';
import 'package:glade_v2/pages/business/airtime_and_bills/tabs/history_tab.dart';
import 'package:glade_v2/pages/business/airtime_and_bills/tabs/pay_bills_tab.dart';
import 'package:glade_v2/provider/airtimeAndBills.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/reuseables/dialogPopup.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:provider/provider.dart';

class AirtimeAndBillsPage extends StatefulWidget {
  @override
  _AirtimeAndBillsPageState createState() => _AirtimeAndBillsPageState();
}

class _AirtimeAndBillsPageState extends State<AirtimeAndBillsPage> with TickerProviderStateMixin, AfterLayoutMixin<AirtimeAndBillsPage> {

  TabController tabController;
  LoginState loginState;
  AirtimeAndBillsState airtimeAndBillsState;
  BillsSingleton billsSingleton = BillsSingleton();
  AppState appState;
  BillsInfo billsInfo;

 bool isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  List<Categories> categories = [];
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    tabController.dispose();
  }


  // @override
  // void dispose() {
  //   FocusScope.of(context).unfocus();
  //   super.dispose();
  // }





  @override
  Widget build(BuildContext context) {
    airtimeAndBillsState = Provider.of<AirtimeAndBillsState>(context);
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
                text: "Airtime & Bills",
              ),
              SizedBox(height: 10),
              TabBar(
                controller: tabController,
                isScrollable: true,
                indicatorColor: orange,
                labelColor: blue,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  Tab(text: "Pay Bills"),
                  Tab(text: "History"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    PayBillsTab(
                     // isLoading: isLoading,
                     //  categories: categories,
                     //  billsInfo: billsInfo,
                    ),
                    AirtimeAndBillsHistoryTab(),
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
//     if (billsSingleton.billsInfo == null || billsSingleton.categories.isEmpty) {
//       // load if it hasn't been loaded before
// //      print("${billsSingleton.billsInfo} ${billsSingleton.categories}");
//       load().then((_) {
//         setState(() {
//           billsInfo = billsSingleton.billsInfo;
//           categories = billsSingleton.categories;
//         });
//       });
//     } else {
//       setState(() {
//        billsInfo = billsSingleton.billsInfo;
//        categories = billsSingleton.categories;
//       });
//     }
  }



  // Future load() async {
  //   print("calling");
  //   setState(() {
  //     isLoading = true;
  //   });
  //   var result = await airtimeAndBillsState.getBills(token: loginState.user.token);
  //
  //   setState(() {
  //     isLoading = false;
  //   });
  //
  //   try {
  //     setState(() {
  //       if (result["error"] ==false) {
  //
  //         billsSingleton.billsInfo = result["bills"];
  //        billsSingleton.categories =  billsSingleton.billsInfo.data.categories;
  //       }else if(result["error"] == true && result["statusCode"] ==401) {
  //         showDialog(
  //             barrierDismissible: false,
  //             context: context,
  //             child: dialogPopup(
  //                 context: context,
  //                 body: result["message"]
  //             ));
  //       }else{
  //         pop(context);
  //         CommonUtils.showMsg(body: result["message"], scaffoldKey: _scaffoldKey, snackColor: Colors.red);
  //       }
  //     });
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }


}
