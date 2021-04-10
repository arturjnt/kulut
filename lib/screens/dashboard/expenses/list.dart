import 'package:flutter/material.dart';
import 'package:kulut/screens/loading/main.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../providers/expense.dart';
import 'add_or_edit.dart';

class EVListScreen extends StatefulWidget {
  static const routeName = '/ev-list';

  @override
  _EVListScreenState createState() => _EVListScreenState();
}

class _EVListScreenState extends State<EVListScreen> {
  bool _isCombined = false;

  @override
  Widget build(BuildContext context) {
    Expense _expenseProvider = Provider.of<Expense>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense List'),
      ),
      body: FutureBuilder(
        future: _expenseProvider.getAllExpensesFull(_isCombined),
        builder: (ctx, expenseSnap) {
          List<Expense> expenses = expenseSnap.data ?? [];
          return (expenseSnap.connectionState == ConnectionState.waiting)
              ? LoadingScreen()
              : Column(
                  children: [
                    CheckboxListTile(
                        title: Text('Show Combined Expenses',
                            textAlign: TextAlign.right),
                        value: _isCombined,
                        onChanged: (_newState) {
                          setState(() {
                            _isCombined = _newState;
                          });
                        }),
                    Expanded(
                      child: ListView.builder(
                        itemCount: expenses.length,
                        itemBuilder: (ctx, i) {
                          Expense e = expenses[i];

                          return Card(
                            key: Key(expenses[i].id),
                            child: Slidable(
                              actionPane: SlidableScrollActionPane(),
                              secondaryActions: [
                                IconSlideAction(
                                  caption: 'Edit',
                                  color: Colors.yellow,
                                  icon: Icons.edit,
                                  onTap: () {
                                    Navigator.pushNamed(
                                            context, AddOrEditScreen.routeName,
                                            arguments: e)
                                        .whenComplete(() {
                                      setState(() {
                                        // Updated the screen with the edited expense
                                      });
                                    });
                                  },
                                ),
                                IconSlideAction(
                                  caption: 'Delete',
                                  color: Colors.red,
                                  foregroundColor: Colors.black,
                                  icon: Icons.delete,
                                  onTap: () {
                                    e.deleteExpense(e.id);
                                    setState(() {
                                      expenses.removeAt(i);
                                    });
                                  },
                                )
                              ],
                              child: ListTile(
                                leading: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              Theme.of(context).primaryColor),
                                      child: Icon(
                                        e.category.icon,
                                        color: e.category.color,
                                      ),
                                    ),
                                  ],
                                ),
                                title: Row(
                                  children: [
                                    if (!e.settled)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Icon(Icons.cancel_outlined,
                                            size: 20,
                                            color:
                                                Theme.of(context).errorColor),
                                      ),
                                    Text(e.description),
                                  ],
                                ),
                                subtitle:
                                    Text(Expense.getSplitType(e, _isCombined)),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        DateFormat('HH:mm\ndd/MM/yyyy')
                                            .format(e.when),
                                        textAlign: TextAlign.right),
                                  ],
                                ),
                                isThreeLine: true,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
