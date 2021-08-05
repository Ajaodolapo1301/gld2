import 'package:flutter/material.dart';
import 'package:glade_v2/pages/business/invoices/tabs/create_invoice_tab.dart';
import 'package:glade_v2/pages/business/invoices/tabs/history_tab.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvoicesPage extends StatefulWidget {
  @override
  _InvoicesPageState createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> with TickerProviderStateMixin {

  TabController tabController;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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
  void dispose() {
    super.dispose();
    tabController.dispose();
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
                  text: "Invoices",
                ),
                SizedBox(height: 10),
                TabBar(
                  controller: tabController,
                  isScrollable: true,
                  indicatorColor: orange,
                  labelColor: blue,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    Tab(text: "Create Invoice"),
                    Tab(text: "History"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      CreateInvoiceTab(scaffoldKey: _scaffoldKey,),
                      InvoiceHistoryTab(scaffoldKey: _scaffoldKey)
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
