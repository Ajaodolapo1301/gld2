import 'package:flutter/material.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';

import '../custom_button.dart';

class SelectRangeBottomSheet extends StatefulWidget {
  Function(Map<String, dynamic> value)onDateSelected;
  final Color textColor;

   SelectRangeBottomSheet({Key key, this.textColor, this.onDateSelected}) : super(key: key);

  @override
  _SelectRangeBottomSheetState createState() => _SelectRangeBottomSheetState();
}

class _SelectRangeBottomSheetState extends State<SelectRangeBottomSheet> {
  String _startDate;
  bool _startDateSelected = true;
  String _endDate;
  bool _endDateSelected = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Range",
            style: TextStyle(
                color: blue, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 3),
          Text(
            "Please select Start and End date and click search",
            style: TextStyle(color: blue, fontSize: 12),
          ),
          SizedBox(height: 30),
          Expanded(
            child: Column(
              children: [
                InkWell(
                  onTap: () async{
                    DateTime date = await selectDate(context: context);
                    setState(() {
                      if (date != null) {
                        _startDate = date.toString().split(" ")[0];
                      }
                    });

                  },
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: lightBlue,
                      border: Border.all(
                        color: borderBlue.withOpacity(0.05),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                          _startDate ?? "Start Date",
                            style: TextStyle(
                              color: blue
                            ),
                          ),
                        ),
                        Icon(Icons.date_range_rounded, color: orange,)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                    onTap: () async{
                      DateTime date = await selectDate(context: context);
                      setState(() {
                        if (date != null) {
                          _endDate = date.toString().split(" ")[0];
                        }
                      });

                    },
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: lightBlue,
                      border: Border.all(
                        color: borderBlue.withOpacity(0.05),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                         _endDate ??   "End Date",
                            style: TextStyle(
                                color: blue
                            ),
                          ),
                        ),
                        Icon(Icons.date_range_rounded, color: orange,)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          CustomButton(
            text: "Proceed",
            onPressed: () {
              pop(context);
              widget.onDateSelected({
                "start_date" : _startDate,
                "end_date" : _endDate
              });

            },
          ),
        ],
      ),
    );
  }


  Future selectDate({@required BuildContext context}) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2018),
      lastDate: DateTime.now().add(Duration(hours: 1)),
      initialDate: DateTime.now(),
      selectableDayPredicate: (DateTime d) {
        if (d.isBefore(DateTime.now().add(Duration(hours: 12)))) {
          return true;
        }
        return false;
      },
    );
    if (picked != null) {
      return picked;
    }
    return null;
  }
}
