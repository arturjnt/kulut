import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth.dart';
import '../../../providers/categories.dart';
import '../../../providers/expense.dart';

import 'settle_up.dart';

class AddExpenseScreen extends StatefulWidget {
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Category> _categories = Categories().categories;
  int _pickedCategoryId;
  SPLIT _pickedSPLIT = SPLIT.EQUALLY;
  DateTime _selectedDate = DateTime.now();
  String _shareWithWhomId;

  final _descriptionController = TextEditingController();
  final _costController = TextEditingController();

  var people;

  @override
  void initState() {
    // _categories can't be accessed in the initializer
    _pickedCategoryId = _categories[0].id;
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
    final _authProvider = Provider.of<Auth>(context, listen: false);
    final _expenseProvider = Provider.of<Expense>(context, listen: false);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                future: _authProvider.getMyBalance(),
                builder: (ctx, _balanceSnap) =>
                    (_balanceSnap.connectionState == ConnectionState.waiting)
                        ? Text('Recalculating balance...')
                        : Text(_balanceSnap.data.toStringAsFixed(2)),
              ),
              IconButton(
                icon: Icon(Icons.atm_outlined),
                tooltip: 'Settle',
                onPressed: () {
                  SettleUp.show(context).then((_) {
                    setState(() {
                      _authProvider.getMyBalance();
                    });
                  });
                },
              ),
            ],
          ),
          FutureBuilder(
            future: (people == null) ? _authProvider.getUsersToShare() : null,
            builder: (ctx, authSnap) {
              if (authSnap.connectionState == ConnectionState.waiting) {
                return DropdownButton(
                    value: '1',
                    items: ['']
                        .map<DropdownMenuItem<String>>((_) => DropdownMenuItem(
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
          TextFormField(
            decoration: InputDecoration(labelText: 'Description'),
            controller: _descriptionController,
            validator: (value) {
              return (value.isEmpty) ? 'Please enter some text' : null;
            },
          ),
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
          TextButton(
            onPressed: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now().subtract(Duration(days: 365)),
                lastDate: DateTime.now(),
              ).then((_date) {
                if (_date == null) {}
                setState(() {
                  _selectedDate = _date;
                });
              });
            },
            child: Text('pick date : ' + _selectedDate.toString()),
          ),
          InkWell(
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Expense _expenseToSubmit = Expense(
                      description: _descriptionController.text,
                      cost: double.parse(_costController.text),
                      when: _selectedDate,
                      paidByPersonId: _authProvider.id,
                      splitWithPersonId: _shareWithWhomId,
                      categoryId: _pickedCategoryId,
                      split: _pickedSPLIT);

                  _expenseProvider.saveExpense(_expenseToSubmit);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Expense Saved!')),
                  );

                  // Clear form
                  setState(() {
                    _descriptionController.clear();
                    _costController.clear();
                    _selectedDate = DateTime.now();
                    _pickedSPLIT = SPLIT.EQUALLY;
                  });
                }
              },
              child: Text('Submit'),
            ),
          )
        ],
      ),
    );
  }
}
