import 'dart:async';

import 'package:flutter/material.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';

class CustomDropDownItem<T> {
  final T value;
  final String text;

  CustomDropDownItem({this.value, this.text});

  @override
  String toString() {
    return "CustomDropDownItem(value: $value, text: $text)";
  }
}

class CustomDropDown<T> extends StatefulWidget {
  final String header;
  final List<CustomDropDownItem<T>> items;
  final Function(T value) onSelected;
  final Widget suffix;
  final color;
  final CustomDropDownItem intialValue;

  const CustomDropDown({
    @required this.items,
    @required this.onSelected,
    @required this.header,
    this.color = lightBlue,
    @required this.intialValue,
    this.suffix,
  });

  @override
  _CustomDropDownState<T> createState() => _CustomDropDownState<T>();
}

class _CustomDropDownState<T> extends State<CustomDropDown<T>>  {
  bool expanded = false;
  List<CustomDropDownItem<T>> items = [];
  CustomDropDownItem<T> selectedItem;

  @override
  void initState() {
    initItems();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    if (widget.items.toString() != items.toString()) {
      initItems();
    }
    validateList();
    return IgnorePointer(
      ignoring: emptyList,
      child: GestureDetector(
        onTap: () {
          setState(() {
            expanded = !expanded;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${widget.header}",
              style: TextStyle(color: blue, fontSize: 12),
            ),
            SizedBox(height: 4),
            AnimatedContainer(
              height: expanded ? 27.0 + (40.0 * (items.length)) : 60,
              duration: Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
              decoration: BoxDecoration(
                color: widget.color,
                border: Border.all(
                  color: borderBlue.withOpacity(0.5),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedItem.text,
                            style: TextStyle(
                              color: blue,
                            ),
                          ),
                        ),
                        widget.suffix ??
                            RotatedBox(
                              quarterTurns: expanded ? 2 : 0,
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: emptyList ? orange.withOpacity(0.4): orange,
                              ),
                            )
                      ],
                    ),
                    SizedBox(height: 5),
                    Divider(),
                    SizedBox(height: 2),
                    ...items
                        .where((element) => selectedItem.value != element.value)
                        .map((e) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedItem = e;
                            expanded = false;
                            widget.onSelected(selectedItem.value);
                          });
                        },
                        child: Container(
                          height: 40,
                          width: double.infinity,
                          child: Text(
                            e.text,
                            style: TextStyle(color: blue),
                          ),
                        ),
                      );
                    }).toList()
                  ],
                ),
              ),
            ),
            SizedBox(width: 5),
          ],
        ),
      ),
    );
  }

  bool emptyList = false;

  void initItems() {

    items = widget.items;
    if (items.isEmpty) {
      setState(() {
        emptyList = true;
      });
      items.add(
        CustomDropDownItem<T>(
          value: widget.intialValue.value,
          text: widget.intialValue.text ?? "Select",
        ),
      );
    }else{
       setState(() {
        emptyList = false;
      });
    }
    selectedItem = items.first;
    Timer(
      Duration(milliseconds: 1),
          () {
        widget.onSelected(selectedItem.value);
      },
    );
    validateList();
  }

  void validateList() {
    for (int i = 0; i < items.length; i++) {
      for (int j = i + 1; j < items.length; j++) {
        if (items[i].value == items[j].value) {
          throw Exception(
              "Duplicate values \'${items[i].value}\' at indices $i and $j");
        }
      }
    }
  }

  // @override
  // // TODO: implement wantKeepAlive
  // bool get wantKeepAlive => true;
}
