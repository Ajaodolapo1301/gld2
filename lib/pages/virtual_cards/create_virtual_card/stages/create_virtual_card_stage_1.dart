import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/virtualCardDesign.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/virtualCardTitle.dart';
import 'package:glade_v2/provider/Business/virtualCardState.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/widgets/custom_drop_down.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class CreateVirtualCardStage1 extends StatefulWidget {
  final Function(VirtualCardTitle value) onTitleSelected;
  CreateVirtualCardStage1({this.onTitleSelected});

  @override
  _CreateVirtualCardStage1State createState() => _CreateVirtualCardStage1State();
}

class _CreateVirtualCardStage1State extends State<CreateVirtualCardStage1> with AfterLayoutMixin<CreateVirtualCardStage1> {

  AppState appState;
  String cardTitle = "";
  VirtualCardState virtualCardState;
  LoginState loginState;
var vd = VirtualCardTitle();
bool isLoading = false;
  // List<VirtualCardTitle> vTiles = [
  //   VirtualCardTitle(
  //     card_title: "Best Buy Gift Card",
  //     id: "1"
  //   ),
  //   VirtualCardTitle(
  //       card_title: "Spar Gift Card",
  //       id: "2"
  //   ),
  //
  //   VirtualCardTitle(
  //       card_title: "Amazon Gift Card",
  //       id: "3"
  //   )
  // ];


  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);
    loginState = Provider.of<LoginState>(context);
    virtualCardState = Provider.of<VirtualCardState>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: [
                CustomDropDown<VirtualCardTitle>(
                  intialValue: CustomDropDownItem<VirtualCardTitle>(value:vd , text: isLoading ? "Loading" : "Select Card Purpose"),
                  suffix: isLoading ? CupertinoActivityIndicator()  :null ,
                  items: virtualCardState.virtualCardTitle.map((e) {
                    return CustomDropDownItem<VirtualCardTitle>(
                      text: e.card_title,
                      value: e
                    );
                  }).toList(),
                  onSelected: (value) {

                    setState(() {
                     widget.onTitleSelected(value);

                     // = value.card_title ;

                    });
                  },
                  header: "Select Purpose",
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // if (virtualCardState?.virtualCardTitle.isEmpty || virtualCardState?.virtualCardTitle == null) {
      getCardTiles();
    // }
  }


  getCardTiles() async {

    print("calling");
    setState(() {
      isLoading = true;
    });
    var result = await virtualCardState.getCardTitles(
        token: loginState.user.token);
    setState(() {
      isLoading = false;
    });
    if (result["error"] == false) {
      setState(() {

      });
    }else{
      toast("error occured");
    }
  }


}