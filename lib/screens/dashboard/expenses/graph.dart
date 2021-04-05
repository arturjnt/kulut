import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../../../providers/expense.dart';
import '../../loading/main.dart';

class EVGraphScreen extends StatefulWidget {
  @override
  _EVGraphScreenState createState() => _EVGraphScreenState();
}

class _EVGraphScreenState extends State<EVGraphScreen> {
  @override
  Widget build(BuildContext context) {
    Expense _expenseProvider = Provider.of<Expense>(context);

    return AspectRatio(
      aspectRatio: 16 / 10,
      child: Card(
        child: FutureBuilder(
          future: _expenseProvider.getAllExpensesFull(),
          builder: (ctx, _expensesSnap) =>
              _expensesSnap.connectionState == ConnectionState.waiting
                  ? LoadingScreen()
                  : PieChart(
                      PieChartData(
                        startDegreeOffset: -90,
                        centerSpaceRadius: 0,
                        sections: showingSections(_expensesSnap.data),
                      ),
                    ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(List<Expense> _expenses) {
    // TODO: create legend
    // TODO: check if it's reactive
    // TODO: add month picker

    List _categoriesToBuildGraph = Expense.byCategory(_expenses);
    double _totalTotal = _categoriesToBuildGraph.fold(
        0, (accumulator, currentValue) => accumulator += currentValue.total);

    return _categoriesToBuildGraph
        .map((_cat) => PieChartSectionData(
              color: _cat.color,
              value: _cat.total,
              title:
                  '${((_cat.total / _totalTotal) * 100).toStringAsFixed(2)}%',
              radius: 100,
              titleStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ))
        .toList();
  }
}
