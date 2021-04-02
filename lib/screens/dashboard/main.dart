import 'package:flutter/material.dart';
import 'package:kulut/screens/dashboard/expenses/add_or_edit.dart';
import 'package:kulut/screens/dashboard/expenses/graph.dart';

import '../app_bar/main.dart';
import 'user_info.dart';

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
              EVGraphScreen(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(AddOrEdit.routeName);
        },
      ),
    );
  }
}
