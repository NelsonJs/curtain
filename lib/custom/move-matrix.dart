import 'package:curtain/bean/cut-transform.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class MoveMatrixWidget extends StatefulWidget {
  Widget item;
  CutTBean cutTBean;

  @override
  State<StatefulWidget> createState() {
    return _MoveMatrixWidgetState();
  }

  MoveMatrixWidget(this.cutTBean);
}
class _MoveMatrixWidgetState extends State<MoveMatrixWidget> {
  double xPosition = 0;
  double yPosition = 0;
  double w,h;

  getWH(){
    double minW = 0,minH = 0,maxW = 0,maxH = 0;
    var paths = widget.cutTBean.paths;
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
    }
    w = maxW - minW;
    h = maxH - minH;
    //print("minW:"+minW.toString()+" maxW:"+maxW.toString()+" minH:"+minH.toString()+" maxH:"+maxH.toString());
  }
  @override
  void initState() {
    w = widget.cutTBean.width;
    h = widget.cutTBean.height;
    print("宽高："+w.toString()+" "+h.toString());
    super.initState();
  }

  PointerDownEvent down1,down2;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: yPosition,
      left: xPosition,
      child: Transform(
        child: Listener(
            onPointerMove: (PointerMoveEvent e){

              setState(() {
                xPosition += e.delta.dx;
                yPosition += e.delta.dy;
              });
              //pointer是唯一的，当只有一个pointerDownEvent的时候，可以滑动。有两个之后，则不能滑动。
              //判断两个Pointer是横向分开/缩小，还是纵向分开/缩小 来进行横纵缩放
              print("move-pointer:"+e.pointer.toString());

            },
            onPointerDown: (PointerDownEvent e){
              if (down1 == null){
                down1 = e;
                print("down-pointer:"+e.pointer.toString());
              } else if (down2 == null){
                down2 = e;
              }
          },
            child: ClipPath(
              child: SizedBox.fromSize(child: Image.file(widget.cutTBean.file),size: Size(widget.cutTBean.width,widget.cutTBean.height),),
              clipper: _PathClipper(widget.cutTBean.paths),
            )
        ),
        transform: Matrix4.identity()..scale(1.5),
      )
    );
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