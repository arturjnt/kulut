import 'package:flutter/material.dart';

import 'categories.dart';

enum SPLIT { EQUALLY, ME_TOTAL, OTHER_TOTAL }

class Expense with ChangeNotifier {
  String description;
  double cost;
  DateTime when;
  String paidByPersonId;
  String splitWithPersonId;
  Category category;
  SPLIT split;

  Expense({
    @required this.description,
    @required this.cost,
    @required this.when,
    @required this.paidByPersonId,
    @required this.splitWithPersonId,
    @required this.category,
    this.split = SPLIT.EQUALLY,
  });

  Future<void> saveExpense() {}

  Future<List<Expense>> getTotalExpenses() {}
}
