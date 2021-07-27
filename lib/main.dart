import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'providers/auth.dart';
import 'providers/expense.dart';

import 'screens/auth/main.dart';
import 'screens/dashboard/main.dart';
import 'screens/dashboard/expenses/add_or_edit.dart';
import 'screens/dashboard/expenses/list.dart';
import 'screens/dashboard/user_info/settle.dart';
import 'screens/loading/main.dart';

Future<void> _not(RemoteMessage message) async {
  print("Handling a background message: ${message?.messageId}");
}

Future<void> _instanceId() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var token = await FirebaseMessaging.instance.getToken();
  print("Print Instance Token ID: " + token);

  FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification notification = message.notification;
    AndroidNotification android = message.notification?.android;

    print('notification: ${notification.title} ${notification.body}');
    print('android: ${android.toString()}');
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
  });
  FirebaseMessaging.onBackgroundMessage(_not);
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: Expense.provide(),
        ),
      ],
      child: MaterialApp(
        title: 'Kulut - Expense Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
        home: FutureBuilder(
            // Initializes firebase when you enter and are logged in
            // Makes the logout button function properly
            future: _instanceId(),
            builder: (_, firebaseAppSnap) {
              if (firebaseAppSnap.connectionState == ConnectionState.waiting) {
                return LoadingScreen();
              }

              return StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (_, firebaseAuthSnap) {
                    if (firebaseAuthSnap.connectionState ==
                        ConnectionState.waiting) {
                      return LoadingScreen();
                    }
                    // If you're logged, go to dashboard
                    // if not, go to the auth screen
                    return (firebaseAuthSnap.hasData)
                        ? DashboardScreen()
                        : AuthScreen();
                  });
            }),
        routes: {
          AuthScreen.routeName: (ctx) => AuthScreen(),
          DashboardScreen.routeName: (ctx) => DashboardScreen(),
          EVListScreen.routeName: (ctx) => EVListScreen(),
          AddOrEditScreen.routeName: (ctx) => AddOrEditScreen(),
          SettleScreen.routeName: (ctx) => SettleScreen(),
        },
      ),
    );
  }
}
