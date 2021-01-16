

import 'dart:io';

import 'dart:ui';

import 'package:flutter/cupertino.dart';

class CutTBean {
  File file;
  List<Offset> paths;
  double width,height;
  Widget widget;


  //CutTBean(this.widget);

  CutTBean(this.file, this.paths, this.width, this.height);
}