import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'expense.dart';

class Auth with ChangeNotifier {
  String _id;
  String _name;
  String _pic;
  double _balance;

  String get id {
    return _id;
  }

  String get name {
    return _name;
  }

  String get pic {
    return _pic;
  }

  double get balance {
    return _balance;
  }

  Future<List> getUsersToShare() async {
    // Make sure the Id is in the class
    await setUserInfo();
    QuerySnapshot qSnap = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isNotEqualTo: _id)
        .get();

    // Check if he's already registered, if not, do it
    if (qSnap.docs.toString() == '[]') {
      return [];
    }

    return qSnap.docs
        .map((doc) =>
            {'id': doc['id'], 'name': doc['displayName'], 'pic': doc['pic']})
        .toList();
  }

  Future<void> setUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    _id = prefs.get('_id');
    _name = prefs.get('_name');
    _pic = prefs.get('_pic');
    _balance = await getMyBalance(null);
  }

  Future<String> getUserName(String id) async {
    QuerySnapshot qSnap = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: id)
        .get();
    var user = qSnap.docs[0].data();
    return user['displayName'];
  }

  Future<Map> createOrGetUser(User user) async {
    QuerySnapshot qSnap = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: user.uid)
        .get();

    // Check if he's already registered, if not, do it
    if (qSnap.docs.toString() == '[]') {
      DocumentReference _newUserRef =
          await FirebaseFirestore.instance.collection('users').add({
        'id': user.uid,
        'displayName': user.displayName,
        'pic': user.photoURL,
        'balance': 0.0,
      });
      DocumentSnapshot _newUser = await _newUserRef.get();
      return _newUser.data();
    } else {
      return qSnap.docs[0].data();
    }
  }

  Future<void> settle(_settleWithWhomId) async {
    List<Expense> _allExpenses =
        await Expense.provide().getAllExpenses(isCombined: true);
    // filter settled expenses
    List<Expense> _allUnsettledExpenses =
        _allExpenses.where((e) => e.settled == false).toList();

    _allUnsettledExpenses.forEach((exp) {
      if (exp.splitWithPersonId == _settleWithWhomId ||
          exp.paidByPersonId == _settleWithWhomId) {
        FirebaseFirestore.instance
            .doc('expenses/${exp.id}')
            .update({'settled': true});
      }
    });
    notifyListeners();
  }

  Future<double> getMyBalance(withWhomId) async {
    final prefs = await SharedPreferences.getInstance();
    String _idToSet = prefs.get('_id');
    List<Expense> _allExpenses =
        await Expense.provide().getAllExpenses(isCombined: true);
    // filter settled expenses
    List<Expense> _allUnsettledExpenses =
        _allExpenses.where((e) => e.settled == false).toList();
    var _balanceToSet = 0.0;

    if (withWhomId != null) {
      _allUnsettledExpenses = _allUnsettledExpenses.where((exp) {
        return (exp.splitWithPersonId == withWhomId ||
            exp.paidByPersonId == withWhomId);
      }).toList();
    }

    _allUnsettledExpenses.forEach((e) {
      if (e.paidByPersonId == _idToSet) {
        switch (e.split) {
          case SPLIT.EQUALLY:
            {
              _balanceToSet += e.cost / 2;
              break;
            }
          case SPLIT.ME_TOTAL:
            {
              _balanceToSet += e.cost;
              break;
            }
          case SPLIT.OTHER_TOTAL:
            {
              _balanceToSet -= e.cost;
              break;
            }
          case SPLIT.OTHER_EQUALLY:
            {
              _balanceToSet -= e.cost / 2;
              break;
            }
          case SPLIT.NO_SPLIT:
            {
              break;
            }
        }
      } else if (e.splitWithPersonId == _idToSet) {
        switch (e.split) {
          case SPLIT.EQUALLY:
            {
              _balanceToSet -= e.cost / 2;
              break;
            }
          case SPLIT.ME_TOTAL:
            {
              _balanceToSet -= e.cost;
              break;
            }
          case SPLIT.OTHER_TOTAL:
            {
              _balanceToSet += e.cost;
              break;
            }
          case SPLIT.OTHER_EQUALLY:
            {
              _balanceToSet += e.cost / 2;
              break;
            }
          case SPLIT.NO_SPLIT:
            {
              break;
            }
        }
      }
    });

    return _balanceToSet;
  }

  Future<void> signIn() async {
    // Initializes firebase when you enter and are NOT logged in
    // It's so the login button works
    await Firebase.initializeApp();

    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user == null) return null;

    Map _user = await createOrGetUser(_auth.currentUser);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('_id', _user['id']);
    await prefs.setString('_name', _user['displayName']);
    await prefs.setString('_pic', _user['pic']);

    await setUserInfo();

    notifyListeners();
  }

  Future<void> signOut() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    await googleSignIn.signOut();
    await _auth.signOut();

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();

    notifyListeners();
  }
}
