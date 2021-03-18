import 'package:flutter/material.dart';

class KulutAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;

  const KulutAppBar({Key key, this.appBar}) : super(key: key);

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Kulut'),
    );
  }
}
