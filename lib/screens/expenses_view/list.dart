import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../screens/loading/main.dart';
import '../../providers/expense.dart';
import '../../providers/categories.dart';

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
        future: Provider.of<Expense>(context).getAllExpenses(),
        builder: (ctx, expenseSnap) {
          if (expenseSnap.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          }
          List<Expense> expenses = expenseSnap.data ?? [];
          return ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (ctx, i) {
              Expense e = expenses[i];
              Category c = Categories().getCategoryById(e.categoryId);

              return Card(
                child: ListTile(
                  leading: Icon(
                    c.icon,
                    color: c.color,
                  ),
                  title: Text(e.description),
                  subtitle: Text(_getSubtitle(e)),
                  trailing: Text(DateFormat('dd/MM/yyyy').format(e.when)),
                  // isThreeLine: true,
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

    switch (e.split) {
      case SPLIT.EQUALLY:
        {
          _sentence =
              '${e.paidByPersonId} paid ${e.cost.toString()}€ split in half with ${e.splitWithPersonId}';
          break;
        }
      case SPLIT.ME_TOTAL:
        {
          _sentence =
          '${e.splitWithPersonId} owes ${e.paidByPersonId}: ${e.cost.toString()}€';
          break;
        }
      case SPLIT.OTHER_TOTAL:
        {
          _sentence =
          '${e.paidByPersonId} owes ${e.splitWithPersonId}: ${e.cost.toString()}€';
          break;
        }
    }
    return _sentence;
  }
}
