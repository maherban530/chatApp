import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chat_app/Provider/auth_provider.dart';
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
import 'Provider/shared_prafrence.dart';
import 'Screens/Dashboard/call_check.dart';
import 'Widgets/utils.dart';

Future<void> main() async {
  _initializeFirebase();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // StreamSubscription<ReceivedAction>? _actionStreamSubscription;
  // bool subscribedActionStream = false;

  @override
  void initState() {
    super.initState();
    // listen();
    // if (!subscribedActionStream) {
    // AwesomeNotifications().setListeners(
    //   onActionReceivedMethod: onActionReceivedMethod,
    //   // NotificationController.onActionReceivedMethod,
    //   // onNotificationCreatedMethod:    NotificationController.onNotificationCreatedMethod,
    //   // onNotificationDisplayedMethod:  NotificationController.onNotificationDisplayedMethod,
    //   // onDismissActionReceivedMethod:  NotificationController.onDismissActionReceivedMethod
    // );
    // AwesomeNotifications().actionStream.listen((action) {
    //   if (action.buttonKeyPressed == "Answer") {
    //     getCallType().then((value) {
    //       MyApp.navigatorKey.currentState?.push(
    //           MaterialPageRoute(builder: (context) => CallScreen(value)));
    //     });
    //   } else if (action.buttonKeyPressed == "Cancel") {
    //     Provider.of<AuthProvider>(MyApp.navigatorKey.currentState!.context,
    //             listen: false)
    //         .updateCallStatus("false");
    //     cancelCall(context, "You cancel the call");
    //   }
    // });
    //   subscribedActionStream = true;
    // }
  }

  // static Future<void> onActionReceivedMethod(ReceivedAction action) async {
  //   if (action.buttonKeyPressed == "Answer") {
  //     getCallType().then((value) {
  //       MyApp.navigatorKey.currentState
  //           ?.push(MaterialPageRoute(builder: (context) => CallScreen(value)));

  //       // Get.off(CallScreen(value));
  //     });
  //   } else if (action.buttonKeyPressed == "Cancel") {
  //     Provider.of<AuthProvider>(MyApp.navigatorKey.currentState!.context,
  //             listen: false)
  //         .updateCallStatus("false");
  //     cancelCall(
  //         MyApp.navigatorKey.currentState!.context, "You cancel the call");
  //   }
  // }

  // void listen() async {
  //   // You can choose to cancel any exiting subscriptions
  //   await _actionStreamSubscription?.cancel();
  //   // assign the stream subscription
  //   // _actionStreamSubscription = AwesomeNotifications().actionStream.listen((message) {
  //   // //   // handle stuff here
  //   // });
  // }

  @override
  void dispose() async {
    // Future.delayed(Duration.zero, () async {
    //   await _actionStreamSubscription?.cancel();
    // });
    super.dispose();
  }

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
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await notificationInitialization();
  FirebaseMessaging.onBackgroundMessage(messageHandler);
  notificationCallInitialization();
  firebaseMessagingListener();
  // await notificationInitialize();

  // await FirebaseMessaging.instance.setAutoInitEnabled(true);

  // /// For Background Message Handling
  // FirebaseMessaging.onBackgroundMessage(backgroundMsgAction);

  // /// For Foreground Message Handling
  // FirebaseMessaging.onMessage.listen(foregroundMessageAction);
}
