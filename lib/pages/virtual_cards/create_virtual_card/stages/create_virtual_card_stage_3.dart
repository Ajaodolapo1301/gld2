import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/virtualCardDesign.dart';
import 'package:glade_v2/provider/Business/virtualCardState.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:provider/provider.dart';

class CreateVirtualCardStage3 extends StatefulWidget {
  final Function(String value) onDesignSelected;
  CreateVirtualCardStage3({this.onDesignSelected});
  @override
  _CreateVirtualCardStage3State createState() =>
      _CreateVirtualCardStage3State();
}

class _CreateVirtualCardStage3State extends State<CreateVirtualCardStage3> with AfterLayoutMixin<CreateVirtualCardStage3>{
  Color selectedColor = Colors.black;
AppState appState;

VirtualCardState virtualCardState;
LoginState loginState;
String colorCode;

  List<RadioModel> sampleData = new List<RadioModel>();
  Color deepTangerine = Color(0xFFFEB816);
  Color deepSkyBlue = Color(0xFF166BFE);
  Color jaggerPurple = Color(0xFF3F2B4B);
  Color deepPink = Color(0xFFFE1692);
  Color rebbecaPurple = Color(0xFF4B3C9C);
  Color gladeOrange = Color(0XFFFF8000);
  Color gladeBlue = Color(0xFF16AFFE);
  Color deepGreen = Color(0xFF209189);

  @override
  void initState() {
    sampleData.add(new RadioModel(
        isSelected: true, button: Colors.black, colorCode: "#000000", text: "Default"));
    sampleData.add(new RadioModel(
        isSelected: false, button: Color(0xffFEB816), colorCode: "#FEB816", text: "Dark Tangerine"));
    sampleData.add(new RadioModel(
        isSelected: false, button: Color(0xFF166BFE), colorCode: "#16AFFE", text: "Deep Sky Blue"));
    sampleData.add(new RadioModel(
        isSelected: false, button: Color(0xff3F2B4B),colorCode: "#3F2B4B",  text: "Jagger Purple"));
    sampleData.add(new RadioModel(
        isSelected: false, button: Color(0xffFE1692),colorCode: "#FE1692",  text: "Deep Pink"));
    sampleData.add(new RadioModel(
        isSelected: false, button: Color(0xFF209189),colorCode: "#2DD280",  text: " Shamrock Green"));
    sampleData.add(new RadioModel(
        isSelected: false, button: Color(0xFF16AFFE),colorCode: "#16AFFE",  text: " Glade Blue"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);

    loginState = Provider.of<LoginState>(context);
    virtualCardState = Provider.of<VirtualCardState>(context);
//    initColors();
    return Container(
      child: Column(
        children: [
          AnimatedContainer(
            height: 200,
            duration: Duration(milliseconds: 500),
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: selectedColor == Colors.white ? Colors.black : selectedColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              children: [
                Center(
                  child: SvgPicture.asset(
                    "assets/images/world.svg",
                    width: 220,
                  ),
                ),
                Center(
                  child: SvgPicture.asset(
                    "assets/images/GladeLogoWhite.svg",
                    width: 220,
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  child: Text(
                    "VIRTUAL NAIRA CARD",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Text(
                  appState.cardTitle?.toUpperCase() ??  " ",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Text(
                    "VISA".toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 10),
         Expanded(
           child: ListView.builder(
             padding: EdgeInsets.symmetric(horizontal: 5),
             itemBuilder: (context, index){

               return GestureDetector(
                 onTap: (){
                   setState(() {
                     colorCode = sampleData[index].colorCode;
                     selectedColor = sampleData[index].button;
                     sampleData.forEach((element) => element.isSelected = false);
                     sampleData[index].isSelected = true;
                      widget.onDesignSelected(colorCode);
                   });

                 },
                 child: _ColorSelectorItem(

                   items: sampleData[index],
                 ),
               );
             },
             itemCount: sampleData.length,

           ),
         )
        ],
      ),
    );
  }




  List<_ColorSelectorItem> colors;

  @override
  void afterFirstLayout(BuildContext context) {
    if (virtualCardState?.virtualCardDesign.isEmpty || virtualCardState?.virtualCardDesign == null) {
  // getDesigns();
    }
  }
  getDesigns()async{
    var result =  await virtualCardState.getCardDesigns(token: loginState.user.token);
    if(result["error"] == false){

    }
  }


}

class _ColorSelectorItem extends StatelessWidget {
  // final Color selectedColor;
  // final Color color;
  // final String colorText;
  final RadioModel items;
 // final VirtualCardDesign virtualCardDesign;
 //  final Function(Color color) onTap;

  const _ColorSelectorItem({
    Key key,
    // this.virtualCardDesign,
    this.items
    // // @required this.selectedColor,
    // @required this.color,
    // @required this.colorText,
    // @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        color: lightBlue,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: borderBlue.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 28,
            width: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: items.button,
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${items.text} ",
                  style: TextStyle(
                    color: blue,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 15),
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            child: Container(
              padding: EdgeInsets.all(5),
              child: Icon(
                Icons.check,
                size: 8,
                color: items.isSelected?  Colors.white : lightBlue,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: items.isSelected?    orange : lightBlue,
                border: Border.all(
                  color:  items.isSelected?   lightBlue : blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class RadioModel {
  bool isSelected;
  final Color button;
  final String text;
  final String colorCode;

  RadioModel({this.isSelected, this.button, this.text, this.colorCode});
}
