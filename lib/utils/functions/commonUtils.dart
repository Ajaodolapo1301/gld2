








import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glade_v2/pages/authentication/login_page.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/button.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonUtils{

  // static kShowSnackBar({BuildContext ctx, String msg,  }) {
  //   return Flushbar(
  //     flushbarPosition: FlushbarPosition.BOTTOM,
  //     backgroundColor: blue,
  //     messageText: Text(
  //       msg,
  //       textAlign: TextAlign.center,
  //       style: TextStyle(
  //         color: Colors.white,
  //         fontSize: 15,
  //       ),
  //     ),
  //     duration: Duration(seconds: 3),
  //   )..show(ctx);
  // }

static   modalBottomSheetMenu({BuildContext context, Widget body, }){
    showModalBottomSheet(

      barrierColor: barrierColor,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
        ),
        context: context,
        builder: (builder){
          return new Container(
            height: 300.0,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: new Container(
                decoration: new BoxDecoration(
                    color:Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(20.0),
                        topRight: const Radius.circular(20.0))),
                child: body
            ),
          );
        }
    );
  }

 static Widget checkMArk() {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 800),
      curve: Curves.elasticInOut,
      tween: Tween<double>(begin: 5, end: 25),
      builder: (__, value, child) {
        return Container(
            child: Icon(Icons.done,

                color: Color(0XFF009845)
            )
        );
      },
    );
  }


 static  Widget checkCancel() {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 800),
      curve: Curves.elasticInOut,
      tween: Tween<double>(begin: 5, end: 25),
      builder: (__, value, child) {
        return Container(
            child: Icon(Icons.cancel,

                color: Colors.red
            )
        );
      },
    );
  }




  static     dialog({context, VoidCallback onClose, String text}){
    return showDialog(
      barrierColor: barrierColor ,
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            height: 130,
            width: MediaQuery.of(context).size.width * 0.78,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color:  Colors.white,
                borderRadius: BorderRadius.circular(12)),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Material(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Text(
                      text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: blue
                        ),
                      ),


                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 100,
//                  height: 40,
                  child: Button(
                    onPressed: onClose,
                    text: "Okay",
                  ),
                ),
//                SizedBox(
//                  height: 10,
//                ),
              ],
            ),
          ),
        );
      },
    );
  }




  static  showSuccessDialog({text, context,  VoidCallback onClose, String buttonText }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.symmetric(vertical: 40, horizontal: 25),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    "images/yes.svg",
                    height: 100,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Success!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: blue,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(color: blue, fontSize: 15),
                  ),
                  SizedBox(height: 20),

                  SizedBox(
                    width: double.maxFinite,
                    height: 50,
                    child: RaisedButton(
                      onPressed: onClose,
                      child: Text(
                        buttonText  ?? "okay",
                        style:TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      color: blue,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }


static showAlertDialog({BuildContext context, String text, VoidCallback onClose}) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = FlatButton(
    child: Text("OK", style:TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: blue
    ),),
    onPressed: onClose,
  );

//  // set up the AlertDialog
//  AlertDialog alert = AlertDialog(
////    title: Text("Logout"),
//    content: Text("Password change successfully"),
//    actions: [
////      cancelButton,
//      continueButton,
//    ],
//  );

  // show the dialog
  showDialog(

    barrierDismissible: false,
    barrierColor: barrierColor,
      context: context,
      builder: (_) => new AlertDialog(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(5.0))),
        content: Builder(
          builder: (context) {
            // Get available height and width of the build area of this widget. Make a choice depending on the size.
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;

            return Container(
              height: 20,
              width: width ,
              child: Text(text,         textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: blue
                ),)
            );
          },
        ),
        actions: [
          continueButton
        ],
      )
  );
}

void _logOut(BuildContext context) async {
  final box = Hive.box('driver');
  box.put('driver', null);
//    Navigator.pop(context);
//    Navigator.pop(context);
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false);
//    }
}





  static   showMsg({body,  context, scaffoldKey, Color snackColor} ) {
    final snackBar = SnackBar(
      backgroundColor:  snackColor,
      content: Text(body, style: TextStyle(fontSize: 12),),
      action: SnackBarAction(
        textColor: Colors.white,
        label: "Close",
        onPressed: () {
          Navigator.maybePop(context);
        },
      ),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }



  static String capitalize(String s) => s[0].toUpperCase() + s.substring(1);


  static getBalance(LoginState loginState)async {
    var res = await loginState.getBalance(token: loginState.user.token);
    if(res["error"] == false){
      print(res);
    }
  }


static getBalanceBusiness(LoginState loginState, BusinessState businessState)async {
  var res = await businessState.getBalance(token: loginState.user.token, business_uuid: businessState.business.business_uuid );
  if(res["error"] == false){
    print(res);
  }
}


  static  displayStatus({@required String status, String createdAt}) {
    status = status.toLowerCase();
    String display;
    Color color;

    Duration diff = DateTime.now().difference(DateTime.tryParse(createdAt));

    switch (status) {
      case "00":
      case "successful":
        display = "Successful";
        color = Colors.green;
        break;
      case "02":
      case "pending":
        if (diff.inHours > 0) {
          display = "Incomplete";
          color = Colors.yellow[700];
        } else {
          display = "Pending";
          color = Colors.blue;
        }

        break;
      case "03":
      case "failed":
        display = "Failed";
        color = Colors.red;
        break;
      case "04":
        display = "Refunded";
        color = Colors.black;
        break;
      case "credit":
        display = status.toUpperCase();
        color = Colors.green;
        break;
      case "debit":
        display = status.toUpperCase();
        color = Colors.red;
        break;
      case "revert":
        display = status.toUpperCase();
        color = Colors.black;
        break;
      default:
    }
    return Container(
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          child: Text(
            display ?? "",
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,

            ),
          ),
        ),
      ),
    );
  }

static kShowSnackBar({BuildContext ctx, String msg, Color color}) {
  return Flushbar(
      flushbarPosition:  FlushbarPosition.BOTTOM,
    backgroundColor: color ?? blue,
    messageText: Text(
      msg,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 15,
      ),
    ),
    duration: Duration(seconds: 3),
  )..show(ctx);
}


}




class SystemProperties{

  static const String appPackageAndroid = "gladepay.package.gladepaymanger";
//      "glade.gladepay.gladepaymanger";
  static const String appIDIOS = "1532047379";

}



