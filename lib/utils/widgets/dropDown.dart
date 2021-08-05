import 'package:flutter/material.dart';
import 'package:glade_v2/reuseables/bankList.dart';
import 'package:glade_v2/reuseables/bankList2.dart';
import 'package:glade_v2/reuseables/form.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';


class DropDownField extends FormField<dynamic> {
  final parentContext;
  final String titleText;
  final String hintText;
  final bool required;
  final String errorText;
  final dynamic value;
  List dataSource;
  final String textField;
  final String valueField;
  final Function onChanged;
  Color fillColor = lightBlue;
  final bool isMap;
  final bool isDark;


  DropDownField({this.isDark,
    FormFieldSetter<dynamic> onSaved,
    FormFieldValidator<dynamic> validator,
    bool autovalidate = false,
    this.titleText = 'Title',
    this.hintText = 'Select one option',
    this.required = false,
    this.errorText = 'Please select one option',
    this.value,
    this.dataSource,
    this.textField,
    this.valueField,
    this.onChanged,
    // this.fillColor,
    this.parentContext,
    this.isMap})
      : super(
    onSaved: onSaved,
    validator: validator,
    autovalidate: autovalidate,
    builder: (FormFieldState<dynamic> state) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InputDecorator(

              decoration: InputDecoration(

             border: InputBorder.none,
                // border: FormBorder(
                //   borderRadius: BorderRadius.circular(5),
                // ),

                contentPadding: EdgeInsets.zero,
              ),

              child: BankList(
                isDark: isDark,
                parentContext: parentContext,
                isMap: isMap ?? true,
                valueField: 'code',
                textField: 'name',
                bankList: dataSource,
                selectedBank: value,
                onChanged: onChanged,
                fillColor: isDark ? Color(0xff191D20) : lightBlue,
              ),
            ),
            SizedBox(height: state.hasError ? 5.0 : 0.0),
            Text(
              state.hasError ? state.errorText : '',
              style: TextStyle(
                  color: Colors.redAccent.shade700,
                  fontSize: state.hasError ? 12.0 : 0.0),
            ),
          ],
        ),
      );
    },
  );
}






class DropDownField2 extends FormField<dynamic> {
  final parentContext;
  final String titleText;
  final String hintText;
  final bool required;
  final String errorText;
  final dynamic value;
  List dataSource;
  final String textField;
  final String valueField;
  final Function onChanged;
  Color fillColor = lightBlue;
  final bool isMap;
  final bool isDark;


  DropDownField2({this.isDark,
    FormFieldSetter<dynamic> onSaved,
    FormFieldValidator<dynamic> validator,
    bool autovalidate = false,
    this.titleText = 'Title',
    this.hintText = 'Select one option',
    this.required = false,
    this.errorText = 'Please select one option',
    this.value,
    this.dataSource,
    this.textField,
    this.valueField,
    this.onChanged,
    // this.fillColor,
    this.parentContext,
    this.isMap})
      : super(
    onSaved: onSaved,
    validator: validator,
    autovalidate: autovalidate,
    builder: (FormFieldState<dynamic> state) {
      // print("datasource $dataSource");
      return Column(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InputDecorator(

                  decoration: InputDecoration(

                    border: InputBorder.none,
                    // border: FormBorder(
                    //   borderRadius: BorderRadius.circular(5),
                    // ),

                    contentPadding: EdgeInsets.zero,
                  ),

                  child: BankListIntl(
                    isDark: false,
                    parentContext: parentContext,
                    isMap: isMap ?? false,
                    valueField: 'code',
                    textField: 'name',
                    bankList: dataSource,
                    selectedBank: value,
                    onChanged: onChanged,
                    fillColor: isDark ? Color(0xff191D20) : lightBlue,
                  ),
                ),

              ],
            ),
          ),
          SizedBox(height: state.hasError ? 5.0 : 0.0),
          Text(
            state.hasError ? state.errorText : '',
            style: TextStyle(
                color: Colors.redAccent.shade700,
                fontSize: state.hasError ? 12.0 : 0.0),
          ),
        ],
      );
    },
  );
}
