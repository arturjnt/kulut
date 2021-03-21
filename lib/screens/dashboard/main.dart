import 'package:flutter/material.dart';

import 'app_bar/main.dart';
import 'partials/add_expense.dart';
import 'partials/user_info.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: KulutAppBar(appBar: AppBar()),
      body: Container(
        height: deviceSize.height - 100,
        width: deviceSize.width,
        color: Colors.red,
          child: Column(
            children: [
              UserInfoScreen(),
              AddExpenseScreen(),
            ],
          ),
      ),
    );
  }
}
