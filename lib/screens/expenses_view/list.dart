import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              return Card(
                child: ListTile(
                  title: Text(e.description),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
