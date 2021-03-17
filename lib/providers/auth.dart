import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

class Auth with ChangeNotifier {
  String _id;
  String _name;
  String _picUrl;
  double _balance;

  String get name {
    return _name;
  }

  String get pic {
    return _picUrl;
  }

  double get balance {
    return _balance;
  }

  Future<void> signIn() async {
    // Initializes firebase when you enter and are NOT logged in
    // It's so the login button works
    await Firebase.initializeApp();

    // TODO: Set private vars - or not, as you can probably get them with the GoogleSignInProvider
  }

  Future<void> signOut() async {}
}
