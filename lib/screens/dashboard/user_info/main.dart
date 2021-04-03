import 'package:flutter/cupertino.dart';
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
          ? SizedBox(height: 112,child: LoadingScreen(),)
          : Consumer<Auth>(builder: (ctx, authData, _) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                child: Card(
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Image.network(authData.pic, width: 50),
                    ),
                    title: Text(authData.name),
                    subtitle: Row(
                      children: [
                        Text('Total balance: '),
                        Text(
                          '${authData.balance.toStringAsFixed(2)}€',
                          style: (authData.balance < 0)
                              ? TextStyle(color: Theme.of(context).errorColor)
                              : null,
                        ),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(SettleScreen.routeName)
                            .whenComplete(() {
                          // Update Balance
                          setState(() {});
                        });
                      },
                      child: Text('Settle'),
                    ),
                  ),
                ),
              );
            }),
    );
  }
}
