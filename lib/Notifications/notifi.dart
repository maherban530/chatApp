// import 'dart:convert';
// import 'dart:io';
// import 'package:chat_app/Provider/auth_provider.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';

// class PushNotificationService {
//   AuthProvider? _userProvider;
//   final FirebaseMessaging _fcm = FirebaseMessaging.instance;
//   final String _serverToken =
//       "AAAAqg87FIg:APA91bEQEPcHmWOpx-VT40TyoyXPXfwo-6JIBwnRHiXby3Z4rOjfotfVu6U-daglXUDVdR40GYPM5B7oO2RFwiJ0gNjBP54nQEuCKtNzRw8c3WvF-gfH8dHn-E1Zqop31uQ60OC-gDZp";
//   NotificationAppLaunchDetails? notificationAppLaunchDetails;
//   initialize(BuildContext context) {
//     _userProvider = Provider.of<AuthProvider>(context, listen: false);
//     if (Platform.isIOS) {
//       _fcm.requestPermission(sound: true, alert: true);
//     }
//     FirebaseMessaging.onMessage.listen((event) {
//       RemoteMessage message = event;

//       if (_userProvider!.currentUserId == null || message.data['currentUserId'] != _userProvider!.currentUserId) {
//         showLocalNotification(message);
//       }
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen((event) {
//       print("OnLaunch : $event");
//     });
// /*    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);*/
//   }

//   void startFcm(BuildContext context) async {
//     final userProvider = Provider.of<AuthProvider>(context, listen: false);
//     userProvider.updateFcm(await _fcm.getToken());
//     _fcm.onTokenRefresh.listen((event) async {
//       userProvider.updateFcm(await _fcm.getToken());
//     });

//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
//     var initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher');
//     // var initializationSettingsIOS = IOSInitializationSettings(
//     //     requestAlertPermission: true,
//     //     requestBadgePermission: false,
//     //     requestSoundPermission: true,
//     //     onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {});
//     var initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onDidReceiveBackgroundNotificationResponse: onSelectLocalNotification);
//   }

//   void onSelectLocalNotification(String? payload) async {
//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     if (payload != null && payload != "") {
//       var response = json.decode(payload);
//       if (Platform.isAndroid) {
//         handleAndroidNotification(response);
//         flutterLocalNotificationsPlugin.cancel(int.parse(response['data']['notification_id'] ?? "10"));
//       } else {
//         handleIosNotification(response);
//         flutterLocalNotificationsPlugin.cancel(int.parse(response['notification_id']));
//       }
//     }
//   }

//   void showLocalNotification(RemoteMessage message) async {
//     String title;
//     String body;
//     String channelId;
//     Map<dynamic, dynamic> response;
//     if (Platform.isAndroid) {
//       title = message.notification!.title!;
//       body = message.notification!.body!;
//       channelId = message.data['channel_id'];
//       response = {
//         'notification': {
//           'title': title,
//           'body': body,
//         },
//         'data': {'channel_id': channelId}
//       };
//     } else {
//       title = message.notification!.title!;
//       body = message.notification!.body!;
//       channelId = message.data['channel_id'];
//       response = {
//         'aps': {
//           'alert': {
//             'title': title,
//             'body': body,
//           },
//         },
//         'data': {'channel_id': channelId}
//       };
//     }
//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     await createNotificationChannel(channelId);
//     var androidPlatformChannelSpecifics = AndroidNotificationDetails(channelId, channelId,
//         priority: Priority.max,
//         enableVibration: true,
//         importance: Importance.max,
//         // largeIcon: FilePathAndroidBitmap(largeIconPath),
//         // sound: RawResourceAndroidNotificationSound(soundName),
//         playSound: true,
//         styleInformation: BigTextStyleInformation(body,
//             //  htmlFormatBigText: true,
//             contentTitle: title,
//             htmlFormatBigText: true,
//             htmlFormatContentTitle: false,
//             htmlFormatSummaryText: false));
//     IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails(presentAlert: true, presentSound: true);
//     flutterLocalNotificationsPlugin.show(10, title, body,
//         NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics),
//         payload: json.encode(response));
//   }

//   Future<void> createNotificationChannel(String channelID) async {
//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     var androidNotificationChannel = AndroidNotificationChannel(
//       channelID,
//       'ArriveChannel',
//       showBadge: true,
//       importance: Importance.max,
//       playSound: true,
//     );
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(androidNotificationChannel);
//   }

//   handleAndroidNotification(Map response) {}
//   handleIosNotification(Map response) {}
//   void sendNotification(String title, String message, String fcmToken, String chatId) async {
//     var response = await http.post(
//       Uri.parse('https://fcm.googleapis.com/fcm/send'),
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//         'Authorization': 'key=$_serverToken',
//       },
//       body: jsonEncode(
//         <String, dynamic>{
//           'notification': <String, dynamic>{
//             'body': message,
//             'title': title,
//           },
//           "android": {
//             "notification": {"channel_id": "fcm_default_channel", 'sound': 'default'},
//           },
//           /*     "apns": {
//             "payload": {
//               "aps": {"sound": soundFile}
//             }
//           },*/
//           'priority': 'high',
//           'data': <String, dynamic>{
//             'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//             "channel_id": 'fcm_default_channel',
//             'chat_id': chatId
//           },
//           'to': fcmToken,
//         },
//       ),
//     );
//     print(response.statusCode);
//   }
// }
