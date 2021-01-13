import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Cut extends StatefulWidget {
  @override
  _StateCut createState() => _StateCut();
}

class _StateCut extends State<Cut> {
  File _imageGallery;
  final picker = ImagePicker();
  List<Offset> paths = [];
  int clickTime;
  int target = -1;
  Widget clipWidget;

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageGallery = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getImageFromGallery();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GestureDetector(
            child: Container(
              child: Text('保存'),
              margin: EdgeInsets.only(top: 50,bottom: 20),
            ),
            onTap: (){
              print("点击保存");
              setState(() {
                clipWidget = ClipPath(
                  child: Center(
                    child: Image.file(_imageGallery),
                  ),
                  clipper: _PathClipper(paths),
                );
              });
            },
          ),
          Center(
            child: _imageGallery == null
                ? Text('No image selected.')
                :
            clipWidget == null ? CustomPaint(
              child: RepaintBoundary(
                child: Listener(
                  child: Image.file(_imageGallery),
                  onPointerDown: (PointerDownEvent event){
                    clickTime = DateTime.now().millisecondsSinceEpoch;
                    for (int i = 0; i < paths.length; i++){
                      if ((event.localPosition.dx <= paths[i].dx + 20 && event.localPosition.dx >= paths[i].dx - 20) &&
                          (event.localPosition.dy <= paths[i].dy + 20 && event.localPosition.dy >= paths[i].dy - 20) ){//表示按住了某个已经存在的点
                        target = i;
                        break;
                      }
                    }
                  },
                  onPointerUp: (PointerUpEvent event){
                    int uptime = DateTime.now().millisecondsSinceEpoch;
                    if (uptime - clickTime <= 500){//表示点击
                      print(event.localPosition);
                      if (target == -1){//只有没有点击已存在的点的时候才加入
                        setState(() {
                          paths.add(event.localPosition);
                        });
                      }
                    }
                    target = -1;
                    clickTime = uptime;
                  },
                  onPointerMove: (PointerMoveEvent event){
                    if (target != -1) {
                      setState(() {
                        paths[target] = event.localPosition;
                      });
                    }
                  },
                ),
              ),
              foregroundPainter: MyPainter(paths),
            ) : clipWidget
          )
        ],
      ),
    );
  }

  start(){

  }

}

class _PathClipper extends CustomClipper<Path> {
  List<Offset> paths;
  _PathClipper(List<Offset> paths){
    this.paths = paths;
  }

  @override
  Path getClip(Size size) {
    var path = Path();
    print(size.width);
    for (int i = 0; i < paths.length; i++){
      if (i == 0) {
        print(paths[i].dx);
        print(paths[i].dy);
        path.moveTo(paths[i].dx, paths[i].dy);
      } else if (i < paths.length) {
        path.lineTo(paths[i].dx, paths[i].dy);
      }
    }
    /*path.moveTo(235.7, 52.3);
    path.lineTo(324.0, 58.3);
    path.lineTo(321.0, 305.3);
    path.lineTo(234.3, 305.3);*/
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }

}

class MyPainter extends CustomPainter {
  List<Offset> paths;
  MyPainter(List<Offset> paths){
    this.paths = paths;
  }



  @override
  void paint(Canvas canvas, Size size) {
    if (paths.length == 0)return;
    var paint = Paint()..color=Color(0x77d83419)..style=PaintingStyle.fill..strokeWidth=10;
    for (int i = 0; i < paths.length; i++){
      canvas.drawCircle(paths[i], 15, paint);
      if (i < paths.length-1){
        canvas.drawLine(paths[i],paths[i+1], paint);
      }
    }

    print("paint");
    print(paths.length);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}