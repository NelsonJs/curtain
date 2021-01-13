import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Market extends StatefulWidget {
  @override
  _StateMarket createState() => _StateMarket();
}

class _StateMarket extends State<Market> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("市场"),
      ),
    );
  }

}