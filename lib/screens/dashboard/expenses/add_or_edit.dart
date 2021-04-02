import 'package:flutter/material.dart';

class AddOrEditScreen extends StatefulWidget {
  static const routeName = '/add-or-edit';

  @override
  _AddOrEditScreenState createState() => _AddOrEditScreenState();
}

class _AddOrEditScreenState extends State<AddOrEditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text('add or edit expense'),
    );
  }
}
