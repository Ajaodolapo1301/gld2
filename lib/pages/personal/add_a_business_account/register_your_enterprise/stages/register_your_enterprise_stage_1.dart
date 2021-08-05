import 'package:flutter/material.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';

class RegisterYourEnterpriseStage1 extends StatefulWidget {
  Function(int value)onSelected;

  RegisterYourEnterpriseStage1({this.onSelected, });
  @override
  _RegisterYourEnterpriseStage1State createState() =>
      _RegisterYourEnterpriseStage1State();
}

class _RegisterYourEnterpriseStage1State
    extends State<RegisterYourEnterpriseStage1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: [
          SizedBox(height: 20),
          _EnterpriseTypeSelectorView(
            mainText: "Register a Business Name & TIN",
            otherText:
                "Go legit! We have brought business name registration to you.",
            selected: selectedIndex == 0,
            onTap: () {
              setState(() {
                selectedIndex = 0;
                widget.onSelected(selectedIndex);
              });
            },
            requirementText:
                "- ID card\n- 3 Proposed business names\n- Director's Information\n- Business address\n- Business email\n- ₦29,999.00 Charge",
          ),
          SizedBox(height: 20),
          _EnterpriseTypeSelectorView(
            mainText: "Register a Company & TIN",
            otherText:
                "Our legal partners are here to help you incorporate your business with ease.",
            selected: selectedIndex == 1,
            onTap: () {
              setState(() {
                selectedIndex = 1;
                widget.onSelected(selectedIndex);
              });
            },
            requirementText:
                "- ID card\n- 3 Proposed business names\n- Business address\n- Business email\n- ₦69,999 Charge",
          ),
        ],
      ),
    );
  }

  int selectedIndex = -1;
}

class _EnterpriseTypeSelectorView extends StatelessWidget {
  final String mainText;
  final String otherText;
  final bool selected;
  final VoidCallback onTap;
  final String requirementText;

  const _EnterpriseTypeSelectorView({
    Key key,
    this.mainText,
    this.otherText,
    this.selected = false,
    this.onTap,
    this.requirementText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        height: selected ? 235 : 100,
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: lightBlue,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: borderBlue.withOpacity(0.2),
          ),
        ),
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      Icons.check,
                      size: 10,
                      color: selected ? Colors.white : lightBlue,
                    ),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selected ? cyan : lightBlue,
                        border: Border.all(color: selected ? lightBlue : blue)),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mainText,
                        style: TextStyle(
                            color: blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      SizedBox(height: 5),
                      Text(
                        otherText,
                        style: TextStyle(color: blue, fontSize: 12),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Container(
              margin: EdgeInsets.only(left: 35, top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "REQUIREMENT",
                    style: TextStyle(
                      color: cyan,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    requirementText,
                    style: TextStyle(color: blue, fontSize: 13),
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
