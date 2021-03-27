import 'package:flutter/material.dart';

class EVListScreen extends StatelessWidget {
  static const routeName = '/ev-list';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.pie_chart),
            tooltip: 'Go to Graphs',
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/ev-graph');
            },
          ),
        ],
      ),
      body: Text('ev-list'),
    );
  }
}
