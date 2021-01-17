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
  double x1,x2,y1,y2;
  double x = 1,y = 1,z = 1;//缩放

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: yPosition,
      left: xPosition,
      child: Transform(
        child: Listener(
            onPointerMove: (PointerMoveEvent e){

              setState(() {
                if ((down1 != null && down2 == null) || (down1 == null && down2 != null)){//单点时表示移动
                  xPosition += e.delta.dx;//左滑小于0，右滑大于0
                  yPosition += e.delta.dy;//上滑小于0，下滑大于0
                }else if (down1 != null && down2 != null){
                    if (down1.pointer == e.pointer){
                      x1 = e.delta.dx;
                      y1 = e.delta.dy;
                    } else if (down2.pointer == e.pointer){
                      x2 = e.delta.dx;
                      y2 = e.delta.dy;
                    }
                    if (down1.position.dx < down2.position.dx) {//down1在down2的左边
                      if ((x1 < 0 && x2 > 0)){//两个手指在扩张
                        x += 0.01;
                        xPosition -= widget.cutTBean.width*0.01/1.5;
                      } else if (x1 > 0 && x2 < 0){//两个手指在缩小
                        x -= 0.01;
                        xPosition += widget.cutTBean.width*0.01/1.5;
                      } else if ((x1 == 0 && x2 > 0) || (x2 == 0 && x1 < 0)){//down1不动，down2右滑，扩大
                        x += 0.01;
                        xPosition -= widget.cutTBean.width*0.01/1.5;
                      } else if ((x1 == 0 && x2 < 0) || (x2 == 0 && x1 > 0 )) {//down1不动，down2左滑，缩小
                        x -= 0.01;
                        xPosition += widget.cutTBean.width*0.01/1.5;
                      }
                    } else {//down1在down2的右边
                      if ((x1 > 0 && x2 < 0)){//两个手指在扩张
                        x += 0.01;
                        xPosition -= widget.cutTBean.width*0.01/1.5;
                      } else if (x1 < 0 && x2 > 0){//两个手指在缩小
                        x -= 0.01;
                        xPosition += widget.cutTBean.width*0.01/1.5;
                      } else if ((x1 == 0 && x2 < 0) || (x2 == 0 && x1 > 0)){//down1不动，down2右滑，扩大
                        x += 0.01;
                        xPosition -= widget.cutTBean.width*0.01/1.5;
                      } else if ((x1 == 0 && x2 > 0) || (x2 == 0 && x1 < 0 )) {//down1不动，down2左滑，缩小
                        x -= 0.01;
                        xPosition += widget.cutTBean.width*0.01/1.5;
                      }
                    }

                    if (down1.position.dy < down2.position.dy) {//down1在down2的上边
                      if ((y1 < 0 && y2 > 0)){//两个手指在扩张
                        y += 0.01;
                        yPosition -= widget.cutTBean.height*0.01/1.5;
                      } else if (y1 > 0 && y2 < 0){//两个手指在缩小
                        y -= 0.01;
                        yPosition += widget.cutTBean.height*0.01/1.5;
                      } else if ((y1 == 0 && y2 > 0) || (y2 == 0 && y1 < 0)) {//扩张
                        y += 0.01;
                        yPosition -= widget.cutTBean.height*0.01/1.5;
                      } else if ((y1 == 0 && y2 < 0) || (y2 == 0 && y1 > 0)){//缩小
                        y -= 0.01;
                        yPosition += widget.cutTBean.height*0.01/1.5;
                      }
                    } else {//down1在down2的下边
                      if ((y1 > 0 && y2 < 0)){//两个手指在扩张
                        y += 0.01;
                        yPosition -= widget.cutTBean.height*0.01/1.5;
                      } else if (y1 < 0 && y2 > 0){//两个手指在缩小
                        y -= 0.01;
                        yPosition += widget.cutTBean.height*0.01/1.5;
                      } else if ((y1 == 0 && y2 < 0) || (y2 == 0 && y1 > 0)) {//扩张
                        y += 0.01;
                        yPosition -= widget.cutTBean.height*0.01/1.5;
                      } else if ((y1 == 0 && y2 > 0) || (y2 == 0 && y1 < 0)){//缩小
                        y -= 0.01;
                        yPosition += widget.cutTBean.height*0.01/1.5;
                      }
                    }

                }

              });
              //pointer是唯一的，当只有一个pointerDownEvent的时候，可以滑动。有两个之后，则不能滑动。
              //判断两个Pointer是横向分开/缩小，还是纵向分开/缩小 来进行横纵缩放
              print("move-pointer:"+e.pointer.toString()+" dx:"+e.delta.dy.toString());

            },
            onPointerDown: (PointerDownEvent e){
              if (down1 == null){
                down1 = e;
                print("down-pointer:"+e.position.dy.toString());
              } else if (down2 == null){
                down2 = e;
              }
          },
            onPointerUp: (PointerUpEvent e){
              if (down1 != null && e.pointer == down1.pointer){
                down1 = null;
                x1 = 0;
                y1 = 0;
              }
              if (down2 != null && e.pointer == down2.pointer){
                down2 = null;
                x2 = 0;
                y2 = 0;
              }
            },
            child: ClipPath(
              child: SizedBox.fromSize(child: Image.file(widget.cutTBean.file),size: Size(widget.cutTBean.width,widget.cutTBean.height),),
              clipper: _PathClipper(widget.cutTBean.paths),
            )
        ),
        transform: Matrix4.identity()..scale(x,y,z),
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