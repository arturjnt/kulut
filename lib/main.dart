import 'package:flutter/material.dart';

import 'screens/auth/main.dart';
import 'screens/dashboard/main.dart';
import 'screens/expenses_view/graph.dart';
import 'screens/expenses_view/list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kulut',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Text('Kulut - expense tracker'),
      routes: {
        AuthScreen.routeName: (ctx) => AuthScreen(),
        DashboardScreen.routeName: (ctx) => DashboardScreen(),
        EVGraphScreen.routeName: (ctx) => EVGraphScreen(),
        EVListScreen.routeName: (ctx) => EVListScreen(),
      },
    );
  }
}
