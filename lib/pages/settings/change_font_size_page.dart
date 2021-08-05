import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeFontSizePage extends StatefulWidget {
  @override
  _ChangeFontSizePageState createState() => _ChangeFontSizePageState();
}

class _ChangeFontSizePageState extends State<ChangeFontSizePage> {
  FontSize fontSize = FontSize.normal;
  double groupValue = 1.0;
  double savedScale = 1.0;
  void initDark() async {
    var pref = await SharedPreferences.getInstance();
    setState(() {
      groupValue = pref.getDouble("textScaleFactor") ?? 1.0;
      savedScale = groupValue;

    });
  }
  var key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    initDark();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: key,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: savedScale),
          child: Container(
            child: Column(
              children: [
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Header(
                    text: "Change Text Size",
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      // CustomTextField(
                      //   headerLess: true,
                      //   textEditingController: TextEditingController(
                      //
                      //     text:
                      //         "This is just a preview of the font size, select what best fit your preference.",
                      //   ),
                      //   readOnly: true,
                      //   minLines: 6,
                      //   maxLines: 6,
                      // ),

                      MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaleFactor: getfontsize()),
                        child: Container(
                          width: double.maxFinite,
                          height: 150,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: borderBlue.withOpacity(0.5)),
                              color: lightBlue,
                              borderRadius: BorderRadius.circular(5)),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "This is just a preview of the font size, choose the one you like best.",
                            style: TextStyle(fontSize: 17, color: blue),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      RadioListTile(
                        value: FontSize.extraLarge,
                        groupValue: fontSize,
                        onChanged: (value) {
                          setState(() {
                            fontSize = value;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Text(
                          "Extra Large",
                          style: TextStyle(color: blue, fontSize: 15),
                        ),
                      ),
                      divider(),
                      RadioListTile(
                        value: FontSize.large,
                        groupValue: fontSize,
                        onChanged: (value) {
                          setState(() {
                            fontSize = value;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Text(
                          "Large",
                          style: TextStyle(color: blue, fontSize: 15),
                        ),
                      ),

                      divider(),
                      RadioListTile(
                        value: FontSize.normal,
                        groupValue: fontSize,
                        onChanged: (value) {
                          setState(() {
                            fontSize = value;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Text(
                          "Normal (Default)",
                          style: TextStyle(color: blue, fontSize: 15),
                        ),
                      ),
                      divider(),
                      RadioListTile(
                        value: FontSize.small,
                        groupValue: fontSize,
                        onChanged: (value) {
                          setState(() {
                            fontSize = value;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Text(
                          "Small",
                          style: TextStyle(color: blue, fontSize: 15),
                        ),
                      ),
                      divider(),
                      RadioListTile(
                        value: FontSize.extraSmall,
                        groupValue: fontSize,
                        onChanged: (value) {
                          setState(() {
                            fontSize = value;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Text(
                          "Extra Small",
                          style: TextStyle(color: blue, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: CustomButton(
                    text: "Apply Changes",
                    onPressed: () async {
                      setState(() {
                        savedScale = getfontsize();
                      });
                      (await SharedPreferences.getInstance())
                          .setDouble("textScaleFactor", savedScale);
                      String getText = getfontsize() == 0.85
                          ? "extra small"
                          : getfontsize() == 0.9
                              ? "small"
                              : getfontsize() == 1.0
                                  ? "normal"
                                  : getfontsize() == 1.05
                                      ? "large"
                                      : "extra large";
                      key.currentState.showSnackBar(SnackBar(
                        content: Text("Font sized changed to $getText"),
                        action: SnackBarAction(
                          label: "OK",
                          onPressed: () {
                            key.currentState.removeCurrentSnackBar();
                          },
                        ),
                      ));
                    },
                    color: cyan,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container divider() {
    return Container(
      height: 1.5,
      margin: EdgeInsets.symmetric(horizontal: 15),
      width: double.maxFinite,
      color: Colors.grey[100],
    );
  }

  getfontsize() {
    switch (fontSize) {
      case FontSize.small:
        return 0.9;
        break;
      case FontSize.extraSmall:
        return 0.85;
        break;
      case FontSize.normal:
        return 1.0;
        break;
      case FontSize.large:
        return 1.05;
        break;
      case FontSize.extraLarge:
        return 1.1;
        break;
      default:
        return 1.0;
        break;
    }
  }
}

enum FontSize { extraSmall, small, normal, large, extraLarge }
