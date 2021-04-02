import 'package:flutter/material.dart';

class SettleScreen extends StatefulWidget {
  static const routeName = '/settle';

  @override
  _SettleScreenState createState() => _SettleScreenState();
}

class _SettleScreenState extends State<SettleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),body: Text('settle'),);
  }
}
