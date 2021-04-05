import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.monetization_on,
                size: 150,
                color: Colors.lightGreen,
              ),
              const SizedBox(height: 50),
              OutlinedButton(
                onPressed: () async {
                  await Provider.of<Auth>(context, listen: false).signIn();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image:
                            const AssetImage("assets/images/google_logo.png"),
                        height: 35.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text('Sign in with Google'),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
