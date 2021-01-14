import 'dart:io';

import 'package:curtain/custom/move-matrix.dart';
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
  List<Widget> items = [];
  Widget clipWidget;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        items.add(Image.file(_image));
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
            child: Text('保存'),
            margin: EdgeInsets.only(top: 30,bottom: 10),
          ),
          _image == null
              ? Text('No image selected.')
              :
          RepaintBoundary(
              child: Stack(
                children: items,
              )
          ),
          GestureDetector(
            child: Icon(Icons.image,size: 50),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Cut())).then((value){
                print("收到返回的数据");
               setState(() {
                 items.add(MoveMatrixWidget(value));
               });
              });
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
  var img;
  Offset cutOffset = Offset(50, 50);
  drawCutImg(cutImage, Offset cutOffset){
    img = cutImage;
    this.cutOffset = cutOffset;
  }



  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 10;
    paint.color = Colors.red;
    print("执行paint");
    if (cutOffset == null){
      cutOffset = Offset(50, 50);
    }
    if (img != null) {
      print("paint非空");
      canvas.drawImage(img, cutOffset, paint);
    }
    //canvas.drawCircle(cutOffset, 22, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}