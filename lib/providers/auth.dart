import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _id;
  String _name;
  String _pic;
  double _balance;

  String get name {
    return _name;
  }

  String get pic {
    return _pic;
  }

  double get balance {
    return _balance;
  }

  Future<void> setUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    _id = prefs.get('_id');
    _name = prefs.get('_name');
    _pic = prefs.get('_pic');
    _balance = prefs.get('_balance');
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
    await prefs.setDouble('_balance', _user['balance']);

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
