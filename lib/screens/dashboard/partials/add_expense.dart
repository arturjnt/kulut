import 'package:flutter/material.dart';

import '../../../providers/categories.dart';
import '../../../providers/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Category> categories = Categories().categories;
  String _pickedCategoryId = '1';
  String _pickedSPLIT = SPLIT.EQUALLY.toString();
  DateTime _selectedDate = DateTime.now();

  final _descriptionController = TextEditingController();
  final _costController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _descriptionController.dispose();
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // TODO: missing with whom to split it
          // TODO: missing when was it (default now)
          DropdownButton<String>(
            value: _pickedCategoryId,
            icon: const Icon(Icons.chevron_right),
            onChanged: (String newValue) {
              setState(() {
                _pickedCategoryId = newValue;
              });
            },
            items: categories.map<DropdownMenuItem<String>>((Category _cat) {
              return DropdownMenuItem<String>(
                value: _cat.id.toString(),
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
            icon: const Icon(Icons.chevron_right),
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
                if(_date == null){}
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
                  // TODO: submit form
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                    _pickedCategoryId +
                        ' - ' +
                        _descriptionController.text +
                        ' - ' +
                        _costController.text +
                        ' - ' +
                        _pickedSPLIT +
                        ' - ' +
                        _selectedDate.toString(),
                  )));
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
