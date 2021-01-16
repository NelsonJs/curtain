import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:curtain/bean/cut-transform.dart';
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
  int clickTime;
  int target = -1;
  ClipPath clipWidget;
  Widget galleryWidget;
  CutTBean ctb;

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageGallery = File(pickedFile.path);
        galleryWidget = Image.file(_imageGallery);
        List<Offset> paths = [];
        ctb = CutTBean(_imageGallery, paths, 0, 0);
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

              setState(() {
                clipWidget = ClipPath(
                  child: galleryWidget,
                  clipper: _PathClipper(ctb),
                );
               Future.delayed(Duration(milliseconds: 100),(){
                 print("点击保存"+ctb.width.toString());
                 Navigator.pop(context,CutTBean(_imageGallery, ctb.paths,ctb.width,ctb.height));
               });
              });

            },
          ),
         _imageGallery == null
              ? Text('No image selected.')
              :
          clipWidget == null ? CustomPaint(
            child: RepaintBoundary(
              child: Listener(
                child: galleryWidget,
                onPointerDown: (PointerDownEvent event){
                  clickTime = DateTime.now().millisecondsSinceEpoch;
                  for (int i = 0; i < ctb.paths.length; i++){
                    if ((event.localPosition.dx <= ctb.paths[i].dx + 20 && event.localPosition.dx >= ctb.paths[i].dx - 20) &&
                        (event.localPosition.dy <= ctb.paths[i].dy + 20 && event.localPosition.dy >= ctb.paths[i].dy - 20) ){//表示按住了某个已经存在的点
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
                        ctb.paths.add(event.localPosition);
                      });
                    }
                  }
                  target = -1;
                  clickTime = uptime;
                },
                onPointerMove: (PointerMoveEvent event){
                  if (target != -1) {
                    setState(() {
                      ctb.paths[target] = event.localPosition;
                    });
                  }
                },
              ),
            ),
            foregroundPainter: MyPainter(ctb.paths),
          ) : clipWidget
        ],
      ),
    );
  }

  /*Future<Shader> _loadShader() async {
    final completer = Completer<ImageInfo>();
    ImageConfiguration imageConfiguration = ImageConfiguration();
    FileImage(_imageGallery).resolve(imageConfiguration).addListener(ImageStreamListener((info, _) => completer.complete(info)));
    final info = await completer.future;
    return ImageShader(info.image, TileMode.clamp, TileMode.clamp,   Float64List.fromList(Matrix4.identity().storage));
  }

  startCut(){
    Paint paint = Paint();
    var path = Path();
    double minW = 0,minH = 0,maxW = 0,maxH = 0;
    for (int i = 0; i < paths.length; i++){
      if (minW > paths[i].dx){
        minW = paths[i].dx;
      } else {
        maxW = paths[i].dx;
      }
      if (minH > paths[i].dy){
        minH = paths[i].dy;
      } else {
        maxH = paths[i].dy;
      }

      if (i == 0) {
        print(paths[i].dx);
        print(paths[i].dy);
        path.moveTo(paths[i].dx, paths[i].dy);
      } else if (i < paths.length) {
        path.lineTo(paths[i].dx, paths[i].dy);
      }
    }
    path.close();
    _loadShader().then((value){
      paint.shader = value;
      PictureRecorder recorder =  PictureRecorder();
      var c = Canvas(recorder);
      c.drawPath(path, paint);
      print("宽度");
      print((maxW-minW).ceil());
      recorder.endRecording().toImage((maxW-minW).ceil(), (maxH - minH).ceil()).then((value){
        // Navigator.pop(context,value);
        setState(() {

        });
      });
    });
  }*/

}

class TestPainter extends CustomPainter {
  var img;
  TestPainter(clipImage){
    img = clipImage;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(img, Offset(0, 0), Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}

class _PathClipper extends CustomClipper<Path> {
  List<Offset> paths;
  CutTBean ctb;
  _PathClipper(CutTBean ctb){
    this.paths = ctb.paths;
    this.ctb = ctb;
  }

  @override
  Path getClip(Size size) {
    var path = Path();
    ctb.width = size.width;
    ctb.height = size.height;
    print("size大小:"+size.width.toString()+"--"+size.height.toString());
    for (int i = 0; i < paths.length; i++){
      if (i == 0) {
        path.moveTo(paths[i].dx, paths[i].dy);
      } else if (i < paths.length) {
        path.lineTo(paths[i].dx, paths[i].dy);
      }
    }
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}