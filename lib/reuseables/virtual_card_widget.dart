




import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/VirtualCardModel.dart';

class VirtualCardWidget extends StatelessWidget {
  final VirtualCardModel virtualCardModel;
  final colorCode;
  VirtualCardWidget({this.virtualCardModel, this.colorCode});
  @override
  Widget build(BuildContext context) {
    return  FlipCard(
      speed: 700,
      front: AnimatedContainer(
        height: 200,
        margin: EdgeInsets.symmetric(horizontal: 20),
        duration: Duration(milliseconds: 500),
        decoration: BoxDecoration(
          color: colorCode!= null   ? Color(int.parse("0xff$colorCode")) : Colors.black,
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
                "VIRTUAL ${virtualCardModel.currency} CARD",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11),
              ),
            ),
            // Positioned(
            //   bottom: 20,
            //   left: 20,
            //   child: Text(
            //    virtualCardModel.card_title.toUpperCase() ?? "",
            //     style: TextStyle(
            //         color: Colors.white,
            //         fontWeight: FontWeight.bold,
            //         fontSize: 11),
            //   ),
            // ),
            Positioned(
              bottom: 20,
              right: 20,
              child: Text(
                virtualCardModel.card_type.toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11),
              ),
            )
          ],
        ),
      ),
      back:AnimatedContainer(

        height: 200,
        margin: EdgeInsets.symmetric(horizontal: 20, ),
        duration: Duration(milliseconds: 500),
        decoration: BoxDecoration(
          color: colorCode!= null   ? Color(int.parse("0xff$colorCode")) : Colors.black,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Container(

              margin: const EdgeInsets.only(top: 16, ),
              height: 48,
              width: double.infinity,
              color: Colors.grey,
              child: Center(child: Text(virtualCardModel?.card_pan, style: TextStyle(color: Colors.white, fontSize: 20),)),
            ),
            Spacer(),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(

                    margin: const EdgeInsets.only(top: 16),
                    height: 30,
                    width: double.infinity,
                    color: colorCode!= null   ? Color(int.parse("0xff$colorCode")) : Colors.black,
                    child: Center(child: Text("", style: TextStyle(color: Colors.white),)),
                  ),
                ),
                SizedBox(width: 10,),
                Text(  "Cvv: ${virtualCardModel?.cvv}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),          SizedBox(width: 10,),

              ],
            ),
            SizedBox(height: 10,)


          ],
        ),
      ),
    );
  }
}