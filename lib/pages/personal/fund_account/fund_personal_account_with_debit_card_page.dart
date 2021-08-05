import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:glade_v2/core/models/ui/cardInfo.dart';
import 'package:glade_v2/pages/states/fund_account_VirtualCard_successful_page.dart';
import 'package:glade_v2/pages/states/fund_account_successful_page.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/Personal/fundAccountState.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/reuseables/cardPin.dart';
import 'package:glade_v2/reuseables/cardPinEntry.dart';
import 'package:glade_v2/reuseables/dialogPopup.dart';
import 'package:glade_v2/reuseables/otpEntry.dart';
import 'package:glade_v2/reuseables/webViewContainer.dart';
import 'package:glade_v2/utils/card/card_validator.dart';
import 'package:glade_v2/utils/functions/bottom_sheet_utils.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/myUtils/cardNumberInputFormatter.dart';
import 'package:glade_v2/utils/myUtils/monthFormatter.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/bottom_sheets/transaction_pin_bottom_sheet.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:provider/provider.dart';

class  FundPersonalAccountWithDebitCardPage extends StatefulWidget {
  @override
  _FundPersonalAccountWithDebitCardPageState createState() =>
      _FundPersonalAccountWithDebitCardPageState();
}

class _FundPersonalAccountWithDebitCardPageState extends State<FundPersonalAccountWithDebitCardPage> {

  var numberController = new TextEditingController();
  CardInfo _cardInfo = CardInfo();
  var cardname = new TextEditingController();
  var cardNum = new TextEditingController();
  bool savedCard = false;
  FundAccountState fundAccountState;
  LoginState loginState;
BusinessState businessState;
AppState appState;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _formKey = new GlobalKey<FormState>();
  var expMonth = new TextEditingController();
  var cvv = new TextEditingController();

  MoneyMaskedTextController amountController = MoneyMaskedTextController(
      decimalSeparator: ".",  thousandSeparator: ",");
  void _getCardTypeFrmNumber() {
    String input = CardValidator.getCleanedNumber(numberController.text);
    CardType cardType = CardValidator.getCardTypeFrmNumber(input);
    print(cardType);
    setState(() {
      this._cardInfo.cardType = cardType;
    });
  }

  @override
  void initState() {
    _cardInfo.cardType = CardType.Others;
    numberController.addListener(_getCardTypeFrmNumber);
    super.initState();
  }

@override
  void dispose() {
  // Clean up the controller when the Widget is removed from the Widget tree
  numberController.removeListener(_getCardTypeFrmNumber);
  numberController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    businessState = Provider.of<BusinessState>(context);
    appState = Provider.of<AppState>(context);
    fundAccountState = Provider.of<FundAccountState>(context);
    loginState = Provider.of<LoginState>(context);
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Header(
                    text: "Fund with Debit Card",
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        // SizedBox(height: 20),
                        // CustomTextField(
                        //     textEditingController: cardname,
                        //   header: "Enter a Card Title",
                        //   validator: (v){
                        //       if(v.isEmpty){
                        //         return   "Empty";
                        //       }
                        //     return null;
                        //   },
                        // ),
                        SizedBox(height: 15),

                        CustomTextField(

                            textEditingController: numberController,
                          validator: _validateCardNumWithLuhnAlgorithm,
                          type: FieldType.number,
                          textInputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                            new LengthLimitingTextInputFormatter(19),
                            CardNumberInputFormatter()

                          ],
                          onChanged: (String value) {
                            setState(() {
                              _cardInfo.number = CardValidator.getCleanedNumber(numberController.text);
                            });


                          },
                          header: "Enter Card Number [ 0000 0000 0000 0000 ]",
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 5, top: 3),
                          child:
                          Text(
                            _getCardIcon(),
                            style: TextStyle(
                                color: cyan,
                                fontWeight: FontWeight.bold,
                                fontSize: 10
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        CustomTextField(
                          validator: CardValidator.validateDate,
                          header: "Valid Date [mm/yy]",
                          textInputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                            MonthInputFormatter()
                          ],
                          onChanged: (value) {
                            List<int> expiryDate = CardValidator.getExpiryDate(value);
                            setState(() {
                              _cardInfo.month = expiryDate[0];
                              _cardInfo.year = expiryDate[1];

                            });
                          },
                        ),
                        SizedBox(height: 15),
                        CustomTextField(

                          textInputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                            new LengthLimitingTextInputFormatter(4),
                          ],
                          type: FieldType.number,
                          validator: CardValidator.validateCVV,
                          onChanged: (value) {
                            setState(() {
                              _cardInfo.cvv = value;
                            });
                          },
                          header: "CVV [000]",
                        ),

                        SizedBox(height: 20),
                        CustomTextField(
                          prefix: Text("NGN"),
                          validator: (v){
                            if(v == "0.00"){
                              return "Empty";
                            }
                            return null;
                          },
                          textEditingController: amountController,
                          header: "Input Amount to fund",
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Save Card",
                                style: TextStyle(color: blue),
                              ),
                            ),
                            Transform(
                              transform: Matrix4.identity()
                                ..scale(0.5)
                                ..translate(20.0, 20.0),
                              child: CupertinoSwitch(
                                value: savedCard,
                                activeColor: blue,
                                onChanged: (value) {
                                  setState(() {
                                    savedCard = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                  CustomButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        // fundAccount();
                        initialize();
                      }
                    },
                    color: cyan,
                    text: "Proceed",
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  String _getCardIcon() {
    String img = "";
    switch (_cardInfo.cardType) {
      case CardType.Master:
        img = 'mastercard';
        break;
      case CardType.Visa:
        img = 'visa';
        break;
      case CardType.Verve:
        img = 'verve';
        break;
      case CardType.AmericanExpress:
        img = 'american_express';
        break;
      case CardType.Discover:
        img = 'discover';
        break;
      case CardType.DinersClub:
        img = 'dinners_club';
        break;
      case CardType.Jcb:
        img = 'jcb';
        break;

        break;
      case CardType.Invalid:
        img = "invalid";
        break;
    }
      print("img $img");
    return img;
  }

  String _validateCardNumWithLuhnAlgorithm(String value) {
    if (value.isEmpty) {
      return "Field is required";
    }
  }



//  calls

// void fundAccount()async{
//   showDialog(
//       context: this.context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Preloader();
//       });
//     var result = await fundAccountState.fundAccount(token: loginState.user.token, card_name: cardname.text, card_number: _cardInfo.number, save_card: false, expiry: _cardInfo.year.toString(), expiry_month: _cardInfo.month.toString().length  == 1 ? "0${_cardInfo.month.toString()}": _cardInfo.month.toString() , cvv: _cardInfo.cvv,  amount: amountController.text.replaceAll(",", "").split(".")[0], loginState: loginState, business_uuid: businessState.business.business_uuid, isPersonal: appState.isPersonal);
//       pop(context);
//       if(result["error"] == false){
//       print(result);
//
//         // PIN TRANSACTION
//         if(result["message"]["auth_type"] == "PIN") {
//           final pin = await  _getAuthValue(result["message"]["auth_type"]);
//           print(pin);
//               if(pin != null){
//                 showDialog(
//                     context: this.context,
//                     barrierDismissible: false,
//                     builder: (BuildContext context) {
//                       return Preloader();
//                     });
//                 var result2 = await fundAccountState.fundAccountCharge(token: loginState.user.token, card_name: cardname.text, card_number: _cardInfo.number, save_card: false, expiry: _cardInfo.year.toString(), expiry_month:_cardInfo.month.toString().length  == 1 ? "0${_cardInfo.month.toString()}": _cardInfo.month.toString(), cvv: _cardInfo.cvv,  amount: amountController.text.replaceAll(",", "").split(".")[0], loginState: loginState, pin: pin, business_uuid: businessState.business.business_uuid, isPersonal: appState.isPersonal);
//               pop(context);
//                   if(result2["error"] == false){
//                     showDialog(
//                         context: this.context,
//                         barrierDismissible: false,
//                         builder: (BuildContext context) {
//                           return Preloader();
//                         });
//
//                         print("res 2 $result2");
//
//                         print(" aa ${result2["message"]["auth_type"]}");
//
//
//                          // / if charge bring auth type of OTP
//                           if(result2["message"]["auth_type"] != null  && result2["message"]["auth_type"] == "OTP"){
//                             final otp = await  _getAuthValue(result2["message"]["auth_type"]);
//
//                             if (otp != null) {
//                               showDialog(
//                                   context: this.context,
//                                   barrierDismissible: false,
//                                   builder: (BuildContext context) {
//                                     return Preloader();
//                                   });
//                               var result22 = await fundAccountState.fundAccountValidate(otp: otp,
//                                   txRef: result2["message"]["txnRef"],
//                                   token: loginState.user.token, business_uuid: businessState.business.business_uuid, isPersonal: appState.isPersonal);
//                               print("2 $result22");
//                               if (result22["error"] == false) {
//                                 var result33 = await fundAccountState.fundAccountVerify(
//                                     txRef: result22["message"]["txnRef"],
//                                     token: loginState.user.token, business_uuid: businessState.business.business_uuid, isPersonal: appState.isPersonal);
//                                 print("3 $result33");
//                                 if (result33["error"] == false) {
//                                   pushTo(context, FundAccountSuccessfulPage());
//                                 } else {
//                                   CommonUtils.showMsg(body: result33["message"],
//                                       context: context,
//                                       snackColor: Colors.red,
//                                       scaffoldKey: _scaffoldKey);
//                                 }
//                               }else {
//                                 pop(context);
//                                 CommonUtils.showMsg(body: result22["message"], context: context, snackColor: Colors.red, scaffoldKey: _scaffoldKey);
//                               }
//                             }else{
//                               pop(context);
//                               CommonUtils.showMsg(body:"No Otp Supplied", context: context, snackColor: Colors.red, scaffoldKey: _scaffoldKey);
//
//                             }
//                           }
//
//
//
//
//                     var result3 =  await fundAccountState.fundAccountVerify(txRef: result2["message"]["txnRef"], token: loginState.user.token, business_uuid: businessState.business.business_uuid, isPersonal: appState.isPersonal);
//                       pop(context);
//                         if(result3["error"] == false){
//
//                           CommonUtils.getBalance(loginState);
//                           pushTo(context, FundAccountSuccessfulPage());
//                         }else{
//                           CommonUtils.showMsg(body: result3["message"], context: context, snackColor: Colors.red, scaffoldKey: _scaffoldKey);
//
//                         }
//                   }else{
//                     CommonUtils.showMsg(body:result2["message"], context: context, snackColor: Colors.red, scaffoldKey: _scaffoldKey);
//
//                   }
//
//               }else{
//                 CommonUtils.showMsg(body:"No Pin Supplied", context: context, snackColor: Colors.red, scaffoldKey: _scaffoldKey);
//
//               }
//
//
//
//
//               // if initiate btings OTP
//         }else if(result["message"]["auth_type"] == "OTP") {
//           final otp = await _getAuthValue(result["message"]["auth_type"]);
//           if (otp != null) {
//             showDialog(
//                 context: this.context,
//                 barrierDismissible: false,
//                 builder: (BuildContext context) {
//                   return Preloader();
//                 });
//             var result2 = await fundAccountState.fundAccountValidate(otp: otp,
//                 txRef: result["message"]["txnRef"],
//                 token: loginState.user.token, business_uuid: businessState.business.business_uuid, isPersonal: appState.isPersonal);
//
//             print(result2);
//             if (result2["error"] == false) {
//               var result3 = await fundAccountState.fundAccountVerify(
//                   txRef: result2["message"]["txnRef"],
//                   token: loginState.user.token, business_uuid: businessState.business.business_uuid, isPersonal: appState.isPersonal);
//
//               if (result3["error"] == false) {
//                 pushTo(context, FundAccountSuccessfulPage());
//               } else {
//                 CommonUtils.showMsg(body: result3["message"],
//                     context: context,
//                     snackColor: Colors.red,
//                     scaffoldKey: _scaffoldKey);
//               }
//             }else {
//               CommonUtils.showMsg(body: result2["message"], context: context, snackColor: Colors.red, scaffoldKey: _scaffoldKey);
//             }
//           }else{
//
//             CommonUtils.showMsg(body:"No Otp Supplied", context: context, snackColor: Colors.red, scaffoldKey: _scaffoldKey);
//
//           }
//         }else if(result["message"]["auth_type"] == "browser"){
//           Navigator.push(context, MaterialPageRoute(builder: (context)=> WebViewContainer(result["message"]["validate"])));
//
//         }
//       }else if(result["statusCode"] == 401){
//         showDialog(
//             barrierDismissible: false,
//             context: context,
//             child: dialogPopup(
//                 context: context,
//                 body: result["message"]
//             ));
//
//       }else{
// CommonUtils.showMsg(body: result["message"], context: context, snackColor: Colors.red, scaffoldKey: _scaffoldKey);
//       }
//   }


    initialize() async{
      showDialog(
          context: this.context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Preloader();
          });
      var resultInitialize = await fundAccountState.fundAccount(token: loginState.user.token, card_name: cardname.text, card_number: _cardInfo.number, save_card: savedCard, expiry: _cardInfo.year.toString(), expiry_month: _cardInfo.month.toString().length  == 1 ? "0${_cardInfo.month.toString()}": _cardInfo.month.toString() , cvv: _cardInfo.cvv,  amount: amountController.text.replaceAll(",", "").split(".")[0], loginState: loginState, business_uuid: businessState.business?.business_uuid ?? '', isPersonal: appState.isPersonal, );
      pop(context);
      if(resultInitialize["error"] == false){
        if(resultInitialize["message"]["auth_type"] == "PIN") {
        // Bring up dialog box for PIN
          final pin = await _getAuthValue(resultInitialize["message"]["auth_type"]);
             //call charge endpoint
            if(pin != null){
              charge(pin: pin, auth_type:resultInitialize["message"]["auth_type"]);
            }else{
              CommonUtils.showMsg(body:"No PIn Supplied", context: context, snackColor: Colors.red, scaffoldKey: _scaffoldKey);
            }
        }else if(resultInitialize["message"]["auth_type"] != "PIN"){
          charge(pin: null, auth_type:resultInitialize["message"]["auth_type"]);
        }
      }else if(resultInitialize["error"] == true && resultInitialize["statusCode"] == 401){
        // showDialog(
        //     barrierDismissible: false,
        //     context: context,
        //     child: dialogPopup(
        //         context: context,
        //         body: resultInitialize["message"]
        //     ));
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_)=> dialogPopup(
                context: context,
                body: resultInitialize["message"]
            )

        );
      }

      else{
        // pop(context);
        CommonUtils.showMsg(body: resultInitialize["message"], context: context, snackColor: Colors.red, scaffoldKey: _scaffoldKey);
      }
  }




  charge({pin, auth_type}) async{
    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var resultCharge = await fundAccountState.fundAccountCharge(token: loginState.user.token, card_name: cardname.text, card_number: _cardInfo.number, save_card: savedCard, expiry: _cardInfo.year.toString(), expiry_month:_cardInfo.month.toString().length  == 1 ? "0${_cardInfo.month.toString()}": _cardInfo.month.toString(), cvv: _cardInfo.cvv,  amount: amountController.text.replaceAll(",", "").split(".")[0], loginState: loginState, pin: pin != null ? pin : "", business_uuid: businessState.business?.business_uuid ?? " ", isPersonal: appState.isPersonal, auth_type: auth_type);
    pop(context);

    print(" resC $resultCharge");
    if(resultCharge["error"] ==  false){
      if(resultCharge["message"]["auth_type"] == "OTP" || resultCharge["message"]["auth_type"] == "otp"){
        final otp = await _getAuthValue(resultCharge["message"]["auth_type"]);
        validate(txRef: resultCharge["message"]["txnRef"], otp: otp);
      }else if(resultCharge["message"]["auth_type"] == "Avs" ) {

      }else{
        verify(txRef: resultCharge["message"]["txnRef"]);
      }

    }else{
      CommonUtils.showMsg(body: resultCharge["message"], context: context, snackColor: Colors.red, scaffoldKey: _scaffoldKey);

    }


  }


validate({otp, txRef }) async{
  showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Preloader();
      });
  var resultValidate = await fundAccountState.fundAccountValidate(otp: otp, txRef: txRef, token: loginState.user.token, business_uuid: businessState.business?.business_uuid?? "", isPersonal: appState.isPersonal);

  pop(context);
  print(resultValidate);
    if(resultValidate["error"] == false){
      verify(txRef: resultValidate["message"]["txnRef"]);
    }else{
      CommonUtils.showMsg(body: resultValidate["message"], context: context, snackColor: Colors.red, scaffoldKey: _scaffoldKey);

    }


}




verify({txRef})async{
  showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Preloader();
      });
  // var resultVerify = await fundAccountState.fundAccountVerify(
  //     txRef: txRef,
  //     token: loginState.user.token, business_uuid: businessState.business?.business_uuid ?? "", isPersonal: appState.isPersonal);
   pop(context);
  pushTo(context, FundAccountSuccessfulPage());
  // if(resultVerify["error"] == false){
  //   pushTo(context, FundAccountSuccessfulPage());
  // }else{
  //   CommonUtils.showMsg(body: resultVerify["message"], context: context, snackColor: Colors.red, scaffoldKey: _scaffoldKey);
  //
  // }

}










  Future<String> _getAuthValue(String response, [String message]) async {
    final _value = await _showValueModal(
      title: response,
      message: message ?? "Please provide your $response",
    );

    return _value;
  }
  Future<String> _showValueModal({String title, String message}) async {
    String value = await showModalBottomSheet<String>(
      isScrollControlled: true,
//      barrierDismissible: false,
      context: context,
      builder: (c) {
        return ValueCollectorComponent(
            title: title,
            message: message,
            onValueCollected: (value) {


              Navigator.of(
                c,
                rootNavigator: true,
              ).pop(value);
            });
      },
    );

    return value;
  }

}
























class ValueCollectorComponent extends StatefulWidget {
  final String title;
  final String message;
  final Function(String) onValueCollected;

  const ValueCollectorComponent({
    Key key,
    this.title,
    this.message,
    this.onValueCollected,
  }) : super(key: key);

  @override
  _ValueCollectorComponentState createState() =>
      _ValueCollectorComponentState();
}

class _ValueCollectorComponentState extends State<ValueCollectorComponent> {
  String value;

  @override
  Widget build(BuildContext context) {
      print("widget title ${widget.title}");
    return   widget.title == "PIN"  ?  CardPinBottomSheet(
            // onButtonPressed: (){
            //     setState(() {
            //
            //     });
            // },




    ) : widget.title == "OTP" || widget.title == "otp"   ? OtpPinBottomSheet(





    )   : Container();
  }
}