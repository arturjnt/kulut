import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

    final User currentUser = _auth.currentUser;

    // QuerySnapshot qSnap = await FirebaseFirestore.instance
    //     .collection('users')
    //     .where('uid', isEqualTo: currentUser.uid)
    //     .get();
    //
    // // Check if he's already registered, if not, register and get him
    // if (qSnap.docs.toString() == '[]') {
    //   await FirebaseFirestore.instance.collection('users').add(
    //       {'uid': currentUser.uid, 'displayName': currentUser.displayName});
    //   qSnap = await FirebaseFirestore.instance
    //       .collection('users')
    //       .where('uid', isEqualTo: currentUser.uid)
    //       .get();
    // }
    //
    // final userToSaveLocally = qSnap.docs[0].data();
    //
    // // Get animals (for now getting just 1)
    // final animal = await userToSaveLocally['animals'][0].get();
    //
    // final prefs = await SharedPreferences.getInstance();
    // final userData = json.encode({
    //   'userId': userToSaveLocally['uid'],
    //   'displayName': userToSaveLocally['displayName'],
    //   'animalName': animal['name'],
    //   'animalId': animal.reference.id,
    // });
    // await prefs.setString('userData', userData);

    notifyListeners();
  }

  Future<void> signOut() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    await googleSignIn.signOut();
    await _auth.signOut();

    // final prefs = await SharedPreferences.getInstance();
    // prefs.clear();

    notifyListeners();
  }
}
