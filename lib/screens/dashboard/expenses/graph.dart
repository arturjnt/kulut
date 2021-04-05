import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:kulut/providers/categories.dart';
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
          builder: (ctx, _expensesSnap) {
            if (_expensesSnap.connectionState == ConnectionState.waiting)
              return LoadingScreen();
            List _categoriesToBuildGraph =
                Expense.byCategory(_expensesSnap.data);

            return Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      startDegreeOffset: -90,
                      centerSpaceRadius: 0,
                      sections: showingSections(_categoriesToBuildGraph),
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
            );
          },
        ),
      ),
    );
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
    // TODO: check if it's reactive
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
