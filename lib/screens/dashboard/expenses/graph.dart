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
                        centerSpaceRadius: 0,
                        sections: showingSections(_expensesSnap.data),
                      ),
                    ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(List<Expense> _expenses) {
    print(_expenses);
    // TODO: remove print
    // TODO: aggregate expenses per category
    // TODO: return category list
    // TODO: check if it's reactive
    return List.generate(4, (i) {
      // final isTouched = i == touchedIndex;
      final double fontSize = /*isTouched ? 25 :*/ 16;
      final double radius = /*isTouched ? 60 :*/ 100;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          return null;
      }
    });
  }
}
