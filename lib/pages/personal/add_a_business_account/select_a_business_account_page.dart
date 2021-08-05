import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/body_modal_not_live.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:provider/provider.dart';

import 'add_a_business_account/add_a_business_account_page.dart';
import 'register_your_enterprise/register_your_business_page.dart';

class SelectABusinessAccountPage extends StatefulWidget {
  @override
  _SelectABusinessAccountPageState createState() =>
      _SelectABusinessAccountPageState();
}

class _SelectABusinessAccountPageState extends State<SelectABusinessAccountPage> {

  LoginState loginState;
  @override
  Widget build(BuildContext context) {
    loginState = Provider.of<LoginState>(context);
    return Scaffold(
      backgroundColor: burntBlue,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: IconButton(
              splashColor: burntBlue,
              highlightColor: burntBlue,
              onPressed: (){
                pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                size: 20,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Transform.translate(
                offset: Offset(0, -20),
                child: Image.asset(
                  "assets/images/rocket blue.png",
                ),
              ),
            ),
          ),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(33),
                topRight: Radius.circular(33),
              ),
            ),
            child: Column(
              children: [
                _SelectBusinessAccountTypeView(
                  color: lightBlue,
                  imagePath: "assets/images/add_a_business/hand.png",
                  mainText: "You have a Registered \nBusiness Name or Company",
                  otherText:
                      "CAC Documents, RC/BN Number, TIN, Valid ID & Utility Bill.",
                  selected: selectedIndex == 0,
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                ),
                SizedBox(height: 28),
                _SelectBusinessAccountTypeView(
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                  color: burntGreen.withOpacity(0.75),
                  imagePath: "assets/images/add_a_business/walk.png",
                  mainText: "My Business is not yet\nRegistered",
                  otherText: "We can help you register as a Business Name or Company.",
                  selected: selectedIndex == 1,
                ),
                SizedBox(height: 20),
                CustomButton(
                  text: "Proceed",
                  showArrow: true,
                  onPressed: () {
                    if(selectedIndex == 1){
                      // CommonUtils.kShowSnackBar(ctx: context, msg: "Feature Coming Soon");
                      pushTo(context, RegisterYourEnterprisePage());
                    }else if(selectedIndex == 0){
                      if(loginState.user.compliance_status == "approved"){
                        pushTo(context, AddABusinessAccountPage());
                      }else{
                        CommonUtils.modalBottomSheetMenu(context: context,  body: buildModal(text: "Oh, Merchant not enabled for transaction!", subText: "dbfhbdf"));
                      }

                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  int selectedIndex = -1;
}

class _SelectBusinessAccountTypeView extends StatelessWidget {
  final Color color;
  final String mainText;
  final String otherText;
  final String imagePath;
  final bool selected;
  final VoidCallback onTap;

  const _SelectBusinessAccountTypeView({
    Key key,
    this.color,
    this.mainText,
    this.otherText,
    this.imagePath,
    this.selected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: borderBlue.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Transform.translate(
              offset: Offset(0, 12.7),
              child: Image.asset(
                imagePath,
                width: 50,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  Text(
                    mainText,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: blue, fontSize: 13),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    otherText,
                    style: TextStyle(color: blue, fontSize: 11),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
            SizedBox(width: 10),
            AnimatedOpacity(
              opacity: selected ? 1 : 0,
              duration: Duration(milliseconds: 200),
              child: Container(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.check,
                  size: 10,
                  color: Colors.white,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: cyan,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
