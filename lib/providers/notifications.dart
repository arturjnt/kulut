import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../screens/dashboard/expenses/list.dart';

class Notifications {
  /// Initializes the notification listeners
  static Future<void> instanceId(BuildContext context) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    FirebaseMessaging.instance.requestPermission();

    ///! If you are logged in and in the app
    /// Show you the "notification" as a dialog (see below)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      print('notification: ${notification.title} ${notification.body}');
      print('android: ${android.toString()}');

      // IF app in foreground - show dialog and forward to list
      _showDiag(context, notification);
    });

    ///! If the app is open in background
    /// When clicking the notification it redirects you to the EVList Screen
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      Navigator.of(context).pushNamed(EVListScreen.routeName);
    });

    ///! If the app is not ON at all (see below)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  /// Handles the notification and allows you to open the app from it
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  /// Shows a dialog and (...) redirects you to the List of expenses
  static void _showDiag(BuildContext context, RemoteNotification notification) {
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
                    .pushReplacementNamed(EVListScreen.routeName);
              },
            )
          ],
        );
      },
    );
  }
}
