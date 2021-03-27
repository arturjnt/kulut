import 'package:flutter/material.dart';

import '../../../providers/auth.dart';

class SettleUp {
  static void show(context) async {
    double _balance = await Auth().getMyBalance();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Settle Up: ${_balance.toStringAsFixed(2)}€ ?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              // TODO: calling provider expenses - set all past expenses as settled
              print('cenas');
              /*func(defec, ctx)*/
            },
          ),
        ],
      ),
    );
  }
}
