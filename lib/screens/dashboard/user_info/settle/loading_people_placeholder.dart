import 'package:flutter/material.dart';

class LoadingPeoplePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        value: '1',
        items: ['']
            .map<DropdownMenuItem<String>>((_) =>
                DropdownMenuItem(value: '1', child: Text('Loading people...')))
            .toList());
  }
}
