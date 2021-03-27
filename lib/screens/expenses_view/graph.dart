import 'package:flutter/material.dart';

class EVGraphScreen extends StatelessWidget {
  static const routeName = '/ev-graph';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            tooltip: 'Got to List',
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/ev-list');
            },
          ),
        ],
      ),
      body: Text('ev-graph'),
    );
  }
}
