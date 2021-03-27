import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../providers/auth.dart';
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
                  // TODO: calculate and get balance
                ],
              );
            }),
    );
  }
}
