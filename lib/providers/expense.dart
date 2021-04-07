import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth.dart';
import 'categories.dart';

enum SPLIT { EQUALLY, ME_TOTAL, OTHER_TOTAL, OTHER_EQUALLY }

class Expense with ChangeNotifier {
  String id;
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

  Expense.provide();

  Expense({
    this.id,
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

  Future<void> editExpense(Expense e) async {
    await FirebaseFirestore.instance.doc('expenses/${e.id}').update(toMap(e));
  }

  Future<List<Expense>> getAllExpenses() async {
    // get all expenses i paid or splitwithme
    final prefs = await SharedPreferences.getInstance();

    QuerySnapshot qSnapPaid = await FirebaseFirestore.instance
        .collection('expenses')
        .where('paidByPersonId', isEqualTo: prefs.get('_id'))
        .get();

    QuerySnapshot qSnapSplit = await FirebaseFirestore.instance
        .collection('expenses')
        .where('splitWithPersonId', isEqualTo: prefs.get('_id'))
        .get();

    List<QueryDocumentSnapshot> _docs;

    // Check if he's already registered, if not, do it
    if (qSnapPaid.docs.toString() == '[]') {
      if (qSnapSplit.docs.toString() == '[]') {
        return [];
      }
      _docs = qSnapSplit.docs;
    } else {
      if (qSnapSplit.docs.toString() == '[]') {
        _docs = qSnapPaid.docs;
      }
      _docs = [...qSnapPaid.docs, ...qSnapSplit.docs];
    }

    // create expenses and return
    List<Expense> _allExpenses = _docs.map((doc) {
      return Expense(
          id: doc.id,
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

    _allExpenses.sort((a, b) => b.when.compareTo(a.when));
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

  void deleteExpense(expenseId) async {
    await FirebaseFirestore.instance.doc('expenses/$expenseId').delete();
  }

  static String getSplitType(Expense e) {
    var _sentence = '';
    String _paidBy = e.paidByPerson[e.paidByPersonId];
    String _splitWith = e.splitWithPerson[e.splitWithPersonId];

    switch (e.split) {
      case SPLIT.EQUALLY:
        {
          _sentence =
              '$_paidBy paid half of ${e.cost.toString()}€ with $_splitWith';
          break;
        }
      case SPLIT.ME_TOTAL:
        {
          _sentence = '$_splitWith owes $_paidBy: ${e.cost.toString()}€';
          break;
        }
      case SPLIT.OTHER_TOTAL:
        {
          _sentence = '$_paidBy owes $_splitWith: ${e.cost.toString()}€';
          break;
        }
      case SPLIT.OTHER_EQUALLY:
        {
          _sentence =
              '$_splitWith paid half of ${e.cost.toString()}€ with $_paidBy';
          break;
        }
    }
    return _sentence;
  }

  static String getSplitTypeOptions(SPLIT s) {
    return s
        .toString()
        .substring(6)
        .replaceFirst('_', ' ')
        .replaceFirst('EQ', 'We split it eq')
        .replaceFirst('ME', 'i paid the')
        .replaceFirst('OTHER T', 'the person I\'m splitting with, paid the t')
        .replaceFirst('OTHER', 'the person I\'m splitting with paid, and')
        .toLowerCase();
  }

  static List<Category> byCategory(List<Expense> _expenses) {
    List<Category> _categoryList = Categories().categories.map((_c) {
      _c.total = 0;
      return _c;
    }).toList();

    _expenses.forEach((_e) {
      _categoryList
          .firstWhere((_category) => _category.id == _e.categoryId)
          .total += _e.cost;
    });

    _categoryList.sort((a, b) => b.total.compareTo(a.total));
    _categoryList.removeWhere((_cat) => _cat.total == 0.0);
    return _categoryList;
  }
}
