import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth.dart';

class SettleUp {
  static Future<void> show(context, _shareWithWhomId) async {
    double _balance = await Auth().getMyBalance();
    String _settleWithWhom = await Provider.of<Auth>(context, listen: false)
        .getUserName(_shareWithWhomId);

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
            'Settle Up: ${_balance.toStringAsFixed(2)}€ with $_settleWithWhom ?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () async {
              // settle with whom
              // calling provider expenses - set all past expenses as settled
              await Provider.of<Auth>(context, listen: false)
                  .settle(_shareWithWhomId);
              Navigator.of(context).pop();
              /*func(defec, ctx)*/
            },
          ),
        ],
      ),
    );
  }
}
