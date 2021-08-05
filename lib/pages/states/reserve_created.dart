
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glade_v2/pages/personal/reserve_funds/reserve_funds_page.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';

class ReserveSuccessfulPage extends StatefulWidget {
  @override
  _ReserveSuccessfulPageState createState() =>
      _ReserveSuccessfulPageState();
}

class _ReserveSuccessfulPageState extends State<ReserveSuccessfulPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Image.asset("assets/images/states/check.png"),
                ),
                SizedBox(height: 40),
                Text(
                  "Stash creation was Successful",
                  style: TextStyle(
                    color: blue,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Start stashing your fund for future use",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: blue, fontSize: 12),
                ),
                SizedBox(height: 60),
                GestureDetector(
                  onTap: (){
                    pop(context);
                    pop(context);
                pushReplacementTo(context, ReserveFundsPage());
//                    pop(context);
                  },
                  child: Text(
                    "See details",
                    style: TextStyle(
                        color: cyan,
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                    ),
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
