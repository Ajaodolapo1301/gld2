



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:glade_v2/reuseables/roundedCorner.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';

class BankListIntl extends StatefulWidget {
  final parentContext;
  final fillColor;
  String hintText = "Select a Bank";
  List bankList;
  dynamic selectedBank;
  Function onChanged;
  Function validator;
  final bool isDark;

// for map instance
  bool isMap;
  String textField; // contains name
  String valueField; // contains code

  BankListIntl(
      {this.isDark,
        this.parentContext,
        this.hintText,
        @required this.bankList,
        @required this.selectedBank,
        @required this.isMap,
        this.textField,
        this.valueField,
        @required this.onChanged,
        this.fillColor});

  @override
  State<StatefulWidget> createState() {
    return _BankListIntlState();
  }
}

class _BankListIntlState extends State<BankListIntl> {
  bool keyboardVisible = false;
  // Dimens dimens;
  final TextEditingController searchController = TextEditingController();
  List tempListintl = [];
  bool isValid;

  @override
  void initState() {


    super.initState();
    KeyboardVisibilityNotification().addNewListener(onHide: () {
      setState(() {
        keyboardVisible = false;


      });
    }, onShow: () {
      keyboardVisible = true;
    });
    tempListintl = widget.bankList;
  }

  @override
  Widget build(BuildContext context) {
    // dimens = Dimens(context);
    // print("widget ${widget.bankList}");
    // print("temList$tempListintl");
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: widget.parentContext,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return showList();
            });
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: lightBlue),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                widget.selectedBank != null?
                // ? widget.isMap
                // ? widget.selectedBank[widget.textField] ?? ""
                widget.selectedBank.name ?? ""
                    : "Select a Bank",
                style: TextStyle(
                  color: widget.isDark ? Colors.white :   blue,),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: orange,
            )
          ],
        ),
      ),
    );
  }

  Widget showList() {
    return StatefulBuilder(
      builder: (context, setState) {
        if (tempListintl.isEmpty) {
          // when widget is built and bank list isn't loaded immediately
          setState(() {
            tempListintl = widget.bankList;
          });
        }
        return Container(
          // color: buttonColor,
          height: MediaQuery.of(context).size.height - 80,
          child: Column(
            children: <Widget>[
              Center(
                child: Container(
                  width: 300,
                  height: 5,
                  decoration: BoxDecoration(
                    // color: buttonColor,
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
              ),
              Expanded(
                child: RoundConnerBottomSheet(
                  Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Material(
                      color: Colors.transparent,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 250),
                        height: !keyboardVisible ? 360 : MediaQuery.of(context).size.height * 0.8,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 10),
                            Center(
                              child: Text(
                                "Banks",
                                style: TextStyle(
                                  fontSize: 22,
                                  color: widget.isDark ? Color(0xffF5F9FF) : blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 50,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(

                                  border: Border.all(color: borderBlue ),
                                  color: widget.isDark
                                      ? Color(0xff191D20)
                                      : lightBlue,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(width: 10),
                                  Icon(Icons.search, color: Colors.orange, size: 25),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      controller: searchController,
                                      decoration: InputDecoration.collapsed(
                                          hintText: "Search",
                                          hintStyle: TextStyle(
                                              color: widget.isDark
                                                  ? Colors.white
                                                  : blue)
                                      ),
                                      style: TextStyle(
                                          color: widget.isDark
                                              ? Colors.white
                                              : blue),
                                      onChanged: (v) {
                                        if (v.isNotEmpty) {
                                          setState(() {
                                            // if (widget.isMap) {
                                            //   tempList = widget.bankList
                                            //       .where((bank) =>
                                            //       bank[widget.textField]
                                            //           .toString()
                                            //           .toLowerCase()
                                            //           .contains(v))
                                            //       .toList();
                                            // } else {
                                            tempListintl = widget.bankList
                                                .where((bank) => bank.name
                                                .toString()
                                                .toLowerCase()
                                                .contains(v))
                                                .toList();
                                            // }
                                          });
                                        } else {
                                          setState(() {
                                            tempListintl = widget.bankList;
                                          });
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: widget.bankList.isEmpty
                                  ? Center(
                                child: CupertinoActivityIndicator(),
                              )
                                  : ListView.separated(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 4),
                                itemCount: tempListintl.length,
                                physics: BouncingScrollPhysics(),
                                separatorBuilder: (BuildContext context, int i) {
                                  return Container(
                                    height: 1,
                                    color: Colors.blueGrey.withOpacity(0.6),
                                  );
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      widget.onChanged(tempListintl[index]);
                                      Navigator.pop(context, tempListintl[index]);
                                    },
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(

                                        // widget.isMap
                                        //     ? tempList[index][widget.textField]
                                        tempListintl[index].name ?? "s",

                                        style: TextStyle(
                                            color: widget.isDark
                                                ? Colors.white
                                                : blue),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  isDark: widget.isDark,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}