import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../providers/categories.dart';
import '../../../providers/expense.dart';
import '../../loading/main.dart';

class EVGraphScreen extends StatefulWidget {
  @override
  _EVGraphScreenState createState() => _EVGraphScreenState();
}

class _EVGraphScreenState extends State<EVGraphScreen> {
  DateTime _currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    Expense _expenseProvider = Provider.of<Expense>(context);

    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Card(
        child: FutureBuilder(
          future: _monthlyExpenses(_expenseProvider.getAllExpensesFull(),
              _currentDate.month, _currentDate.year),
          builder: (ctx, _expensesSnap) {
            if (_expensesSnap.connectionState == ConnectionState.waiting)
              return LoadingScreen();
            List<Expense> _expensesToBuildGraph = _expensesSnap.data;
            List<Category> _categoriesToBuildGraph =
                Expense.byCategory(_expensesToBuildGraph);

            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: IconButton(
                            icon: Icon(Icons.chevron_left),
                            onPressed: () async {
                              setState(() {
                                DateTime previousDate = _currentDate;
                                _currentDate = DateTime(previousDate.year,
                                    previousDate.month - 1, 1);
                              });
                            })),
                    Text(DateFormat('MMMM yyyy').format(_currentDate)),
                    Expanded(
                        child: IconButton(
                            icon: Icon(Icons.chevron_right),
                            onPressed: () async {
                              setState(() {
                                DateTime previousDate = _currentDate;
                                _currentDate = DateTime(previousDate.year,
                                    previousDate.month + 1, 1);
                              });
                            }))
                  ],
                ),
                (_expensesToBuildGraph.isEmpty)
                    ? Text('No expenses recorded!')
                    : Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: PieChart(
                                PieChartData(
                                  startDegreeOffset: -90,
                                  centerSpaceRadius: 0,
                                  sections:
                                      showingSections(_categoriesToBuildGraph),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: getLegend(_categoriesToBuildGraph),
                            )
                          ],
                        ),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<List<Expense>> _monthlyExpenses(
      Future<List<Expense>> _allExpenses, int month, int year) async {
    List<Expense> _allExpensesDone = await _allExpenses;

    _allExpensesDone
        .removeWhere((_e) => _e.when.month != month || _e.when.year != year);

    return _allExpensesDone;
  }

  List<Widget> getLegend(List<Category> _categoriesToBuildGraph) {
    double size = 12;
    return _categoriesToBuildGraph.map((c) {
      return Row(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(shape: BoxShape.circle, color: c.color),
          ),
          SizedBox(width: 5),
          Text('${c.name}: ${c.total}€', style: TextStyle(fontSize: 14)),
        ],
      );
    }).toList();
  }

  List<PieChartSectionData> showingSections(
      List<Category> _categoriesToBuildGraph) {
    // TODO: add month picker

    double _totalTotal = _categoriesToBuildGraph.fold(
        0, (accumulator, currentValue) => accumulator += currentValue.total);

    return _categoriesToBuildGraph
        .map((_cat) => PieChartSectionData(
              color: _cat.color,
              value: _cat.total,
              badgeWidget: Text(
                '${((_cat.total / _totalTotal) * 100).toStringAsFixed(2)}%',
                style: TextStyle(shadows: [
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 4.0,
                    color: Colors.black,
                  )
                ]),
              ),
              showTitle: false,
              radius: 70,
              badgePositionPercentageOffset: 1.3,
              titleStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ))
        .toList();
  }
}
