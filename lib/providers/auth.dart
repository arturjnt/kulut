import 'package:flutter/material.dart';

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

  Future<void> signIn() {
    // TODO: Set private vars - or not, as you can probably get them with the GoogleSignInProvider
  }

  Future<void> signOut() {}
}
