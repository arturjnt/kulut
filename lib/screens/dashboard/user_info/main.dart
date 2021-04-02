import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../providers/auth.dart';
import '../../loading/main.dart';
import 'settle/main.dart';

class UserInfoScreen extends StatefulWidget {
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<Auth>(context, listen: false).setUserInfo(),
      builder: (_, snap) => snap.connectionState == ConnectionState.waiting
          ? LoadingScreen()
          : Consumer<Auth>(builder: (ctx, authData, _) {
              return Row(
                children: [
                  Column(
                    children: [
                      if (authData.name != null) Text(authData.name),
                      if (authData.pic != null) Image.network(authData.pic),
                    ],
                  ),
                  Text(authData.balance.toStringAsFixed(2)),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(SettleScreen.routeName)
                            .whenComplete(() {
                          // Update Balance
                          setState(() {});
                        });
                      },
                      child: Text('Settle'))
                ],
              );
            }),
    );
  }
}
