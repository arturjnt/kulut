import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'capitalize.dart';

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
  // Form
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Static class
  List<Category> _categories = Categories().categories;

  // Initialized variables
  final _descriptionController = TextEditingController();
  final _costController = TextEditingController();
  SPLIT _pickedSPLIT = SPLIT.EQUALLY;
  DateTime _selectedDate = DateTime.now();
  int _pickedCategoryId = 1;

  // Null / not initialized variables
  String _shareWithWhomId;
  List<Map> people;

  // Init State Variables
  Expense e;
  MODE _mode;
  String _modeToPrint;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      e = ModalRoute.of(context).settings.arguments;

      _mode = (e == null) ? MODE.ADD : MODE.EDIT;
      _modeToPrint = _mode.toString().substring(5).toLowerCase();

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
    });
    super.initState();
  }

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

    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // People picker
            FutureBuilder(
              future: (people == null) ? _authProvider.getUsersToShare() : null,
              builder: (ctx, authSnap) {
                if (authSnap.connectionState == ConnectionState.waiting) {
                  return DropdownButton(
                      value: '1',
                      items: ['']
                          .map<DropdownMenuItem<String>>((_) =>
                              DropdownMenuItem(
                                  value: '1', child: Text('Loading people...')))
                          .toList());
                }

                if (people == null) {
                  people = authSnap.data;
                }

                // Set default as first of the list
                _shareWithWhomId = people[0]['id'];

                return DropdownButton<String>(
                  value: _shareWithWhomId,
                  onChanged: (String newValue) {
                    setState(() {
                      _shareWithWhomId = newValue;
                    });
                  },
                  items: people.map<DropdownMenuItem<String>>((Map _user) {
                    return DropdownMenuItem<String>(
                      value: _user['id'],
                      child: Row(
                        children: [
                          Image.network(_user['pic'], height: 20),
                          Text(_user['name']),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            //Category picker
            DropdownButton<int>(
              value: _pickedCategoryId,
              onChanged: (int newValue) {
                setState(() {
                  _pickedCategoryId = newValue;
                });
              },
              items: _categories.map<DropdownMenuItem<int>>((Category _cat) {
                return DropdownMenuItem<int>(
                  value: _cat.id,
                  child: Row(
                    children: [
                      Icon(_cat.icon, color: _cat.color),
                      Text(_cat.name),
                    ],
                  ),
                );
              }).toList(),
            ),
            // Description
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              controller: _descriptionController,
              validator: (value) {
                return (value.isEmpty) ? 'Please enter some text' : null;
              },
            ),
            //Cost
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Cost', suffixIcon: Icon(Icons.euro)),
              controller: _costController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid decimal number';
                }
                return null;
              },
            ),
            // Split
            DropdownButton<SPLIT>(
              value: _pickedSPLIT,
              onChanged: (SPLIT newValue) {
                setState(() {
                  _pickedSPLIT = newValue;
                });
              },
              items: SPLIT.values.map<DropdownMenuItem<SPLIT>>((SPLIT _split) {
                return DropdownMenuItem<SPLIT>(
                    value: _split, child: Text(_split.toString()));
              }).toList(),
            ),
            // Date
            TextButton(
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(Duration(days: 365)),
                  lastDate: DateTime.now(),
                ).then((_date) {
                  setState(() {
                    if (_date == null) {
                      _date = _selectedDate = DateTime.now();
                    }
                    _selectedDate = _date;
                  });
                });
              },
              child: Text('pick date : ' + _selectedDate.toString()),
            ),
            // Submit form
            InkWell(
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    Expense _expenseToSubmit = Expense(
                        description: _descriptionController.text,
                        cost: double.parse(_costController.text),
                        when: _selectedDate,
                        paidByPersonId: _authProvider.id,
                        splitWithPersonId: _shareWithWhomId,
                        categoryId: _pickedCategoryId,
                        split: _pickedSPLIT);

                    switch (_mode) {
                      case MODE.ADD:
                        {
                          await _expenseProvider.saveExpense(_expenseToSubmit);
                          break;
                        }
                      case MODE.EDIT:
                        {
                          _expenseToSubmit.id = e.id;
                          await _expenseProvider.editExpense(_expenseToSubmit);
                          break;
                        }
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Expense ${_modeToPrint}ed!')),
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: Text('${_modeToPrint.toString().capitalize()}'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
