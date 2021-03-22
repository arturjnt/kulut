import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth.dart';
import '../../../providers/categories.dart';
import '../../../providers/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Category> _categories = Categories().categories;
  Category _pickedCategory;
  String _pickedSPLIT = SPLIT.EQUALLY.toString();
  DateTime _selectedDate = DateTime.now();
  String _shareWithWhomId;

  final _descriptionController = TextEditingController();
  final _costController = TextEditingController();

  @override
  void initState() {
    // _categories can't be accessed in the initializer
    _pickedCategory = _categories[0];
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

    return Form(
      key: _formKey,
      child: Column(
        children: [
          FutureBuilder(
            future: _authProvider.getUsersToShare(),
            builder: (ctx, authSnap) {
              if (authSnap.connectionState == ConnectionState.waiting) {
                return DropdownButton(
                    value: '1',
                    items: ['']
                        .map<DropdownMenuItem<String>>((_) => DropdownMenuItem(
                            value: '1', child: Text('Loading people...')))
                        .toList());
              }

              // Set default as first of the list
              _shareWithWhomId = authSnap.data[0]['id'];

              return DropdownButton<String>(
                value: _shareWithWhomId,
                onChanged: (String newValue) {
                  setState(() {
                    _shareWithWhomId = newValue;
                  });
                },
                items: authSnap.data.map<DropdownMenuItem<String>>((Map _user) {
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
          DropdownButton<Category>(
            value: _pickedCategory,
            onChanged: (Category newValue) {
              setState(() {
                _pickedCategory = newValue;
              });
            },
            items: _categories.map<DropdownMenuItem<Category>>((Category _cat) {
              return DropdownMenuItem<Category>(
                value: _cat,
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
          DropdownButton<String>(
            value: _pickedSPLIT,
            onChanged: (String newValue) {
              setState(() {
                _pickedSPLIT = newValue;
              });
            },
            items: SPLIT.values.map<DropdownMenuItem<String>>((SPLIT _split) {
              return DropdownMenuItem<String>(
                  value: _split.toString(), child: Text(_split.toString()));
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
                  // TODO: missing changing the SPLIT type enum based on _pickedSPLIT
                  Expense _expenseToSubmit = Expense(
                      description: _descriptionController.text,
                      cost: double.parse(_costController.text),
                      when: _selectedDate,
                      paidByPersonId: _authProvider.id,
                      splitWithPersonId: _shareWithWhomId,
                      category: _pickedCategory);

                  _expenseProvider.saveExpense(_expenseToSubmit);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Expense Saved!')),
                  );

                  // Clear form
                  setState(() {
                    _descriptionController.clear();
                    _costController.clear();
                    _selectedDate = DateTime.now();
                    _pickedSPLIT = SPLIT.EQUALLY.toString();
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
