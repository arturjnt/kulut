import 'package:flutter/material.dart';

class EVListScreen extends StatefulWidget {
  static const routeName = '/ev-list';

  @override
  _EVListScreenState createState() => _EVListScreenState();
}

class _EVListScreenState extends State<EVListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text('list'),
    );
  }
}
