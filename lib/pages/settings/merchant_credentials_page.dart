import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class MerchantCredentialsPage extends StatefulWidget {
  @override
  _MerchantCredentialsPageState createState() =>
      _MerchantCredentialsPageState();
}

class _MerchantCredentialsPageState extends State<MerchantCredentialsPage> with AfterLayoutMixin<MerchantCredentialsPage> {
  LoginState loginState;
  TextEditingController merchantID = TextEditingController();
  TextEditingController merchant_key = TextEditingController();
  TextEditingController referral_code = TextEditingController();


  @override
  void initState() {


    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    loginState = Provider.of<LoginState>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 10),
              Header(
                text: "User Credentials",
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                 loginState.user.mid == null ? SizedBox() :    Column(
                        children: [
                          CustomTextField(
                            textEditingController: merchantID,
                            header: "Merchant ID",
                            readOnly: true,
                            hint: "GP_flhehbsbabachashRTSHJbdb92",
                            suffix: InkWell(
                              onTap: (){
                                Clipboard.setData(
                                  new ClipboardData(
                                    text: loginState.user.mid,
                                  ),
                                );
                                toast("Copied to Clipboard");
                              },
                              child: Icon(
                                Icons.file_copy_rounded,
                                color: cyan,
                                size: 17,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          loginState.user.key == null ? SizedBox() :          CustomTextField(
                            textEditingController: merchant_key,
                            header: "Merchant Key",
                            readOnly: true,
                            hint: "2GTRhfjiejebegyefiueioj2bchjjk23",
                            suffix: InkWell(
                              onTap: (){
                                Clipboard.setData(
                                  new ClipboardData(
                                    text: loginState.user.key,
                                  ),
                                );
                                toast("Copied to Clipboard");
                              },
                              child: Icon(
                                Icons.file_copy_rounded,
                                color: cyan,
                                size: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 15),
                    CustomTextField(
                  textEditingController: referral_code,
                      header: "Referral Code",
                      readOnly: true,
                      hint: "GD021222223333",
                      suffix: InkWell(
                        onTap: (){
                          Clipboard.setData(
                            new ClipboardData(
                              text: loginState.user.referral_code,
                            ),
                          );
                          toast("Copied to Clipboard");
                        },
                        child: Icon(
                          Icons.file_copy_rounded,
                          color: cyan,
                          size: 17,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    referral_code.text = loginState.user.referral_code;
    if(loginState.user.mid != null){
      merchantID.text = loginState.user.mid;
      merchant_key.text = loginState.user.key;
    }

  }
}
