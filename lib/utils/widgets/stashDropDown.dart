



import 'package:flutter/material.dart';
import 'package:glade_v2/reuseables/form.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';

class StashDropDownField extends FormField<dynamic> {
  Key key;
  final String titleText;
  final String hintText;
  final bool required;
  final String errorText;
  final dynamic value;
  final List dataSource;
  final String textField;
  final String valueField;
  final Function onChanged;
  Color fillColor = lightBlue;
  final bool isDark;

  StashDropDownField({this.isDark = false,
    FormFieldSetter<dynamic> onSaved,
    this.key,
    FormFieldValidator<dynamic> validator,
    bool autovalidate = false,
    this.titleText = 'Title',
    this.hintText = '',
    this.required = false,
    this.errorText = 'Please select a transfer method',
    this.value,
    this.dataSource,
    this.textField,
    this.valueField,
    this.onChanged,
    this.fillColor})
      : super(
    key: key,
    onSaved: onSaved,
    validator: validator,
    autovalidate: autovalidate,
    builder: (FormFieldState<dynamic> state) {
      return Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleText,
            style: TextStyle(color: blue, fontSize: 12),
          ),
          SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: borderBlue.withOpacity(0.5),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InputDecorator(
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      filled: true,
                      fillColor: lightBlue,
                      border: FormBorder(borderRadius: BorderRadius.circular(5.0))
                  ),
                  child: DropdownButtonHideUnderline(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                      child: DropdownButton<dynamic>(
                        icon:Icon(
                          Icons.keyboard_arrow_down,
                          color: dataSource.isEmpty ? orange.withOpacity(0.4): orange,
                        ),
                        dropdownColor: isDark ? Color(0xff191D20) : Colors.white,
                        isDense: true,
                        hint: Text(
                          hintText,
                          style: TextStyle(color: isDark ? Colors.white : blue, fontSize: 14),
                        ),
                        value: value == '' ? null : value,
                        onChanged: (dynamic newValue) {
                          state.didChange(newValue);
                          onChanged(newValue);
                        },
                        items: dataSource.map((item) {
                          return DropdownMenuItem<dynamic>(
                            value: item,
                            child: Text(
                              // item.length > 25
                              //     ? item.substring(0, 25)
                              item.stash_type_name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 14,
                                  color:  blue
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
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
          ),
        ],
      );
    },
  );
}