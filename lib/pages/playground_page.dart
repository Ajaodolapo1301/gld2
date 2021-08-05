import 'dart:async';

import 'package:flutter/material.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_drop_down.dart';

class PlaygroundPage extends StatefulWidget {
  @override
  _PlaygroundPageState createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends State<PlaygroundPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomDropDown<String>(
                              intialValue: CustomDropDownItem(value: "hmm", text: "hmm"),

                  onSelected: (item) {},
                  header: "Networks",
                  items: [
                    CustomDropDownItem(value: "MTN", text: "MTN"),
                    CustomDropDownItem(value: "Airtel", text: "Airtel"),
                    CustomDropDownItem(value: "Glo", text: "Glo"),
                    CustomDropDownItem(value: "Etisalat", text: "Etisalat"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

