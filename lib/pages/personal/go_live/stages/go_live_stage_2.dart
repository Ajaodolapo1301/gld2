import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:glade_v2/pages/personal/go_live/go_live_personal_page.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';

import '../../../../main.dart';

class GoLivePersonalStage2 extends StatefulWidget {
  Function(dynamic)onSelfieSnapped;
  GoLivePersonalStage2({this.onSelfieSnapped});
  @override
  _GoLivePersonalStage2State createState() => _GoLivePersonalStage2State();
}

class _GoLivePersonalStage2State extends State<GoLivePersonalStage2> {

  CameraController controller;
 // FileClass
 var myimage;
 // = FileClass();
  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[1], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: lightBlue,
                border: Border.all(
                  color: borderBlue.withOpacity(0.2),
                ),
                borderRadius: BorderRadius.circular(10),

              ),
              child: myimage == null  ?  Square(cameraController: controller,) : DisplayPictureScreen(imagePath: myimage?.path,)
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Please position your head to fit into the \nframe and click snap.",
            textAlign: TextAlign.center,
            style: TextStyle(color: blue, fontSize: 14),
          ),
          SizedBox(height: 30),
          InkWell(
            onTap: () async{
              setState(() {
                myimage = null;
              });

          final  image = await controller.takePicture();

              setState(() {
                myimage = image ;
              });
              print(myimage);
              widget.onSelfieSnapped(myimage);
            },
            child: Container(
              height: 65,
              width: 65,
              padding: EdgeInsets.all(4),
              child: Container(
                decoration: BoxDecoration(
                  color: blue,
                  shape: BoxShape.circle,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: blue,
                  width: 2,
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}



class Square extends StatefulWidget {
  final color;
  final size;
  final CameraController cameraController;

  Square({this.color, this.size, this.cameraController});

  @override
  _SquareState createState() => _SquareState();
}

class _SquareState extends State<Square> {




  @override
  Widget build(BuildContext context) {
    if (!widget.cameraController.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
        aspectRatio: widget.cameraController.value.aspectRatio,
        child: CameraPreview(widget.cameraController));
  }
}


class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        decoration: BoxDecoration(
          color: lightBlue,
          border: Border.all(
            color: borderBlue.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(10),

        ),
        child: Transform(
          alignment: Alignment.center,
          child:   Image.file(File(imagePath)),
           transform: Matrix4.rotationY(pi),
        )




      ),
    );
  }
}