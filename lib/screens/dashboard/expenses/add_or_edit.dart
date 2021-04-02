import 'package:flutter/material.dart';

class AddOrEdit extends StatefulWidget {
  static const routeName = '/add-or-edit';

  @override
  _AddOrEditState createState() => _AddOrEditState();
}

class _AddOrEditState extends State<AddOrEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text('add or edit expense'),
    );
  }
}
