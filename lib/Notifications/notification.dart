import 'dart:convert';
import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../Models/notification_model.dart';
import '../Provider/shared_prafrence.dart';
import 'package:http/http.dart' as http;

const String _serverToken =
    "AAAAqg87FIg:APA91bEQEPcHmWOpx-VT40TyoyXPXfwo-6JIBwnRHiXby3Z4rOjfotfVu6U-daglXUDVdR40GYPM5B7oO2RFwiJ0gNjBP54nQEuCKtNzRw8c3WvF-gfH8dHn-E1Zqop31uQ60OC-gDZp";

Future<void> notificationInitialization() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

void notificationCallInitialization() {
  AwesomeNotifications().initialize(null, [
    // notification icon
    NotificationChannel(
      channelGroupKey: 'Call notifications',
      channelKey: 'Calling',
      channelName: 'Call notifications',
      channelDescription: 'Notification channel for calling',
      channelShowBadge: true,
      importance: NotificationImportance.High,
      enableVibration: true,
    ),
  ]);
}

Future<void> uploadingNotification(fileType, receiverName, maxProgress, progress
    // isUploading
    ) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // if (isUploading) {
  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          "uploading files", "Uploading Files Notifications",
          channelDescription: "show to user progress for uploading files",
          channelShowBadge: false,
          importance: Importance.max,
          priority: Priority.high,
          onlyAlertOnce: true,
          showProgress: progress != maxProgress ? true : false,
          maxProgress: maxProgress,
          progress: progress,
          autoCancel: false);

  NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    5,
    '${progress != maxProgress ? 'Sending' : 'Send Successful'} $fileType to $receiverName',
    '',
    platformChannelSpecifics,
  );

  // } else {
  //   flutterLocalNotificationsPlugin.cancel(5);
  //   AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       const AndroidNotificationDetails(
  //     "files",
  //     "Files Notifications",
  //     channelDescription: "Inform user files uploaded",
  //     channelShowBadge: false,
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     onlyAlertOnce: true,
  //   );

  //   NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.show(
  //     Random().nextInt(1000000),
  //     '$fileType sent to $receiverName',
  //     '',
  //     platformChannelSpecifics,
  //   );
  // }
}

Future<void> downloadingNotification(
    maxProgress, progress, isDownloaded) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  if (!isDownloaded) {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            "downloading files", "downloading Files Notifications",
            channelDescription: "show to user progress for downloading files",
            channelShowBadge: false,
            importance: Importance.max,
            priority: Priority.high,
            onlyAlertOnce: true,
            showProgress: true,
            maxProgress: maxProgress,
            progress: progress,
            autoCancel: false);

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      6,
      'Downloading file',
      '',
      platformChannelSpecifics,
    );
  } else {
    flutterLocalNotificationsPlugin.cancel(6);
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      "files",
      "Files Notifications",
      channelDescription: "Inform user files downloaded",
      channelShowBadge: false,
      importance: Importance.max,
      priority: Priority.high,
      onlyAlertOnce: true,
    );

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      Random().nextInt(1000000),
      'File Downloaded',
      '',
      platformChannelSpecifics,
    );
  }
}

Future<void> messageHandler(RemoteMessage message) async {
  NotificationMessage notificationMessage =
      NotificationMessage.fromJson(message.data);
  if (notificationMessage.data!.title!.isEmpty) {
    setId(notificationMessage.data!.peerUserId);
    setEmail(notificationMessage.data!.peeredEmail);
    setName(notificationMessage.data!.peeredName);
    setCallType(notificationMessage.data!.callType);

    sendCallNotification(notificationMessage.data!.message);
  } else {
    messageNotification(
        notificationMessage.data!.title, notificationMessage.data!.message);
  }
}

void firebaseMessagingListener() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    NotificationMessage notificationMessage =
        NotificationMessage.fromJson(message.data);
    if (notificationMessage.data!.title!.isEmpty) {
      setId(notificationMessage.data!.peerUserId);
      setName(notificationMessage.data!.peeredName);
      setEmail(notificationMessage.data!.peeredEmail);
      setCallType(notificationMessage.data!.callType);

      sendCallNotification(notificationMessage.data!.message);
    } else {
      messageNotification(
          notificationMessage.data!.title, notificationMessage.data!.message);
    }
  });
}

Future<void> messageNotification(title, body) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          "message notification", "Messages Notifications",
          channelDescription: "show message to user",
          channelShowBadge: false,
          importance: Importance.max,
          priority: Priority.high,
          onlyAlertOnce: true,
          showProgress: true,
          autoCancel: false);

  NotificationDetails platformChannelSpecifics =
      const NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    Random().nextInt(1000000000),
    title,
    body,
    platformChannelSpecifics,
  );
}

void sendNotification(
    String title, String message, String fcmToken, String chatId) async {
  var response = await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$_serverToken',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body': message,
          // AwesomeNotifications().createNotification(
          //     content: NotificationContent(
          //       id: 123,
          //       channelKey: 'Calling',
          //       title: title,
          //       body: message,
          //       autoDismissible: true,
          //     ),
          //     actionButtons: [
          //       NotificationActionButton(
          //         key: "Answer",
          //         label: "Answer",
          //       ),
          //       NotificationActionButton(
          //           key: "Cancel", label: "Cancel", color: Colors.red)
          //     ]),
          'title': title,
        },
        "android": {
          "notification": {
            "channel_id": "fcm_default_channel",
            'sound': 'default'
          },
        },
        /*     "apns": {
            "payload": {
              "aps": {"sound": soundFile}
            }
          },*/
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          "channel_id": 'fcm_default_channel',
          'chat_id': chatId
        },
        'to': fcmToken,
      },
    ),
  );
  print(response.statusCode);
}

Future<void> sendCallNotification(message) async {
  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    //no permission of local notification
    AwesomeNotifications().requestPermissionToSendNotifications();
  } else {
    //show notification
    AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 123,
          channelKey: 'Calling',
          title: '',
          body: message,
          autoDismissible: true,
        ),
        actionButtons: [
          NotificationActionButton(
            key: "Answer",
            label: "Answer",
          ),
          NotificationActionButton(
              key: "Cancel", label: "Cancel", color: Colors.red)
        ]);
  }
}
