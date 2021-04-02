import 'package:flutter/material.dart';

import '../app_bar/main.dart';
import 'user_info/main.dart';

import 'expenses/graph.dart';
import 'expenses/add_or_edit.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
          Navigator.of(context)
              .pushNamed(AddOrEditScreen.routeName)
              .whenComplete(() {
                // Update Balance
            setState(() {});
          });
        },
      ),
    );
  }
}
