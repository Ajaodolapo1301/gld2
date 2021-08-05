import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:glade_v2/core/models/apiModels/Auth/Business.dart';
import 'package:glade_v2/core/models/apiModels/Auth/allBusiness.dart';
import 'package:glade_v2/pages/dashboard/dashboard_page.dart';
import 'package:glade_v2/pages/personal/add_a_business_account/select_a_business_account_page.dart';
import 'package:glade_v2/pages/switch_busimness_details.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/reuseables/dialogPopup.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SwitchAccountPage extends StatefulWidget {
  @override
  _SwitchAccountPageState createState() => _SwitchAccountPageState();
}

class _SwitchAccountPageState extends State<SwitchAccountPage>  with AfterLayoutMixin<SwitchAccountPage>{
  BusinessState busnessState;
  List<AllBusiness> listOfBusiness = [];

  LoginState loginState;
    bool isLoading = false;

  double textScale = 1.0;
  void initTextScale() async {
    var pref = await SharedPreferences.getInstance();
    setState(() {
      textScale = pref.getDouble("textScaleFactor") ?? 1.0;
    });
  }

  @override
  void initState() {
  initTextScale();
    super.initState();
  }


  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    busnessState = Provider.of<BusinessState>(context);

    loginState = Provider.of<LoginState>(context);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: textScale),
      child: Scaffold(
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          child: IconButton(
              icon: Icon(Icons.add),
            onPressed: (){
              pushTo(context, SelectABusinessAccountPage());
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 10),
                Header(
                  text: "Switch Account",
                ),
                SizedBox(height: 10),
       isLoading ? Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Center(child: CircularProgressIndicator())

         ],
       ) :      Expanded(
                  child: Builder(
                    builder: (context) {
//                    bool l = false;
                      if (listOfBusiness.isNotEmpty) {
                        return AnimatedList(
                          initialItemCount: listOfBusiness.length,
                          itemBuilder: (context, index, animation) {
                            return accountItem(

                              business_uuid: listOfBusiness[index].business_uuid,
                              business: listOfBusiness[index],
                              isActive: true,

                              animation: animation
                            );
                          },
                          // separatorBuilder: (context, index) =>
                          //     SizedBox(height: 20),
                          // itemCount:
                        );
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "No Business Found.",
                            style: TextStyle(
                                color: blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                          Text(
                            "Click the button below to add new business and \nget started",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: blue, fontSize: 11),
                          )
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget accountItem(
      {

        AllBusiness business,
        animation,
        business_uuid,
      bool isActive}) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
    pushTo(context, SwitchAccountDetails(business: business,));
            // setDefault(business_uuid: business_uuid);

          },
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset(0, 0),
            ).animate(animation),
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: lightBlue,
                border: Border.all(
                  color: borderBlue.withOpacity(0.05),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            business.business_name,
                          style: TextStyle(
                            color: blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Business Account",
                          style: TextStyle(color: blue),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: orange,
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20,),
      ],
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
  getBusiness();
  }

  getBusiness()async{
    setState(() {
      isLoading = true;
    });
  var result = await busnessState.getAllBusiness(token: loginState.user.token);
    setState(() {
      isLoading = false;
    });
      if(result["error"] == false){
        setState(() {
          listOfBusiness = result["business"];
        });
      }else if (result["error"] == true && result["statusCode"] == 401) {
        // showDialog(
        //     barrierDismissible: false,
        //     context: context,
        //     child: dialogPopup(
        //         context: context,
        //         body: result["message"]
        //     ));

        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_)=> dialogPopup(
                context: context,
                body: result["message"]
            )

        );
      }else{

      }


  }










}
