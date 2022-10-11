import 'dart:io';
import 'package:chat_app/Widgets/receiver_message_card.dart';
import 'package:chat_app/Widgets/sender_message_card.dart';
import 'package:chat_app/Widgets/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:full_chat_application/widget/receiver_message_card.dart';
// import 'package:full_chat_application/widget/sender_message_card.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../Models/messages_model.dart';
import '../Provider/auth_provider.dart';

// import '../Utils.dart';
// import '../notifications/notifications.dart';
// import '../provider/my_provider.dart';
// import '../firebase_helper/fireBaseHelper.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider(
      lazy: true,
      create: (BuildContext context) =>
          Provider.of<AuthProvider>(context, listen: false).getMessages(
              chatId: Provider.of<AuthProvider>(context, listen: false)
                  .getChatId(context)),
      initialData: null,
      child: const MessageList(),
    );
    //  StreamBuilder(
    //   stream:FireBaseHelper().getMessages(context,chatId: Provider.of<MyProvider>(context,listen: false).getChatId(context)),
    //   builder:(BuildContext context,
    //       AsyncSnapshot<QuerySnapshot> snapshot) {
    //     if (snapshot.hasError) {
    //       return const Text('Something went wrong try again');
    //     }
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     }

    //     return snapshot.data!.size == 0?
    //     Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: const [
    //         Center(child: Text('No messages')),
    //       ],
    //     ):
    //       ListView.builder(
    //           reverse: true,
    //           shrinkWrap: true ,
    //           itemCount: snapshot.data!.docs.length,
    //           itemBuilder: (context, index) {
    //             if (Provider.of<MyProvider>(context,listen: false).auth.currentUser!.uid
    //                 == snapshot.data!.docs[index]['senderId'].toString()) {
    //               return InkWell(
    //                  onTap: (){
    //                    if(snapshot.data!.docs[index]['msgType'].toString() == "document"||snapshot.data!.docs[index]['msgType'].toString() == "voice message"){
    //                      downloadFile(context,snapshot.data!.docs[index]['message'].toString(),snapshot.data!.docs[index]['fileName'].toString(),snapshot.data!.docs[index]['msgType'].toString());
    //                    }
    //                  },
    //                 child: SenderMessageCard(
    //                     snapshot.data!.docs[index]['fileName'].toString(),
    //                     snapshot.data!.docs[index]['msgType'].toString(),
    //                     snapshot.data!.docs[index]['message'].toString(),
    //                     snapshot.data!.docs[index]['msgTime']==null?
    //                     DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.parse(Timestamp.now().toDate().toString())):
    //                     DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.parse(snapshot.data!.docs[index]['msgTime'].toDate().toString()))
    //                 ),
    //               );
    //             } else {
    //               return InkWell(
    //                 onTap: (){
    //                   if(snapshot.data!.docs[index]['msgType'].toString() == "document"||snapshot.data!.docs[index]['msgType'].toString() == "voice message"){
    //                     downloadFile(context,snapshot.data!.docs[index]['message'].toString(),snapshot.data!.docs[index]['fileName'].toString(),snapshot.data!.docs[index]['msgType'].toString());
    //                   }
    //                 },
    //                 child: ReceiverMessageCard(
    //                     snapshot.data!.docs[index]['fileName'].toString(),
    //                     snapshot.data!.docs[index]['msgType'].toString(),
    //                     snapshot.data!.docs[index]['message'].toString(),
    //                     snapshot.data!.docs[index]['msgTime']==null?
    //                     DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.parse(Timestamp.now().toDate().toString())):
    //                     DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.parse(snapshot.data!.docs[index]['msgTime'].toDate().toString()))
    //                 ),
    //               );
    //             }
    //           });
    //   },
    // );
  }
}

class MessageList extends StatelessWidget {
  const MessageList({super.key});

  Future<void> downloadFile(context, fileUrl, fileName, fileType) async {
    Directory? appDocDir = await getApplicationDocumentsDirectory();
    final status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      Directory(appDocDir.path).exists().then((value) async {
        if (value) {
          isFileDownloaded(appDocDir.path, fileName)
              ? OpenFile.open("${appDocDir.path}/$fileName")
              : Dio().download(
                  fileUrl,
                  "${appDocDir.path}/$fileName",
                  onReceiveProgress: (count, total) {
                    //  downloadingNotification(total, count, false);
                  },
                ).whenComplete(() {
                  // downloadingNotification(0, 0, true);
                });
        } else {
          Directory(appDocDir.path).create().then((Directory directory) async {
            isFileDownloaded(appDocDir.path, fileName)
                ? OpenFile.open("${appDocDir.path}/$fileName")
                : Dio().download(
                    fileUrl,
                    "${appDocDir.path}/$fileName",
                    onReceiveProgress: (count, total) {
                      // downloadingNotification(total, count, false);
                    },
                  ).whenComplete(() {
                    // downloadingNotification(0, 0, true);
                  });
          });
        }
      });
    } else {
      await Permission.storage.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    Iterable<MessagesModel>? messagesList =
        Provider.of<Iterable<MessagesModel>?>(context);
    var provider = Provider.of<AuthProvider>(context, listen: false);

    return messagesList == null
        ? const Center(child: CircularProgressIndicator())
        : messagesList.isEmpty
            ? const Center(child: Text("Messages Not Found"))
            : ListView.builder(
                reverse: true,
                shrinkWrap: true,
                itemCount: messagesList.length,
                itemBuilder: (context, index) {
                  var messages = messagesList.toList()[index];
                  if (provider.currentUserId == messages.senderId) {
                    return InkWell(
                      onTap: () {
                        if (messages.msgType == "document" ||
                            messages.msgType == "voice message") {
                          downloadFile(context, messages.message,
                              messages.fileName, messages.msgType);
                        }
                      },
                      child: SenderMessageCard(
                          messages.fileName,
                          messages.msgType.toString(),
                          messages.message.toString(),
                          messages.msgTime == null
                              ? DateFormat('dd-MM-yyyy hh:mm a').format(
                                  DateTime.parse(
                                      Timestamp.now().toDate().toString()))
                              : DateFormat('dd-MM-yyyy hh:mm a').format(
                                  DateTime.parse(
                                      messages.msgTime!.toDate().toString()))),
                    );
                  } else {
                    return InkWell(
                      onTap: () {
                        if (messages.msgType == "document" ||
                            messages.msgType == "voice message") {
                          downloadFile(context, messages.message,
                              messages.fileName, messages.msgType);
                        }
                      },
                      child: ReceiverMessageCard(
                          messages.fileName,
                          messages.msgType.toString(),
                          messages.message.toString(),
                          messages.msgTime == null
                              ? DateFormat('dd-MM-yyyy hh:mm a').format(
                                  DateTime.parse(
                                      Timestamp.now().toDate().toString()))
                              : DateFormat('dd-MM-yyyy hh:mm a').format(
                                  DateTime.parse(
                                      messages.msgTime!.toDate().toString()))),
                    );
                  }
                });
  }
}
