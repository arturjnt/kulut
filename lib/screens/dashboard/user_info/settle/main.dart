import 'package:flutter/material.dart';
import 'package:kulut/screens/dashboard/user_info/settle/loading_people_placeholder.dart';
import 'package:provider/provider.dart';

import '../../../../providers/auth.dart';

class SettleScreen extends StatefulWidget {
  static const routeName = '/settle';

  @override
  _SettleScreenState createState() => _SettleScreenState();
}

class _SettleScreenState extends State<SettleScreen> {
  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<Auth>(context, listen: false);
    String _shareWithWhomId;
    List<Map> people;

    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
          future: _authProvider.getUsersToShare(),
          builder: (ctx, authSnap) {
            if (authSnap.connectionState == ConnectionState.waiting)
              return LoadingPeoplePlaceholder();

            people = authSnap.data;
            _shareWithWhomId = people[0]['id'];

            return DropdownButton<String>(
                value: _shareWithWhomId,
                onChanged: (String newValue) {
                  setState(() {
                    _shareWithWhomId = newValue;
                  });
                },
                items: people.map<DropdownMenuItem<String>>((Map _user) {
                  return DropdownMenuItem<String>(
                    value: _user['id'],
                    child: Row(
                      children: [
                        Image.network(_user['pic'], height: 20),
                        Text(_user['name']),
                      ],
                    ),
                  );
                }).toList());
          }),
    );
  }
}
