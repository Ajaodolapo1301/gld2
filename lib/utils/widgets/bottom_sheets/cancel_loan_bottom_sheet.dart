import 'package:flutter/material.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_drop_down.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';

class CancelLoanBottomSheet extends StatefulWidget {
  final Function(String value) onAddItem;
  const CancelLoanBottomSheet({this.onAddItem});

  @override
  _CancelLoanBottomSheetState createState() => _CancelLoanBottomSheetState();
}

class _CancelLoanBottomSheetState extends State<CancelLoanBottomSheet> {
    String reason;
    final _formKey = GlobalKey<FormState>();
    final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          Text(
            "Cancel Application",
            style: TextStyle(
                color: blue, fontWeight: FontWeight.bold, fontSize: 17),
          ),
          SizedBox(height: 20),
          Form(

            key: _formKey,
            child: CustomTextField(
              validator: (v){
                  if(v.isEmpty){
                    return "Empty";
                  }
                  reason = v;
                  return null;
              },
              header: "Reason for cancellation",
              minLines: 5,
              maxLines: 10,
            ),
          ),
          SizedBox(height: 20),
          CustomButton(
            onPressed: () {
            if(_formKey.currentState.validate()){
              pop(context);
              widget.onAddItem(reason);



            }

            },
            text: "Proceed",
            color: cyan,
          ),
        ],
      ),
    );
  }
}










