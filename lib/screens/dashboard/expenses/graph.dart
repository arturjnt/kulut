import 'package:flutter/material.dart';

import 'list.dart';

class EVGraphScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('ev-graph'),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(EVListScreen.routeName);
          },
          child: Text('Check the list'),
        )
      ],
    );
  }
}
