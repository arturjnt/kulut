import 'package:flutter/material.dart';

import '../../../providers/expense.dart';

class AddOrEditScreen extends StatefulWidget {
  static const routeName = '/add-or-edit';

  @override
  _AddOrEditScreenState createState() => _AddOrEditScreenState();
}

enum MODE { ADD, EDIT }

class _AddOrEditScreenState extends State<AddOrEditScreen> {
  @override
  Widget build(BuildContext context) {
    final Expense e = ModalRoute.of(context).settings.arguments;

    MODE _mode = (e == null) ? MODE.ADD : MODE.EDIT;

    return Scaffold(
      appBar: AppBar(),
      body: Text('add or edit expense $_mode'),
    );
  }
}
