import 'package:flutter/material.dart';

import '../../providers/notifications.dart';

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
      body: FutureBuilder(
        // Initialize notifications as soon as you're logged in
        future: Notifications.instanceId(context),
        builder: (_, __) {
          return Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  UserInfoScreen(),
                  listButton(context),
                  EVGraphScreen(),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .pushNamed(AddOrEditScreen.routeName)
              .whenComplete(() {
            // Update Balance when popping the AddExpense Screen
            setState(() {});
          });
        },
      ),
    );
  }

  /// Show the "ExpenseView (EV)List" screen
  Widget listButton(context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 4, right: 4),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context)
              .pushNamed(EVListScreen.routeName)
              .whenComplete(() {
            // Update Balance when popping the EVList Screen
            setState(() {});
          });
        },
        child: Container(
          height: 50,
          child: Row(
            children: [
              const Expanded(child: const Text('Check the list')),
              const Icon(Icons.list),
            ],
          ),
        ),
      ),
    );
  }
}
