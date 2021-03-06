import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../providers/auth.dart';

class KulutAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;

  const KulutAppBar({Key key, this.appBar}) : super(key: key);

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Kulut - Expense Tracker'),
      backgroundColor: Theme.of(context).colorScheme.primary,
      actions: [
        IconButton(
          icon: const Icon(Icons.exit_to_app),
          tooltip: 'Logout',
          onPressed: () {
            Provider.of<Auth>(context, listen: false).signOut();
          },
        ),
      ],
    );
  }
}
