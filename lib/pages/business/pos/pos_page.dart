import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:glade_v2/pages/business/pos/tabs/history_tab.dart';
import 'package:glade_v2/pages/business/pos/tabs/request_pos_tab.dart';
import 'package:glade_v2/provider/Personal/posState.dart';

import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class POSPage extends StatefulWidget {
  @override
  _POSPageState createState() => _POSPageState();
}

class _POSPageState extends State<POSPage> with TickerProviderStateMixin, AfterLayoutMixin<POSPage>  {


  TabController tabController;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  POSState posState;
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    initTextScale();
    super.initState();
  }

  double textScale = 1.0;
  void initTextScale() async {
    var pref = await SharedPreferences.getInstance();
    setState(() {
      textScale = pref.getDouble("textScaleFactor") ?? 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    posState = Provider.of<POSState>(context);
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
                  text: "POS",
                ),
                SizedBox(height: 10),
                TabBar(
                  controller: tabController,
                  isScrollable: true,
                  indicatorColor: orange,
                  labelColor: blue,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    Tab(text: "Request POS",),
                    Tab(text: "History"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      RequestPOSTab(
                        scaffoldKey: _scaffoldKey,
                      ),
                      POSHistoryTAB(),
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

  @override
  void afterFirstLayout(BuildContext context) {

  }
  getHistoryPOS() {
// var result = posState.
  }
}
