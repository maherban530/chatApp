import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Core/route_generator.dart' as routes;
import 'Core/route_path.dart';
import 'Core/theme.dart';
import 'Notifications/notification.dart';
import 'Provider/provider_collection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _initializeFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providersCollection,
      child: MaterialApp(
        title: 'ChatApp',
        theme: ChatAppTheme.lightTheme,
        darkTheme: ChatAppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splash,
        routes: routes.route,
      ),
    );
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp();
  notificationCallInitialization();
  await notificationInitialization();
  FirebaseMessaging.onBackgroundMessage(messageHandler);
  firebaseMessagingListener();
  // await notificationInitialize();

  // await FirebaseMessaging.instance.setAutoInitEnabled(true);

  // /// For Background Message Handling
  // FirebaseMessaging.onBackgroundMessage(backgroundMsgAction);

  // /// For Foreground Message Handling
  // FirebaseMessaging.onMessage.listen(foregroundMessageAction);
}
