import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../providers/auth.dart';
import '../../../providers/expense.dart';
import '../../loading/main.dart';

class UserInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<Auth>(context, listen: false).setUserInfo(),
      builder: (_, snap) => snap.connectionState == ConnectionState.waiting
          ? LoadingScreen()
          : Consumer<Auth>(builder: (ctx, authData, _) {
              return Column(
                children: [
                  Text(authData.name),
                  Image.network(authData.pic),
                  FutureBuilder(
                    future: Provider.of<Expense>(context, listen: false)
                        .getMyBalance(),
                    builder: (ctx, expenseSnap) =>
                        (expenseSnap.connectionState == ConnectionState.waiting)
                            ? LoadingScreen()
                            : Text(expenseSnap.data.toString()),
                  ),
                ],
              );
            }),
    );
  }
}
