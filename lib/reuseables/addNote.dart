


import 'package:flutter/material.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';

class AddNoteLoanBottomSheet extends StatefulWidget {
  final Function(String value) onAddItem;
  const AddNoteLoanBottomSheet({this.onAddItem});

  @override
  _AddNoteLoanBottomSheetState createState() => _AddNoteLoanBottomSheetState();
}

class _AddNoteLoanBottomSheetState extends State<AddNoteLoanBottomSheet> {
  String reason;
  String newNote;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
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
            "Add Credit Note Application",
            style: TextStyle(
                color: blue, fontWeight: FontWeight.bold, fontSize: 17),
          ),
          SizedBox(height: 20),
          Form(
            key: _formKey,
            child: CustomTextField(
              // textEditingController: note,

              validator: (v){
                if(v.isEmpty){
                  return "Empty";

                }
                newNote = v;
                return null;

              },
              onChanged: (v){
                // setState(() {
                //   newNote = v;
                // });
              },
              header: "Add Note",
            ),
          ),
          SizedBox(height: 20),
          CustomButton(
            onPressed: () {
              if(_formKey.currentState.validate()){
                pop(context);
                widget.onAddItem(newNote);



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