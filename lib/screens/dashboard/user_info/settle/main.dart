import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/auth.dart';
import 'loading_people_placeholder.dart';

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
          builder: (ctx, peopleSnap) {
            if (peopleSnap.connectionState == ConnectionState.waiting)
              return LoadingPeoplePlaceholder();

            people = peopleSnap.data;
            _shareWithWhomId = people[0]['id'];

            return Column(
              children: [
                DropdownButton<String>(
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
                  }).toList(),
                ),
                FutureBuilder(
                  future: _authProvider.getMyBalance(_shareWithWhomId),
                  builder: (ctx, balanceSnap) =>
                      (balanceSnap.connectionState == ConnectionState.waiting)
                          ? Text('Loading Balance...')
                          : Text(balanceSnap.data.toString()),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text("Are you sure?"),
                        actions: [
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                          TextButton(
                            child: Text('Yes'),
                            onPressed: () async {
                              // Call settle and go back and update
                              await _authProvider.settle(_shareWithWhomId);
                              Navigator.of(context).pop(true);
                            },
                          )
                        ],
                      ),
                    ).then((popAgain) =>
                        (popAgain) ? Navigator.of(context).pop() : null);
                  },
                  child: Text('Settle'),
                )
              ],
            );
          }),
    );
  }
}
