import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth.dart';
import 'categories.dart';

enum SPLIT { EQUALLY, ME_TOTAL, OTHER_TOTAL }

class Expense with ChangeNotifier {
  String description;
  double cost;
  DateTime when;
  String paidByPersonId;
  String splitWithPersonId;
  int categoryId;
  bool settled;
  SPLIT split;

  Category category;
  Map<String, String> paidByPerson;
  Map<String, String> splitWithPerson;

  Expense({
    @required this.description,
    @required this.cost,
    @required this.when,
    @required this.paidByPersonId,
    @required this.splitWithPersonId,
    @required this.categoryId,
    this.settled = false,
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
      'settled': e.settled,
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
        .orderBy('when', descending: true)
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
          settled: doc['settled'],
          split: SPLIT.values.firstWhere(
            (e) => e.toString() == doc['split'],
          ));
    }).toList();

    return _allExpenses;
  }

  /// Helper function to transform ids into people's names
  Future<List<Map<String, String>>> _people(List<Expense> expenses) async {
    Set<String> _peopleIds = Set<String>();
    expenses.forEach((p) {
      _peopleIds.add(p.paidByPersonId);
      _peopleIds.add(p.splitWithPersonId);
    });
    var _allPeople = await Future.wait(_peopleIds.toList().map((pid) async {
      return {pid: await Auth().getUserName(pid)};
    }));

    return _allPeople;
  }

  /// Returns all expenses, plus data on people and categories
  Future<List<Expense>> getAllExpensesFull() async {
    List<Expense> _allExpenses = await getAllExpenses();
    List<Map<String, String>> _allPeople = await _people(_allExpenses);

    _allExpenses.forEach((e) {
      e.category = Categories().getCategoryById(e.categoryId);
      e.paidByPerson =
          _allPeople.firstWhere((p) => p[e.paidByPersonId] != null);
      e.splitWithPerson =
          _allPeople.firstWhere((p) => p[e.splitWithPersonId] != null);
    });

    return _allExpenses;
  }
}
