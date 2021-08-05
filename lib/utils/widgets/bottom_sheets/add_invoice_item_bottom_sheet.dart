import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:glade_v2/core/models/apiModels/Business/Invoice/invoice.dart';
import 'package:glade_v2/provider/Business/invoiceState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/functions/bottom_sheet_utils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_drop_down.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class AddInvoiceItemBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic> value)onAddItem;
  const AddInvoiceItemBottomSheet({this.onAddItem});

  @override
  _AddInvoiceItemBottomSheetState createState() => _AddInvoiceItemBottomSheetState();
}

class _AddInvoiceItemBottomSheetState extends State<AddInvoiceItemBottomSheet> with AfterLayoutMixin<AddInvoiceItemBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  InvoiceState invoiceState;
  MoneyMaskedTextController amountController = MoneyMaskedTextController(
      decimalSeparator: ".",  thousandSeparator: ",");
  LoginState loginState;

  var itemName;
  var amount;
  var quantity;
  var currency;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
      invoiceState = Provider.of<InvoiceState>(context);

      loginState = Provider.of<LoginState>(context);
    return Container(
      height: MediaQuery.of(context).size.height - 100,
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
        children: [
          GestureDetector(
            onTap: () {
              pop(context);
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: lightBlue,
                    border: Border.all(color: borderBlue.withOpacity(0.1))),
                child: Icon(
                  Icons.close,
                  size: 20,
                  color: blue,
                ),
              ),
            ),
          ),
          Text(
            "Invoice items",
            style: TextStyle(
                color: blue, fontWeight: FontWeight.bold, fontSize: 17),
          ),
          // Text(
          //   // "Select your preferred currency, fill in the \nfields and click add item",
          //   textAlign: TextAlign.center,
          //   style: TextStyle(color: blue, fontSize: 12),
          // ),
          SizedBox(height: 20),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // CustomDropDown(
                  //   suffix: isLoading ? CupertinoActivityIndicator() : null,
                  //   intialValue: CustomDropDownItem(value: "hmm", text: "hmm"),
                  //   items: [CustomDropDownItem(value: "NGN", text: "Naira")],
                  //   onSelected: (v) {
                  //     setState(() {
                  //       currency = v;
                  //     });
                  //   },
                  //   header: "Select Currency",
                  // ),
                  // SizedBox(height: 15),
                  CustomTextField(header: "Enter invoice item",
                    validator: (value){
                      if(value.isEmpty){
                        return "Field is required";
                      }
                      itemName = value;
                      return null;
                    },

                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    textEditingController: amountController,
                    type: FieldType.number,
                    textInputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    header: "Enter Amount",
                    validator: (value ){
                      if(value == "0.00"){
                        return "Field is required";
                      }
                      amount = value;
                      return null;
                    },

                  ),
                  SizedBox(height: 15),
                  CustomTextField(

                    type: FieldType.number,
                    textInputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    header: "Enter Quantity",
                    validator: (value){
                      if(value.isEmpty){
                        return "Field is required";
                      }
                      quantity = value;
                      return null;
                    },

                  ),
                  SizedBox(height: 15),
                  CustomButton(
                    text: "Add Item",
                    onPressed: () {
                      if(_formKey.currentState.validate()){
                        pop(context);
                              var price = double.parse(amountController.text.replaceAll(",", "").trim().split(".")[0]) * double.parse(quantity);
                        widget.onAddItem({
                          "price":  price.round().toString(),
                          "description": itemName,
                          "qty": quantity
                        }

                          //   "description": "delivery charges",
                          //   "price": 6000,
                          //   "qty": 1,
                          //   "id": 2
                        );
                      }
                    },
                    color: cyan,
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if( invoiceState?.currencies == null){
        getCurrency();
    }
  }


  getCurrency()async{
    setState(() {
      isLoading  = true;
    });
    var result = await  invoiceState.getCurrency(token: loginState.user.token);
     setState(() {
       isLoading  = false;
     });
      if(result["error"]== false){
       setState(() {

       });
      }else{
        toast("message");
      }
  }



}
