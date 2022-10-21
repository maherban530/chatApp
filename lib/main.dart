import 'package:chat_app/Provider/theme_provider.dart';
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
      child: Builder(builder: (context) {
        final theamChanger = Provider.of<ThemeChanger>(context);
        return MaterialApp(
          title: 'ChatApp',
          themeMode: theamChanger.theamMode,
          theme: ChatAppTheme.lightTheme,
          // ThemeData(
          //   brightness: Brightness.light,
          //   primaryColor: Colors.teal,
          //   primarySwatch: Colors.teal,
          //   cardColor: Colors.blueGrey.withOpacity(0.1),
          //   textTheme: const TextTheme(
          //     headline3: TextStyle(
          //         fontFamily: 'Bold', fontSize: 20.0, color: Colors.black),
          //     headline4: TextStyle(
          //         fontFamily: 'Bold', fontSize: 18.0, color: Color(0xff25292B)),
          //     headline5: TextStyle(
          //         fontFamily: 'Bold', fontSize: 16.0, color: Color(0xff25292B)),
          //     headline6: TextStyle(
          //         fontFamily: 'Bold', fontSize: 14.0, color: Color(0xff25292B)),
          //     bodyText1: TextStyle(
          //         fontFamily: 'Regular',
          //         fontSize: 12.0,
          //         color: Color(0xff25292B)),
          //     bodyText2: TextStyle(
          //         fontFamily: 'Regular',
          //         fontSize: 10.0,
          //         color: Color(0xff25292B)),
          //   ),
          //   iconTheme: IconThemeData(color: Colors.grey.shade600),
          // ),
          darkTheme: ChatAppTheme.darkTheme,
          // ThemeData(
          //     brightness: Brightness.dark,
          //     primaryColor: Colors.blueGrey,
          //     cardColor: Colors.black.withOpacity(0.3),
          //     textTheme: const TextTheme(
          //       headline3: TextStyle(
          //           fontFamily: 'Bold', fontSize: 20.0, color: Colors.white),
          //       headline4: TextStyle(
          //           fontFamily: 'Bold', fontSize: 18.0, color: Colors.white),
          //       headline5: TextStyle(
          //           fontFamily: 'Bold', fontSize: 16.0, color: Colors.white),
          //       headline6: TextStyle(
          //           fontFamily: 'Bold', fontSize: 14.0, color: Colors.white),
          //       bodyText1: TextStyle(
          //           fontFamily: 'Regular', fontSize: 12.0, color: Colors.white),
          //       bodyText2: TextStyle(
          //           fontFamily: 'Regular', fontSize: 10.0, color: Colors.white),
          //     ),
          //     iconTheme: const IconThemeData(color: Colors.grey)),
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.splash,
          routes: routes.route,
        );
      }),
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
