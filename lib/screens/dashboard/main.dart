import 'package:flutter/material.dart';

import '../app_bar/main.dart';
import 'user_info/main.dart';

import 'expenses/graph.dart';
import 'expenses/list.dart';
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
              listButton(context),
              EVGraphScreen(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primary,
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

  Widget listButton(context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context)
            .pushNamed(EVListScreen.routeName)
            .whenComplete(() {
          // Update Balance
          setState(() {});
        });
      },
      child: Container(
        height: 50,
        child: Row(
          children: [
            Expanded(child: Text('Check the list')),
            Icon(Icons.list),
          ],
        ),
      ),
    );
  }
}
