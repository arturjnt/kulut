import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth.dart';
import '../../loading/main.dart';

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
      appBar: AppBar(title: const Text('Settle')),
      body: FutureBuilder(
          future: _authProvider.getUsersToShare(),
          builder: (ctx, peopleSnap) {
            if (peopleSnap.connectionState == ConnectionState.waiting)
              return LoadingScreen();

            people = peopleSnap.data;
            _shareWithWhomId = people[0]['id'];

            return FutureBuilder(
              future: _authProvider.getMyBalance(_shareWithWhomId),
              builder: (ctx, balanceSnap) => (balanceSnap.connectionState ==
                      ConnectionState.waiting)
                  ? const SizedBox()
                  : Container(
                      padding: const EdgeInsets.only(top: 50),
                      width: double.infinity,
                      child: Column(
                        children: [
                          // TODO: take the children out of the tree into it's
                          // TODO: own method, to make it more readable
                          // Who
                          DropdownButton<String>(
                            value: _shareWithWhomId,
                            onChanged: (String newValue) {
                              setState(() {
                                _shareWithWhomId = newValue;
                              });
                            },
                            items: people
                                .map<DropdownMenuItem<String>>((Map _user) {
                              return DropdownMenuItem<String>(
                                value: _user['id'],
                                child: Row(
                                  children: [
                                    Image.network(_user['pic'], height: 20),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(_user['name']),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          // How much
                          Text(
                            'Owed amount: ${balanceSnap.data.toStringAsFixed(2)}€',
                            style: TextStyle(fontSize: 24),
                          ),
                          // Actions
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text("Are you sure?"),
                                    actions: [
                                      TextButton(
                                        child: const Text('Cancel'),
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                      ),
                                      TextButton(
                                        child: const Text('Yes'),
                                        onPressed: () async {
                                          // Call settle and go back and update
                                          await _authProvider
                                              .settle(_shareWithWhomId);
                                          Navigator.of(context).pop(true);
                                        },
                                      )
                                    ],
                                  ),
                                ).then((popAgain) => (popAgain)
                                    ? Navigator.of(context).pop()
                                    : null);
                              },
                              child: Container(
                                height: 50,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: const Text('Settle',
                                            textAlign: TextAlign.center))
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
            );
          }),
    );
  }
}
