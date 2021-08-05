




import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';

Widget buildModal({text, subText, String status  }) {

  return Container(
    margin: EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 15,),
        Container(
          child: SvgPicture.asset(
            "assets/images/states/sad.svg", height: 70,
          ),
        ),
        SizedBox(height: 10,),
        Text(text,
            style: TextStyle(
              color: blue,

              fontWeight: FontWeight.bold,
              fontSize:15,
            )),

        SizedBox(
          height: 10,
        ),
        Text(

 status == "rejected" ?  "Kindly resubmit your compliance" : status == "pending" ? "Your Submission is pending, please be patient" :     "To perform transaction on Glade, kindly Submit compliance to activate your account" ,
          textAlign: TextAlign.center,
          style:TextStyle(
              color: blue,
              fontSize: 10),
        ),
        SizedBox(
          height: 30,
        ),

//        9921738168
//           Container(
//             child: SizedBox(
//               width: double.maxFinite,
//               height: 50,
//               child: RaisedButton(
//                 onPressed: () {
//                   Clipboard.setData(new ClipboardData(
//                       text: loginState.user.bankAaccountNumber));
//
//                   toast("Copied to Clipboard");
//                 },
//                 child: Text(
//                   "COPY ACCOUNT NO",
//                   style: GoogleFonts.mavenPro(
//                     fontSize: 16,
//                   ),
//                 ),
//                 color: kPrimaryColor,
//                 padding: EdgeInsets.symmetric(vertical: 15),
//                 textColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(7),
//                 ),
//               ),
//             ),
//           ),
        SizedBox(
          height: 30,
        ),
      ],
    ),
  );
}





Widget StashModal( ) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 15,),
        Container(
          child: SvgPicture.asset(
            "assets/images/pig.svg", height: 70,
          ),
        ),
        SizedBox(height: 10,),
        Text("Feature Coming Soon",
            style: TextStyle(
              color: blue,

              fontWeight: FontWeight.bold,
              fontSize:15,
            )),

        SizedBox(
          height: 10,
        ),
        Text(

      "Please, check back later",
          textAlign: TextAlign.center,
          style:TextStyle(
              color: blue,
              fontSize: 10),
        ),
        SizedBox(
          height: 30,
        ),

        SizedBox(
          height: 30,
        ),
      ],
    ),
  );
}