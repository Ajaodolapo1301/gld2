import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../utils/myUtils/myUtils.dart';

class PushNotificationsManager {


  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;
 static String _deviceToken = "";

  static String get deviceToken => _deviceToken;
  bool isDark = true;

  Future<void> resetIsDark() async {
    var pref = await SharedPreferences.getInstance();
    isDark = pref.getBool("isDark") ?? false;
  }
void  initEnv(accessToken){
  _deviceToken = accessToken;
  }

  Future<void> init(context) async {
    if (!_initialized) {
      // For iOS request permission first.

      _firebaseMessaging.getToken().then((value){
          // print("vala $value");
          initEnv(value);
      });
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(
        onMessage: (message) async {
          print("Message came in");
          var pref = await SharedPreferences.getInstance();
          List<String> notifications = pref.getStringList("notifications") ?? [];
          Notification notification =
              Notification.fromJson(Map.from(message['notification']));
          notifications.add(jsonEncode(notification.toJson()));
          await pref.setStringList("notifications", notifications);
          print(notifications);
          await resetIsDark();
          return null;
        },
        onLaunch: (message)  async{
          print("On launch");
          print(message);
          if (message['data']['from'] == ("/topics/appNewUpdate")) {
            // _launchURL();
          }
          print("Message came in");
          var pref = await SharedPreferences.getInstance();
          List<String> notifications = pref.getStringList("notifications") ?? [];
          Notification notification =
          Notification.fromJson(Map.from(message['data']));
          notifications.add(jsonEncode(notification.toJson()));
          await pref.setStringList("notifications", notifications);
          print(notifications);
          return null;
        },
        onResume: (message)async {
          print("On resume");
          print(message);
          // if (message['data']['from']
          //     .toString()
          //     == ("/topics/appNewUpdate")) {
          //   _launchURL();
          // }
          print("Message came in");
          var pref = await SharedPreferences.getInstance();
          List<String> notifications = pref.getStringList("notifications") ?? [];
          Notification notification =
          Notification.fromJson(Map.from(message['data']));
          notifications.add(jsonEncode(notification.toJson()));
          await pref.setStringList("notifications", notifications);
          print(notifications);
          return null;
        },
      );
      await _firebaseMessaging.subscribeToTopic("appNewUpdate");
      await _firebaseMessaging.subscribeToTopic("anything");
      _initialized = true;
    }
  }

  Future<void> listenToNotificationRelatedToUser(String mid) async {
    (await SharedPreferences.getInstance()).setString("listeningTo", mid);
    await _firebaseMessaging.subscribeToTopic(mid);
  }

  Future<void> disableListeningToNotificationForRelatedUser() async {
    String mid =
        (await SharedPreferences.getInstance()).getString("listeningTo");
    await _firebaseMessaging.unsubscribeFromTopic(mid);
  }

  // void showAppUpdateDialog(BuildContext context, {bool isDark = false}) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return SimpleDialog(
  //         backgroundColor: isDark ? Color(0xff191D20) : Colors.white,
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  //         children: <Widget>[
  //           Column(
  //             children: <Widget>[
  //               Image.asset(
  //                 "assets/loop.png",
  //                 height: 100,
  //               ),
  //               SizedBox(height: 20),
  //               Container(
  //                 margin: EdgeInsets.symmetric(horizontal: 20),
  //                 child: Text(
  //                   "NEW UPDATE NOW AVAILABLE",
  //                   style: GoogleFonts.workSans(
  //                     color: isDark ? Colors.white : headerColor,
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 16,
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(height: 20),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: <Widget>[
  //                   RaisedButton(
  //                     color: Color(0xff121416),
  //                     shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(5)),
  //                     padding:
  //                         EdgeInsets.symmetric(vertical: 5, horizontal: 25),
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                     },
  //                     child: Text(
  //                       "CANCEL".toUpperCase(),
  //                       style: GoogleFonts.karla(
  //                         color: Colors.white,
  //                         fontWeight: FontWeight.w600,
  //                         fontSize: 16,
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(width: 10),
  //                   RaisedButton(
  //                     color: buttonColor,
  //                     shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(5)),
  //                     padding:
  //                         EdgeInsets.symmetric(vertical: 5, horizontal: 25),
  //                     onPressed: () {
  //                       _launchURL();
  //                     },
  //                     child: Text(
  //                       "Proceed".toUpperCase(),
  //                       style: GoogleFonts.karla(
  //                           color: Colors.white,
  //                           fontWeight: FontWeight.w600,
  //                           fontSize: 16),
  //                     ),
  //                   ),
  //                 ],
  //               )
  //             ],
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }
}

class Notification {
  String sound;
  String body;
  String title;
  String contentAvailable;
  String priority;
  String clickAction;
  String date;

  Notification(
      {this.sound,
      this.body,
      this.title,
      this.contentAvailable,
      this.priority,
      this.clickAction});

  Notification.fromJson(Map<String, dynamic> json) {
    sound = json['sound'];
    body = json['body'];
    title = json['title'];
    contentAvailable = json['content_available'];
    priority = json['priority'];
    clickAction = json['click_action'];
    date = MyUtils.formatDate(DateTime.now().toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sound'] = this.sound;
    data['body'] = this.body;
    data['title'] = this.title;
    data['content_available'] = this.contentAvailable;
    data['priority'] = this.priority;
    data['click_action'] = this.clickAction;
    data['date'] = this.date;
    return data;
  }

  String toString(){
    return toJson().toString();
  }
}
