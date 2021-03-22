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
        child: Column(
          children: [
            UserInfoScreen(),
            SizedBox(height: 20),
            AddExpenseScreen(),
          ],
        ),
      ),
    );
  }
}
