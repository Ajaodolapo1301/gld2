import 'package:flutter/material.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';

void showAccountCreationSuccessfulDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: barrierColor,
    builder: (context) => _AccountCreationSuccessfulDialog(),
  );
}

class _AccountCreationSuccessfulDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        height: 330,
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                child: Image.asset(
                  "assets/images/bicycle_man.png",
                  width: 170,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Account Creation\n Was Successful ",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: blue, fontWeight: FontWeight.bold, fontSize: 15),
            ),
            SizedBox(height: 10),
            Text(
              "An OTP was sent to your email for verification",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: blue, fontWeight: FontWeight.bold, fontSize: 10),
            ),
            SizedBox(height: 10),
            CustomButton(
              text: "Login".toUpperCase(),
              onPressed: () {
                pop(context);
                pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
