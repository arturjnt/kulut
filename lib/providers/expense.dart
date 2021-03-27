import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth.dart';

enum SPLIT { EQUALLY, ME_TOTAL, OTHER_TOTAL }

class Expense with ChangeNotifier {
  String description;
  double cost;
  DateTime when;
  String paidByPersonId;
  String splitWithPersonId;
  int categoryId;
  SPLIT split;

  Expense({
    @required this.description,
    @required this.cost,
    @required this.when,
    @required this.paidByPersonId,
    @required this.splitWithPersonId,
    @required this.categoryId,
    this.split = SPLIT.EQUALLY,
  });

  static Map<String, dynamic> toMap(Expense e) {
    return {
      'description': e.description,
      'cost': e.cost,
      'when': e.when.millisecondsSinceEpoch,
      'paidByPersonId': e.paidByPersonId,
      'splitWithPersonId': e.splitWithPersonId,
      'categoryId': e.categoryId,
      'split': e.split.toString(),
    };
  }

  Future<void> saveExpense(Expense e) async {
    DocumentReference _newExpenseRef =
        await FirebaseFirestore.instance.collection('expenses').add(toMap(e));
    DocumentSnapshot _newExpense = await _newExpenseRef.get();
    return _newExpense.data();
  }

  Future<List<Expense>> getAllExpenses() async {
    QuerySnapshot qSnap = await FirebaseFirestore.instance
        .collection('expenses')
        .where('splitWithPersonId', isEqualTo: Auth().id)
        .get();

    // Check if he's already registered, if not, do it
    if (qSnap.docs.toString() == '[]') {
      return [];
    }

    // create expenses and return
    List<Expense> _allExpenses = qSnap.docs.map((doc) {
      return Expense(
          description: doc['description'],
          cost: doc['cost'],
          when: DateTime.fromMillisecondsSinceEpoch(doc['when']),
          paidByPersonId: doc['paidByPersonId'],
          splitWithPersonId: doc['splitWithPersonId'],
          categoryId: doc['categoryId'],
          split: SPLIT.values.firstWhere(
            (e) => e.toString() == doc['split'],
          ));
    }).toList();

    return _allExpenses;
  }
}
