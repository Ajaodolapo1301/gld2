import 'package:flutter/material.dart';
import 'package:glade_v2/pages/business/payment_link/tabs/create_payment_link_tab.dart';
import 'package:glade_v2/pages/business/payment_link/tabs/payment_link_history_tab.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentLinkPage extends StatefulWidget {
  @override
  _PaymentLinkPageState createState() => _PaymentLinkPageState();
}

class _PaymentLinkPageState extends State<PaymentLinkPage> with TickerProviderStateMixin {

  TabController tabController;

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
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Header(
                    text: "Payment Link",
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
                    Tab(text: "Create Payment Link"),
                    Tab(text: "History"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      CreatePaymentLinkTab(),
                      PaymentLinkHistoryTab()
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
