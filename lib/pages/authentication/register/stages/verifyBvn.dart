import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glade_v2/core/models/apiModels/Auth/user.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/bankModel.dart';
import 'package:glade_v2/pages/authentication/login_page.dart';
import 'package:glade_v2/provider/Business/fundTransferState.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/reuseables/bankSingleton.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/dropDown.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:provider/provider.dart';


class VerifyBvn extends StatefulWidget {
  User user;
  VerifyBvn({this.user});
  @override
  _VerifyBvnState createState() => _VerifyBvnState();
}

class _VerifyBvnState extends State<VerifyBvn> with AfterLayoutMixin<VerifyBvn> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstName  = TextEditingController();
  TextEditingController lastName  = TextEditingController();
  FundTransferState fundTransferState;
  LoginState loginState;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController bvnPhone  = TextEditingController();
  TextEditingController bvnNumber  = TextEditingController();
  TextEditingController accountNumber  = TextEditingController();

  List<BankBVNModel> banks = [];
  var bank;
  bool isDark = true;
  AppState appState;
bool isLoading  = false;

@override
  void initState() {
    firstName.text = widget.user.firstname;
    lastName.text = widget.user.lastname;
    bvnNumber.text = widget.user.bvn.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    fundTransferState = Provider.of<FundTransferState>(context);
    loginState = Provider.of<LoginState>(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Header(
                preferredActionOnBackPressed: (){
                  pop(context);
                },
                text: "",
              ),
              SizedBox(height: 20),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        SizedBox(height: 30,),
                        Text(
                          "Note!",
                          style:TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color:  blue,
                          ),
                        ),
                        SizedBox(height: 2),
                        Container(
                          // margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Note, this is a compulsory requirement by CBN to maintain data integrity in line with the Know Your Customer(KYC) policy. \nThe First and Last name to be supplied should be as it is on your BVN.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: blue, fontSize: 13),
                          ),
                        ),
                        SizedBox(height: 10),


                        CustomTextField(
                          textEditingController: firstName,
                          header: "First Name",
                          hint: "Josteve",
                          validator: (value) {
                            if(value.trim().isEmpty){
                              return "First Name is required";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
//                          name = value;
                            });
                          },
                        ),
                        SizedBox(height: 15),
                        CustomTextField(
                          textEditingController: lastName,
                          header: "Last Name",
                          hint: "Adekanbi",
                          validator: (value) {
                            if(value.trim().isEmpty){
                              return "Last Name is required";
                            }

                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
//                          name = value;
                            });
                          },
                        ),

                        SizedBox(height: 15),
                        CustomTextField(
                          onTap: (){

                          },
                          textEditingController: bvnNumber,
                          textInputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                            new LengthLimitingTextInputFormatter(11),
                          ],

                          header: "BVN Number",
                          hint: "12345678902",
                          type: FieldType.phone,
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return "BVN number is required";
                            }
                            return null;
                          },

                          onChanged: (value) {

                            if (value.length < 10) {
                              return "Bvn incorrect";
                            } else if (value.length == 11) {


                            }

                          },
                        ),

                        SizedBox(height: 15),

                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Container(
                              // margin: EdgeInsets.only(
                              //     left: 20),
                              child: Text(
                                "Select a bank",
                                style: TextStyle(color: blue, fontSize: 12),
                              ),
                            ),
                            SizedBox(height: 4),
                            Container(
                              // margin:
                              // EdgeInsets.symmetric(
                              //     horizontal: 20.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: borderBlue.withOpacity(0.5),
                                  ),
                                  borderRadius:
                                  BorderRadius
                                      .circular(8)
                              ),
                              child: DropDownField(
                                isDark: false,
                                parentContext: context,
                                dataSource: banks,
                                value: bank,
                                validator: (value) {
//                                        if (isNull(value)) {
                                  if (value
                                      .toString()
                                      .isEmpty ||
                                      value.toString() ==
                                          "0") {
                                    return "Please select one option";
                                  }

                                  if (value
                                      .toString()
                                      .isEmpty ||
                                      value.toString() ==
                                          "0") {
                                    return "Please select one option";
                                  }
                                  return null;
                                },
                                hintText: "Select a Bank",
                                textField: 'name',
                                valueField: 'code',
                                onChanged: (value) {
                                  setState(() {
                                    bank = value;
                                  });

                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        CustomTextField(
                          onTap: (){

                          },
                          textEditingController: accountNumber,
                          textInputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                            new LengthLimitingTextInputFormatter(10),
                          ],

                          header: "Account Number",
                          hint: "0122012342",
                          type: FieldType.phone,
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return "Account number is required";
                            }
                            return null;
                          },

                          onChanged: (value) {

                            if (value.length < 10) {
                              return "Bvn incorrect";
                            } else if (value.length == 11) {


                            }

                          },
                        ),
                        SizedBox(height: 100),

                        Container(
                          // margin: EdgeInsets.symmetric(horizontal: 20),
                          child: SizedBox(
                            width: double.maxFinite,
                            height: 50,
                            child: RaisedButton(
                              onPressed: () {
                                if (_formKey.currentState.validate()  && bank != null)  {
                                  bvnMatch();
                                }else{
                                  CommonUtils.kShowSnackBar(ctx: context, msg: "Fill all forms and select a bank");
                                }
                              },
                              child: Text(
                                "Proceed",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              color: orange,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(height: 20,)

                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {

// loadBanks();

fetchBanks();
  }


  fetchBanks()async{
      // setState(() {
      //   isLoading = true;
      // });
    var result = await loginState.bvnMatchBanks(token: loginState.user.token);
        // setState(() {
        //   isLoading = false;
        // });
    if (result["error"] ==false) {
              // setState(() {
                banks = result["banks"];
              // });

            }else{
              CommonUtils.showMsg(body: result["message"], scaffoldKey: _scaffoldKey, snackColor: Colors.red);
            }
  }

  // Future loadBanks() async {
  //   print("calling");
  //   setState(() {
  //     isLoading = true;
  //   });
  //   var result = await loginState.bvnMatchBanks(token: loginState.user.token);
  //
  //   setState(() {
  //     isLoading = false;
  //   });
  //   try {
  //     setState(() {
  //       if (result["error"] ==false) {
  //
  //        banks = result["banks"];
  //
  //       }else{
  //         CommonUtils.showMsg(body: result["message"], scaffoldKey: _scaffoldKey, snackColor: Colors.red);
  //       }
  //     });
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }



  void bvnMatch ()async{
    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result = await loginState.bvnMatch(bvn: bvnNumber.text, first_name: firstName.text, last_name: lastName.text, bank_code: bank.bank_code, account_number: accountNumber.text,token: loginState.user.token);
    pop(context);
      if(result["error"] == false){
        CommonUtils.showAlertDialog(text:"BVN Matched Successfully", context: context, onClose: (){
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false);
        });
      }else{
        CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey: _scaffoldKey, snackColor: Colors.red );
      }
  }
}


