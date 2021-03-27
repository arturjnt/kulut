import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../screens/loading/main.dart';
import '../../providers/expense.dart';

class EVListScreen extends StatelessWidget {
  static const routeName = '/ev-list';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.pie_chart),
            tooltip: 'Go to Graphs',
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/ev-graph');
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<Expense>(context).getAllExpensesFull(),
        builder: (ctx, expenseSnap) {
          if (expenseSnap.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          }
          List<Expense> expenses = expenseSnap.data ?? [];
          return ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (ctx, i) {
              Expense e = expenses[i];

              return Card(
                child: ListTile(
                  leading: Icon(
                    e.category.icon,
                    color: e.category.color,
                  ),
                  title: Text(
                      e.description + ' | settled: ' + e.settled.toString()),
                  subtitle: Text(_getSubtitle(e)),
                  trailing: Text(DateFormat('HH:mm dd/MM/yyyy').format(e.when)),
                  isThreeLine: true,
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
