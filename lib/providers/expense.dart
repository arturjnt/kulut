import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

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

  static Map<String, dynamic> toMap(Expense e) {
    return {
      'description': e.description,
      'cost': e.cost,
      'when': e.when.millisecondsSinceEpoch,
      'paidByPersonId': e.paidByPersonId,
      'splitWithPersonId': e.splitWithPersonId,
      'category': Category.toMap(e.category),
      'split': e.split.toString(),
    };
  }

  Future<void> saveExpense(Expense e) async {
    DocumentReference _newExpenseRef = await FirebaseFirestore.instance
        .collection('expenses')
        .add(toMap(e));
    DocumentSnapshot _newExpense = await _newExpenseRef.get();
    return _newExpense.data();
  }

  Future<List<Expense>> getTotalExpenses() {}
}
