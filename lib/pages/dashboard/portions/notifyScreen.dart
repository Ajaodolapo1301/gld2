




import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:glade_v2/firebase_notification/NotificationsManager.dart' as NM;
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/header.dart';

import 'package:shared_preferences/shared_preferences.dart';

class NotifyScreen extends StatefulWidget {
  @override
  _NotifyScreenState createState() => _NotifyScreenState();
}

class _NotifyScreenState extends State<NotifyScreen>
    with TickerProviderStateMixin {


  AnimationController _controller;

  @override
  void initState() {
    initTextScale();
    initDark();
    initAnim();
    super.initState();
  }

  int move = 0;
  var tween = Tween(begin: Offset.zero, end: Offset(10, 0));
  Timer timer2;

  initAnim() async {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    timer2 = Timer.periodic(Duration(seconds: 2), (timer) async {
      if (mounted) {
        try {
          await _controller.forward();
          _controller.reset();
          setState(() {
            move++;
            if (move % 2 == 0) {
              tween = Tween(begin: Offset.zero, end: Offset(5, 0));
            } else {
              tween = Tween(begin: Offset.zero, end: Offset(-5, 0));
            }
          });
        } catch (e) {}
      }
    });
  }

  bool showDismissInfo = true;

  @override
  void dispose() {
    timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  Timer timer;

  void initTextScale() async {
    var pref = await SharedPreferences.getInstance();
    setState(() {
      textScale = pref.getDouble("textScaleFactor") ?? 1.0;
      showDismissInfo = pref.getBool("showDismissInfo") ?? true;
    });
    if (mounted) {
      timer = Timer.periodic(Duration(milliseconds: 1), (timer) async {
        if (mounted) {
          if (notifications.toString() !=
              (await loadNotifications()).toString()) {
            print("updating");
            loadNotifications()
                .then((value) => setState(() => notifications = value));
          }
        }
      });
    }
  }

  void initDark() async {
    var pref = await SharedPreferences.getInstance();
    setState(() {
      isDark = pref.getBool("isDark") ?? false;
    });
  }

  bool isDark = false;

  double textScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        timer.cancel();
        timer2.cancel();
        return true;
      },
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: textScale),
        child: new Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              bottom: false,
              child: Container(
                color: isDark ? Colors.black : Colors.white,
                child: Column(
                  children: <Widget>[


                    Header(
                      preferredActionOnBackPressed: (){
                          pop(context);
                      },
                      text: "Notifications",
                    ),


                    if (showDismissInfo && notifications.isNotEmpty)
                      Column(
                        children: [
                          Container(
                            height: 250,
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                Text(
                                  "Swipe left or right to delete notification",
                                  style: TextStyle(
                                      color: blue, fontSize: 14),
                                ),
                                SizedBox(height: 10),
                                SlideTransition(
                                  position: _controller.drive(tween),
                                  child: Container(
                                    width: double.maxFinite,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: lightBlue,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              child: Icon(
                                                Icons.person,
                                                color: Colors.white,
                                              ),
                                              backgroundColor: blue,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              "Ema from Glade",
                                              style: TextStyle(
                                                  color: isDark
                                                      ? Colors.white
                                                      : headerColor,
                                                  fontWeight: FontWeight.w600
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Swipe to delete",
                                          style: TextStyle(
                                              color: isDark
                                                  ? Colors.white
                                                  : headerColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "You can delete notifications by swiping left or right",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Now",
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.white
                                                : Colors.grey[900],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      showDismissInfo = false;
                                      SharedPreferences.getInstance()
                                          .then((value) {
                                        value.setBool("showDismissInfo", false);
                                      });
                                    });
                                  },
                                  child: Text("OK"),
                                )
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.grey[400],
                            height: 0.3,
                          ),
                        ],
                      ),
                    Expanded(
                      child: notifications.isEmpty
                          ? Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height,
                          padding: EdgeInsets.zero,
                          child: Center(
                            child: Text(
                              "Nothing Yet",
                              style: TextStyle(
                                  color:
                                  isDark ? Colors.white : Colors.black,
                                  fontSize: 20),
                            ),
                          ))
                          : ListView(
                          physics: BouncingScrollPhysics(),
                          children:
                          List.generate(notifications.length, (index) {
                            NM.Notification e = notifications[index];
                            print(e);
                            return Dismissible(
                              key: UniqueKey(),
                              onDismissed: (direction) {
                                setState(() {
                                  notifications.removeAt(index);
                                });
                                List<String> note = [];
                                notifications.forEach((element) {
                                  note.add(jsonEncode(element.toJson()));
                                });
                                SharedPreferences.getInstance()
                                    .then((pref) {
                                  pref.setStringList("notifications",
                                      note.reversed.toList());
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                decoration: BoxDecoration(
                                    color: lightBlue,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.white,
                                          ),
                                          backgroundColor: blue,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "Ebi from Glade",
                                          style: TextStyle(
                                              color: isDark
                                                  ? Colors.white
                                                  : headerColor,
                                              fontWeight: FontWeight.w600
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      e.title ?? "",
                                      style: TextStyle(
                                          color: isDark
                                              ? Colors.white
                                              : headerColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      e.body ?? "",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      e.date ?? "",
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : Colors.grey[900],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  List<NM.Notification> notifications = [];

  Future<List<NM.Notification>> loadNotifications() async {
    var pref = await SharedPreferences.getInstance();
    return (pref.getStringList("notifications") ?? [])
        .map<NM.Notification>((e) => NM.Notification.fromJson(jsonDecode(e)))
        .toList()
        .reversed
        .toList();
  }

}