import 'package:flutter/material.dart';
import 'package:glade_v2/pages/authentication/login_page.dart';
import 'package:glade_v2/utils/widgets/button.dart';

Widget dialogPopup(
    { body,  String buttonText, Function onPressed,context }) {
  return Align(
    alignment: Alignment.center,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 26),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5)),
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
              body,
            textAlign: TextAlign.center,
            style: TextStyle(
                inherit: false,
                fontSize: 14,
                color: Colors.black),
          ),
          SizedBox(
            height: 10,
          ),

               Button(
            onPressed: (){

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false);
            },
            text: "Ok",
          )

        ],
      ),
    ),
  );
}
