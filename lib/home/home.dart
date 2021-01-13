import 'package:curtain/home/design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _StateHome createState() => _StateHome();
}

class _StateHome extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("首页",style: TextStyle(fontSize: 18),),
        elevation: 0.5,
      ),
      body: Center(
        child: GestureDetector(
          child: Text("设计",style: TextStyle(fontSize: 30)),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Design()));
          },
        ),
      ),
    );
  }

}