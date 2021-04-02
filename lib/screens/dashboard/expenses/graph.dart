import 'package:flutter/material.dart';

import 'list.dart';

class EVGraphScreen extends StatefulWidget {
  @override
  _EVGraphScreenState createState() => _EVGraphScreenState();
}

class _EVGraphScreenState extends State<EVGraphScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('ev-graph'),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context)
                .pushNamed(EVListScreen.routeName)
                .whenComplete(() {
                  // Update Balance
              setState(() {});
            });
          },
          child: Text('Check the list'),
        )
      ],
    );
  }
}
