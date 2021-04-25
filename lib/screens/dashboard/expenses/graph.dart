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

enum MOVE_MONTH { PREVIOUS, NEXT }

class _EVGraphScreenState extends State<EVGraphScreen> {
  DateTime _currentDate = DateTime.now();
  bool _controlCombined = false;

  @override
  Widget build(BuildContext context) {
    Expense _expenseProvider = Provider.of<Expense>(context);

    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        child: FutureBuilder(
            future: _monthlyExpenses(
                _expenseProvider.getAllExpensesFull(_controlCombined),
                _currentDate.month,
                _currentDate.year),
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
                      Expanded(child: prevNextMonth(MOVE_MONTH.PREVIOUS)),
                      Text(DateFormat('MMMM yyyy').format(_currentDate)),
                      Expanded(child: prevNextMonth(MOVE_MONTH.NEXT))
                    ],
                  ),
                  CheckboxListTile(
                    title: Text('Show Combined Expenses',
                        textAlign: TextAlign.right),
                    value: _controlCombined,
                    onChanged: (_newState) {
                      setState(() {
                        _controlCombined = _newState;
                      });
                    },
                  ),
                  if (_expensesToBuildGraph.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 90),
                      child: const Text('No expenses recorded!'),
                    ),
                  if (_expensesToBuildGraph.isNotEmpty)
                    Text(
                      'Total: ${Expense.categoryTotal(_categoriesToBuildGraph).toStringAsFixed(2)}€',
                      style: TextStyle(
                          fontSize: 20, decoration: TextDecoration.underline),
                    ),
                  if (_expensesToBuildGraph.isNotEmpty)
                    Expanded(
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
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: getLegend(_categoriesToBuildGraph),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            }),
      ),
    );
  }

  IconButton prevNextMonth(MOVE_MONTH mm) {
    return IconButton(
        icon: Icon((mm == MOVE_MONTH.PREVIOUS)
            ? Icons.chevron_left
            : Icons.chevron_right),
        onPressed: () async {
          setState(() {
            DateTime previousDate = _currentDate;
            _currentDate = DateTime(
                previousDate.year,
                (mm == MOVE_MONTH.PREVIOUS)
                    ? previousDate.month - 1
                    : previousDate.month + 1,
                1);
          });
        });
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
          Text('${c.total.toStringAsFixed(2)}€',
              style: TextStyle(fontSize: 14)),
        ],
      );
    }).toList();
  }

  List<PieChartSectionData> showingSections(
      List<Category> _categoriesToBuildGraph) {
    double _totalTotal = _categoriesToBuildGraph.fold(
        0, (accumulator, currentValue) => accumulator += currentValue.total);

    return _categoriesToBuildGraph
        .map((_cat) => PieChartSectionData(
              color: _cat.color,
              value: _cat.total,
              badgeWidget: (_cat.total / _totalTotal < 0.06)
                  ? null
                  : Text(
                      '${_cat.name}\n${((_cat.total / _totalTotal) * 100).toStringAsFixed(2)}%',
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
              badgePositionPercentageOffset: 1.5,
              titleStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ))
        .toList();
  }
}
