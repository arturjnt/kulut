import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth.dart';
import '../../../providers/expense.dart';
import '../../../providers/categories.dart';

class AddOrEditScreen extends StatefulWidget {
  static const routeName = '/add-or-edit';

  @override
  _AddOrEditScreenState createState() => _AddOrEditScreenState();
}

enum MODE { ADD, EDIT }

class _AddOrEditScreenState extends State<AddOrEditScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Category> _categories = Categories().categories;

  final _descriptionController = TextEditingController();
  final _costController = TextEditingController();
  SPLIT _pickedSPLIT = SPLIT.EQUALLY;
  DateTime _selectedDate = DateTime.now();
  int _pickedCategoryId = 1;
  String _shareWithWhomId;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _descriptionController.dispose();
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<Auth>(context);
    final _expenseProvider = Provider.of<Expense>(context);

    final Expense e = ModalRoute.of(context).settings.arguments;

    MODE _mode = (e == null) ? MODE.ADD : MODE.EDIT;

    switch (_mode) {
      case MODE.ADD:
        {
          break;
        }
      case MODE.EDIT:
        {
          _descriptionController.text = e.description;
          _costController.text = e.cost.toString();
          _pickedSPLIT = e.split;
          _selectedDate = e.when;
          _pickedCategoryId = e.categoryId;
          _shareWithWhomId = e.splitWithPersonId;
          break;
        }
    }

    return Scaffold(
      appBar: AppBar(),
      body: Text('add or edit expense $_mode'),
    );
  }
}
