import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Mine extends StatefulWidget {
  @override
  _StateMine createState() => _StateMine();
}

class _StateMine extends State<Mine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的"),
      ),
    );
  }

}