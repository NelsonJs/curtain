import 'dart:io';

import 'package:curtain/home/cut.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Design extends StatefulWidget {
  @override
  _StateDesign createState() => _StateDesign();
}
class _StateDesign extends State<Design> {
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }



  @override
  void initState() {
    super.initState();
    getImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Column(
        children: [
          Container(
            child: GestureDetector(
              child: Text('保存'),
            ),
            margin: EdgeInsets.only(top: 30,bottom: 10),
          ),
          _image == null
              ? Text('No image selected.')
              :
          Listener(
            child: CustomPaint(
              child: RepaintBoundary(child: Image.file(_image)),
              foregroundPainter: drawCutImg(),
            ),
          ),
          GestureDetector(
            child: Icon(Icons.image,size: 50),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Cut()));
            },
          )
        ],
      ),
    );
  }

  dot(){

  }

}

class drawCutImg extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}