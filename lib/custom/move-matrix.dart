import 'package:flutter/material.dart';

class MoveMatrixWidget extends StatefulWidget {
  Widget item;


  @override
  State<StatefulWidget> createState() {
    return _MoveMatrixWidgetState();
  }

  MoveMatrixWidget(this.item);
}
class _MoveMatrixWidgetState extends State<MoveMatrixWidget> {
  double xPosition = 0;
  double yPosition = 0;


  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: yPosition,
      left: xPosition,

      child: GestureDetector(
        onPanUpdate: (tapInfo) {
          setState(() {
            xPosition += tapInfo.delta.dx;
            yPosition += tapInfo.delta.dy;
          });
        },
        child: widget.item,
      ),
    );
  }
}