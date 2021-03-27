import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth.dart';

class SettleUp {
  static Future<void> show(context) async {
    double _balance = await Auth().getMyBalance();

    await showDialog(
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
            onPressed: () async {
              // TODO: calling provider expenses - set all past expenses as settled
              // TODO: settle with whom and choose by how much (?)
              await Provider.of<Auth>(context, listen: false).settle();
              Navigator.of(context).pop();
              /*func(defec, ctx)*/
            },
          ),
        ],
      ),
    );
  }
}
