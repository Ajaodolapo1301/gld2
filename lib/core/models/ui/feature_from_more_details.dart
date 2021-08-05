import 'package:flutter/cupertino.dart';

class FeatureFromMoreDetails{
  final String imagePath;
  final String mainText;
  final String subText;
  final Function(BuildContext context) onTap;

  FeatureFromMoreDetails({this.onTap, this.imagePath, this.mainText, this.subText});
}