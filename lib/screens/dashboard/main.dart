import 'package:flutter/material.dart';

import 'app_bar/main.dart';
import 'partials/add_expense.dart';
import 'partials/user_info.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KulutAppBar(appBar: AppBar()),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15, right: 10),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/ev-list');
          },
          child: Icon(Icons.list),
        ),
      ),
    );
  }
}
