import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'capitalize.dart';

import '../../../providers/auth.dart';
import '../../../providers/expense.dart';
import '../../../providers/categories.dart';

import '../../loading/main.dart';

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
  String _modeToPrint = 'add';

  // Null / not initialized variables
  String _shareWithWhomId;
  List<Map> people;

  // Init State Variables
  Expense e;
  MODE _mode;

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
            setState(() {
              _descriptionController.text = e.description;
              _costController.text = e.cost.toString();
              _pickedSPLIT = e.split;
              _selectedDate = e.when;
              _pickedCategoryId = e.categoryId;
              _shareWithWhomId = e.splitWithPersonId;
            });
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
      appBar: AppBar(
        title: Text('${_modeToPrint.capitalize()} Expense'),
      ),
      body: FutureBuilder(
        future: (people == null) ? _authProvider.getUsersToShare() : null,
        builder: (ctx, authSnap) {
          if (authSnap.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          }

          if (people == null) {
            people = authSnap.data;
          }

          // Set default as first of the list, if not editing
          if (_shareWithWhomId == null) _shareWithWhomId = people[0]['id'];

          // If you don't find the "_shareWithWhomId" in the people list
          // It's because you are that person, and as such...
          // The split type needs to be reversed
          if (people
              .where((person) => person['id'] == _shareWithWhomId)
              .isEmpty) {
            _shareWithWhomId = e.paidByPersonId;
            // Reverse split
            switch (_pickedSPLIT) {
              case SPLIT.EQUALLY:
                _pickedSPLIT = SPLIT.OTHER_EQUALLY;
                break;
              case SPLIT.OTHER_EQUALLY:
                _pickedSPLIT = SPLIT.EQUALLY;
                break;
              case SPLIT.ME_TOTAL:
                _pickedSPLIT = SPLIT.OTHER_TOTAL;
                break;
              case SPLIT.OTHER_TOTAL:
                _pickedSPLIT = SPLIT.ME_TOTAL;
                break;
              default:
            }
          }

          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // TODO: Move the children out of the function
                  // TODO: to make it more readable
                  // People picker
                  if (_pickedSPLIT != SPLIT.NO_SPLIT)
                    DropdownButton<String>(
                      isExpanded: true,
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
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(_user['name']),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  //Category picker
                  DropdownButton<int>(
                    isExpanded: true,
                    value: _pickedCategoryId,
                    onChanged: (int newValue) {
                      setState(() {
                        _pickedCategoryId = newValue;
                      });
                    },
                    items:
                        _categories.map<DropdownMenuItem<int>>((Category _cat) {
                      return DropdownMenuItem<int>(
                        value: _cat.id,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(_cat.icon, color: _cat.color),
                            ),
                            Text(_cat.name),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  // Description
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Description'),
                    controller: _descriptionController,
                    validator: (value) {
                      return (value.isEmpty) ? 'Please enter some text' : null;
                    },
                  ),
                  //Cost
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Cost', suffixIcon: const Icon(Icons.euro)),
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
                    isExpanded: true,
                    value: _pickedSPLIT,
                    onChanged: (SPLIT newValue) {
                      setState(() {
                        _pickedSPLIT = newValue;
                      });
                    },
                    items: SPLIT.values
                        .map<DropdownMenuItem<SPLIT>>((SPLIT _split) {
                      return DropdownMenuItem<SPLIT>(
                        value: _split,
                        child: Text(
                          Expense.getSplitTypeOptions(_split).capitalize(),
                        ),
                      );
                    }).toList(),
                  ),
                  // Date
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    child: TextButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ),
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate:
                              DateTime.now().subtract(Duration(days: 365)),
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
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Pick date\n'
                              'Currently selected: '
                              '${DateFormat('dd/MM/yyyy HH:mm').format(_selectedDate)}',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // TODO: Move the submit form out of the function
                  // TODO: to make it more readable
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
                                await _expenseProvider
                                    .saveExpense(_expenseToSubmit);
                                break;
                              }
                            case MODE.EDIT:
                              {
                                _expenseToSubmit.id = e.id;
                                _expenseToSubmit.settled = e.settled;
                                await _expenseProvider
                                    .editExpense(_expenseToSubmit);
                                break;
                              }
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Expense ${_modeToPrint}ed!')),
                          );
                          Navigator.of(context).pop();
                        }
                      },
                      child: Container(
                        height: 50,
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              '${_modeToPrint.toString().capitalize()}',
                              textAlign: TextAlign.center,
                            )),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
