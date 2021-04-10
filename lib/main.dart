import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'providers/auth.dart';
import 'providers/expense.dart';

import 'screens/auth/main.dart';
import 'screens/dashboard/main.dart';
import 'screens/dashboard/expenses/add_or_edit.dart';
import 'screens/dashboard/expenses/list.dart';
import 'screens/dashboard/user_info/settle.dart';
import 'screens/loading/main.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: Expense.provide(),
        ),
      ],
      child: MaterialApp(
        title: 'Kulut - Split Expense Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
        home: FutureBuilder(
            // Initializes firebase when you enter and are logged in
            // It's so the logout button works
            future: Firebase.initializeApp(),
            builder: (_, firebaseAppSnap) {
              if (firebaseAppSnap.connectionState == ConnectionState.waiting) {
                return LoadingScreen();
              }

              return StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (_, firebaseAuthSnap) {
                    if (firebaseAuthSnap.connectionState ==
                        ConnectionState.waiting) {
                      return LoadingScreen();
                    }
                    return (firebaseAuthSnap.hasData)
                        ? DashboardScreen()
                        : AuthScreen();
                  });
            }),
        routes: {
          AuthScreen.routeName: (ctx) => AuthScreen(),
          DashboardScreen.routeName: (ctx) => DashboardScreen(),
          EVListScreen.routeName: (ctx) => EVListScreen(),
          AddOrEditScreen.routeName: (ctx) => AddOrEditScreen(),
          SettleScreen.routeName: (ctx) => SettleScreen(),
        },
      ),
    );
  }
}
