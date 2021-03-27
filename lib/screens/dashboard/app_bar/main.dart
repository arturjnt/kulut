import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../providers/auth.dart';
import 'settle_up.dart';

class KulutAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;

  const KulutAppBar({Key key, this.appBar}) : super(key: key);

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Kulut'),
      actions: [
        IconButton(
          icon: Icon(Icons.atm_outlined),
          tooltip: 'Settle',
          onPressed: () {
            SettleUp.show(context);
          },
        ),
        IconButton(
          icon: Icon(Icons.exit_to_app),
          tooltip: 'Logout',
          onPressed: () {
            Provider.of<Auth>(context, listen: false).signOut();
          },
        ),
      ],
    );
  }
}
