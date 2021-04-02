import 'package:flutter/material.dart';

import 'app_bar/main.dart';
import 'expenses/add_expense.dart';
import 'partials/user_info.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  void runSetState() {
    setState(() {
      // Update balance
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KulutAppBar(appBar: AppBar(), runSetState: runSetState),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              UserInfoScreen(),
              SizedBox(height: 20),
              AddExpenseScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
