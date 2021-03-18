import 'package:flutter/material.dart';

import 'app_bar/main.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KulutAppBar(appBar: AppBar()),
      body: Container(
        child: Text('dash'),
      ),
    );
  }
}
