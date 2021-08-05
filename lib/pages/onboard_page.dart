import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glade_v2/core/models/ui/onboard_details.dart';
import 'package:glade_v2/pages/authentication/login_page.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';

class OnboardPage extends StatefulWidget {
  @override
  _OnboardPageState createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {
  int index = 0;

  int opacity = 1;

  @override
  Widget build(BuildContext context) {
    List<OnboardDetails> details = [
      OnboardDetails(
          mainText: "Business\nBanking just for you",
          subText:
              "Experience superior banking and financial tools that helps you and your business thrive.",
          imagePath: "assets/images/onboarding/one.png",
          color: burntRed),
      OnboardDetails(
          mainText: "Deposit & \nFund Transfers",
          imagePath: "assets/images/onboarding/two.png",
          subText:
              "Deposit and transfer money across border instantly at competitive rates.",
          color: burntBlue),
      OnboardDetails(
          mainText: "Credits &\nOverdrafts",
          imagePath: "assets/images/onboarding/three.png",
          subText:
              "Get access to business loans and overdrafts to run your business.",
          color: burntPurple),
      OnboardDetails(
        mainText: "Debits & Virtual\nCards",
        imagePath: "assets/images/onboarding/four.png",
        subText:
            "Get multiple virtual cards to manage your personal and business transactions.",
        color: burntRed,
      )
    ];
    // index = 0;
    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        decoration: BoxDecoration(color: details[index].color),
        child: Column(
          children: [
            Expanded(
              child: Image.asset(details[index].imagePath),
            ),
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    details[index].mainText,
                    style: TextStyle(
                        color: blue, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(height: 5),
                  Text(
                    details[index].subText,
                    style: TextStyle(color: blue, fontSize: 13),
                  ),
                  SizedBox(height: 45),
                  CustomButton(
                    onPressed: () async {
                      if (index == 3) {
                        pushReplacementTo(context, LoginPage());
                      } else {
                        setState(() {
                          index++;
                        });
                      }
                    },
                    color: index > 0 ? cyan : orange,
                    text: index > 0 ? "Next" : "Let's Get Started",
                    showArrow: true,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
