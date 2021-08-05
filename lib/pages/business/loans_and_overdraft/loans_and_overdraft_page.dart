import 'package:flutter/material.dart';
import 'package:glade_v2/pages/business/loans_and_overdraft/tabs/loan_and_overdraft_history_tab.dart';
import 'package:glade_v2/pages/business/loans_and_overdraft/tabs/request/request_tab.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoansAndOverdraftPage extends StatefulWidget {
  @override
  _LoansAndOverdraftPageState createState() => _LoansAndOverdraftPageState();
}

class _LoansAndOverdraftPageState extends State<LoansAndOverdraftPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TabController tabController;


  double textScale = 1.0;
  void initTextScale() async {
    var pref = await SharedPreferences.getInstance();
    setState(() {
      textScale = pref.getDouble("textScaleFactor") ?? 1.0;
    });
  }
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    initTextScale();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: textScale),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 10),
                Header(
                  text: "Loan & Overdraft",
                ),
                SizedBox(height: 10),
                TabBar(
                  controller: tabController,
                  isScrollable: true,
                  indicatorColor: orange,
                  labelColor: blue,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    Tab(text: "Request",),
                    Tab(text: "History"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      LoanAndOverdraftRequestTab(scaffoldKey: _scaffoldKey, formkey: _formKey,),
                      LoansAndOverdraftHistoryTab(scaffoldKey: _scaffoldKey,),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
