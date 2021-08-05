import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glade_v2/pages/dashboard/dashboard_page.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';

class FundTransferFailedPage extends StatefulWidget {
  String text;
  FundTransferFailedPage({this.text});
  @override
  _FundTransferFailedPageState createState() =>
      _FundTransferFailedPageState();
}

class _FundTransferFailedPageState
    extends State<FundTransferFailedPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        pushToAndClearStack(context, DashboardPage());
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: SvgPicture.asset(
                      "assets/images/states/sad.svg",
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    "Transfer was Unsuccessful.",
                    style: TextStyle(
                      color: blue,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(

                    widget.text ??
                    "Don't be Sad, Kindly Confirm your \nDetails and try Again",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: blue, fontSize: 12),
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      pop(context);
                    },
                    child: Text(
                      "GO BACK",
                      style: TextStyle(
                          color: cyan, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
