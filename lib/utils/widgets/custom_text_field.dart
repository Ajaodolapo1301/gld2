import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';

class CustomTextField extends FormField<String> {
  final String header;
  final String hint;
  final bool obscureText;
  final Widget suffix;
  final Widget outerSuffix;
  final bool readOnly;
  final Widget prefix;
  final bool headerLess;
  final bool autoFocus;
  final int minLines;
  final int maxLines;
  final int lines;
  final Function  onTap;
  final color;
  final FocusNode focusNode;
  final List<TextInputFormatter> textInputFormatters;
  final FieldType  type;
  final ActionType  textActionType;
//<<<<<<< Updated upstream
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmit;
  final TextEditingController textEditingController;

  CustomTextField(
      {Key key,
      this.header,
        this.type,
      this.hint,
      this.obscureText = false,
      this.suffix,
      this.readOnly = false,
      this.outerSuffix,
      this.headerLess = false,
      this.prefix,
      this.minLines,
        this.color = lightBlue,
      this.maxLines,
      this.lines,
        this.onTap,
        this.autoFocus = false,
      this.textEditingController,
        this.textInputFormatters,
      this.validator,
        this.onSubmit,
        this.textActionType,
        this.focusNode,
      this.onChanged})
      : super(
          key: key,
          validator: validator,
          enabled: true,
          autovalidateMode: AutovalidateMode.disabled,
          initialValue: textEditingController != null ? textEditingController.text : "",
          builder: (FormFieldState<String> field) {
            final _CustomTextFieldState state = field as _CustomTextFieldState;


            void onChangedHandler(String value) {
              field.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
            }

            TextInputType getTextInputType() {
              switch (type) {
                case FieldType.email:
                  return TextInputType.emailAddress;
                  break;
                case FieldType.phone:
                  return TextInputType.phone;
                  break;

                case FieldType.multiline:
                  return TextInputType.multiline;
                  break;
                case FieldType.number:
                  return TextInputType.number;
                default:
                  return TextInputType.text;
                  break;
              }
            }

            TextInputAction getActionInputType( ) {
              switch (textActionType) {
                case ActionType.next:
                  return TextInputAction.next;
                  break;
                case ActionType.done:
                  return TextInputAction.done;
                  break;
                default:
                  return TextInputAction.next;
                  break;
              }
            }


            return Container(


              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  if (!headerLess)
                    Text(
                      header ?? "",
                      style: TextStyle(color: blue, fontSize: 12),
                    ),
                  SizedBox(height: 4),
                  Container(

                    child: Row(
                      children: [

                        Expanded(

                          child: Container(

                            padding: EdgeInsets.only(
                              right:  15,
                              left: prefix != null ?  15 : 0,
                            ),
                            decoration: BoxDecoration(
                              color: color,
                              border: Border.all(
                                color: borderBlue.withOpacity(0.35),
                              ),
                              borderRadius: outerSuffix == null
                                  ? BorderRadius.circular(6)
                                  : BorderRadius.only(
                                      topLeft: Radius.circular(6),
                                      bottomLeft: Radius.circular(6),
                                    ),
                            ),
                            child: Row(
                              children: [
                                prefix ?? Container(),
                                SizedBox(width: 5),
                                Expanded(
                                  child: TextField(

                                    textInputAction: getActionInputType(),
                                    keyboardType: getTextInputType(),
                                      autofocus:  autoFocus,

                                    focusNode: focusNode,
                                    onSubmitted: onSubmit,
                                    onTap: onTap,
                                      inputFormatters: textInputFormatters ,
                                    controller: state._effectiveController,
                                    readOnly: readOnly,
                                    onChanged: onChangedHandler,
                                    obscureText: obscureText,
                                    minLines: lines ?? minLines ?? 1,
                                    maxLines: lines ?? maxLines ?? 1,
                                    style: TextStyle(fontSize: 14, color: blue),
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.transparent),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.transparent),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.transparent),
                                      ),
                                      contentPadding: const EdgeInsets.only( top: 16, bottom: 16, left: 7),

                                      hintText: hint,

                                      hintStyle: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                suffix ?? Container()
                              ],
                          ),
                        ),
                        ),
                        outerSuffix ?? Container(),
                        ],
                    ),
                  ),
                  if (field.errorText != null)
                    Container(
                      margin: EdgeInsets.only(left: 5, top: 4),
                      child: Text(
                        field.errorText ?? "",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    )
                ],
              ),
            );
          },
        );

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends FormFieldState<String> {
  TextEditingController _controller;

  TextEditingController get _effectiveController => widget.textEditingController ?? _controller;

  @override
  CustomTextField get widget => super.widget as CustomTextField;

  TextInputType getTextInputType() {
    switch (widget.type) {
      case FieldType.email:
        return TextInputType.emailAddress;
        break;
      case FieldType.phone:
        return TextInputType.phone;
        break;

      case FieldType.multiline:
        return TextInputType.multiline;
        break;
      case FieldType.number:
        return TextInputType.number;
      default:
        return TextInputType.text;
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.textEditingController == null) {
      _controller = TextEditingController(text: widget.initialValue);
    } else {
      widget.textEditingController.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.textEditingController != oldWidget.textEditingController) {
      oldWidget.textEditingController?.removeListener(_handleControllerChanged);
      widget.textEditingController?.addListener(_handleControllerChanged);

      if (oldWidget.textEditingController != null && widget.textEditingController == null)
        _controller =
            TextEditingController.fromValue(oldWidget.textEditingController.value);
      if (widget.textEditingController != null) {
        setValue(widget.textEditingController.text);
        if (oldWidget.textEditingController == null) _controller = null;
      }
    }
  }

  @override
  void dispose() {
    widget.textEditingController?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void didChange(String value) {
    super.didChange(value);
    if (_effectiveController.text != value) {
      _effectiveController.text = value ?? '';
    }
  }

  @override
  void reset() {
    _effectiveController.text = widget.initialValue ?? '';
    super.reset();
  }

  void _handleControllerChanged() {
    if (_effectiveController.text != value)
      didChange(_effectiveController.text);
  }






}
enum FieldType { text, email, phone, password, dropdown, number, multiline }

enum ActionType { next, done }