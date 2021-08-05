import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterStage1 extends StatefulWidget {
  GlobalKey<FormState> formKey;
  PageController controller;
  int index;
  final Function(String value)onBvnPayload;
  RegisterStage1({this.formKey, this.controller, this.onBvnPayload, this.index});
  @override
  _RegisterStage1State createState() => _RegisterStage1State();
}

class _RegisterStage1State extends State<RegisterStage1> with AfterLayoutMixin<RegisterStage1> {

  AppState appState;
  bool selected = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Form(
        key: _formKey,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello!\nWelcome.",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: blue,
                            fontSize: 21),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Create  a New Account in minutes by telling us about yourself.",
                        style: TextStyle(
                          color: blue,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
                AnimatedAlign(
                  curve: Curves.fastOutSlowIn,
                  duration: Duration(seconds: 2),
                  alignment: selected ? Alignment.centerRight  :  Alignment.center,
                  child: Image.asset(
                    "assets/images/bicycle_man.png",
                    width: 100,
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            CustomTextField(

              type: FieldType.number,
              textInputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
                new LengthLimitingTextInputFormatter(11),
              ],
              validator: (value) {
                if (value.isEmpty) {
                  return "BVN is required";
                }
                return null;
              },
              header: "BVN",
              hint: "Enter Your BVN",
              onChanged: (String value){
                setState(() {
                  if(value.length == 11){
                      widget.onBvnPayload(value);
                  }
                  // appState.bvn = value;

                });

              },

            ),
            SizedBox(height: 10),
            // RichText(
            //   text: TextSpan(
            //     text: "Forgot your BVN? Dial",
            //     style: TextStyle(
            //       color: blue,
            //       fontFamily: 'DMSans',
            //       fontSize: 12,
            //       fontWeight: FontWeight.normal,
            //     ),
            //     children: [
            //
            //       TextSpan(
            //         text:" *565*0#",
            //         style: TextStyle(
            //             color: orange, fontWeight: FontWeight.normal),
            //       )
            //     ],
            //   ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Forgot your BVN? Dial",
                  style: TextStyle(
                    color: blue,
                    fontFamily: 'DMSans',
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),

                ),
                InkWell(
                  onTap: (){
                    _makePhoneCall("tel:*565*0#");
                  },
                  child: Text(
                   "*565*0#",
                    style: TextStyle(
                        color: orange, fontWeight: FontWeight.normal),
                  ),
                )
              ],
            ),
            // Text(" *556#", style: TextStyle(fontWeight: FontWeight.w500),),


Spacer(),
            Container(
              // padding: EdgeInsets.symmetric(horizontal: 25),
              child: CustomButton(
                onPressed:  () async {
                  if(widget.index == 0 ){
                    if(_formKey.currentState.validate()){
                      verifyBVn();
                      print("bs");
                    }
                  // }else if(index == 1){
                  //   if(_formKey.currentState.validate()){
                  //     setState(() {
                  //       index ++;
                  //     });
                  //     await controller.nextPage(
                  //       duration: Duration(milliseconds: 500),
                  //       curve: Curves.easeOutExpo,
                  //     );
                  //   }
                  // }else if(index == 2){
                  //   if(_formKey.currentState.validate()){
                  //     print(_formKey.currentState.validate());
                  //     register(context);
                  //
                  //   }
                  // }else if (index == 3) {
                  //   if(passcode != null){
                  //     createPassCode(passcode);
                  //   }
                  // }
                  // else if (index ==4){
                  //   if(passcode != null){
                  //     createPassCode(passcode);
                  //   }
                  // }





                  //Check index to know the endpoint to call
                  // if (controller.page == 4) {
                  //
                  // }
                  // else if (controller.page ==  1) {
                  //
                  //     FocusScope.of(context).requestFocus(FocusNode());
                    }


                },
                text:  "Next",
                showArrow: true,
                color: cyan,
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      selected = true;
    });
  }


  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  verifyBVn()async{
    setState(() {
    widget.index++;
    });
    await widget.controller.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutExpo,
    );


  }


}
