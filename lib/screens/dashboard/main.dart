import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../app_bar/main.dart';
import 'user_info/main.dart';

import 'expenses/graph.dart';
import 'expenses/list.dart';
import 'expenses/add_or_edit.dart';

void _showDiag(BuildContext context, RemoteNotification notification) {
  showDialog(
    context: context,
    builder: (_) {
      return new AlertDialog(
        title: Text(notification.title),
        content: Text(notification.body),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('Show me'),
            onPressed: () async {
              Navigator.of(context)
                  .pushNamed(EVListScreen.routeName)
                  .whenComplete(() => Navigator.of(context).pop(false));
            },
          )
        ],
      );
    },
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message?.messageId}");
}

Future<void> _instanceId(BuildContext context) async {
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

    // IF app in foreground - show dialog and forward to list
    _showDiag(context, notification);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
    Navigator.of(context).pushNamed(EVListScreen.routeName);
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KulutAppBar(appBar: AppBar()),
      body: FutureBuilder(
        future: _instanceId(context),
        builder: (_, __) {
          return Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  UserInfoScreen(),
                  listButton(context),
                  EVGraphScreen(),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .pushNamed(AddOrEditScreen.routeName)
              .whenComplete(() {
            // Update Balance when popping the AddExpense Screen
            setState(() {});
          });
        },
      ),
    );
  }

  /// Show the "ExpenseView (EV)List" screen
  Widget listButton(context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 4, right: 4),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context)
              .pushNamed(EVListScreen.routeName)
              .whenComplete(() {
            // Update Balance when popping the EVList Screen
            setState(() {});
          });
        },
        child: Container(
          height: 50,
          child: Row(
            children: [
              const Expanded(child: const Text('Check the list')),
              const Icon(Icons.list),
            ],
          ),
        ),
      ),
    );
  }
}
