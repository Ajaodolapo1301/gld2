import 'package:flutter/material.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';

class HomeCard extends StatelessWidget {
  final String imagePath;
  final String mainText;
  final String subText;
  final Color color;
  final VoidCallback onTap;
  const HomeCard({
    Key key, this.imagePath, this.mainText, this.subText, this.color, this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 215,
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath),
            SizedBox(height: 10),
            Text(
              mainText,
              style: TextStyle(
                color: blue,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 5),
            Text(
              subText,
              style: TextStyle(
                color: blue,
                fontSize: 12,
              ),
            )
          ],
        ),
      ),
    );
  }
}
