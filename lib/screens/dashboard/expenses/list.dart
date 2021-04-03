import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    Expense _expenseProvider = Provider.of<Expense>(context);

    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: _expenseProvider.getAllExpensesFull(),
        builder: (ctx, expenseSnap) {
          List<Expense> expenses = expenseSnap.data ?? [];
          return ListView.builder(
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
                        Navigator.pushNamed(context, AddOrEditScreen.routeName,
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
                              color: Theme.of(context).primaryColor),
                          child: Icon(
                            e.category.icon,
                            color: e.category.color,
                          ),
                        ),
                      ],
                    ),
                    title: Text(
                        e.description + ' | settled: ' + e.settled.toString()),
                    subtitle: Text(_getSubtitle(e)),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(DateFormat('HH:mm\ndd/MM/yyyy').format(e.when),
                            textAlign: TextAlign.right),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _getSubtitle(Expense e) {
    var _sentence = '';
    String _paidBy = e.paidByPerson[e.paidByPersonId];
    String _splitWith = e.splitWithPerson[e.splitWithPersonId];

    switch (e.split) {
      case SPLIT.EQUALLY:
        {
          _sentence =
              '$_paidBy paid half of ${e.cost.toString()}€ with $_splitWith';
          break;
        }
      case SPLIT.ME_TOTAL:
        {
          _sentence = '$_splitWith owes $_paidBy: ${e.cost.toString()}€';
          break;
        }
      case SPLIT.OTHER_TOTAL:
        {
          _sentence = '$_paidBy owes $_splitWith: ${e.cost.toString()}€';
          break;
        }
    }
    return _sentence;
  }
}
