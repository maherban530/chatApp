import 'dart:io';
import 'dart:math' as math;

import 'package:chat_app/Widgets/receiver_message_card.dart';
import 'package:chat_app/Widgets/sender_message_card.dart';
import 'package:chat_app/Widgets/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
                  .getChatId()),
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

class MessageList extends StatefulWidget {
  const MessageList({super.key});

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> with WidgetsBindingObserver {
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

  // late AuthProvider _appProvider;

  // @override
  // void initState() async {
  //   WidgetsBinding.instance.addObserver(this);
  //   _appProvider = Provider.of<AuthProvider>(context, listen: false);
  //   // _appProvider.updateUserStatus("Online");
  //   // var messagesModel =
  //   //     _appProvider.getMessagesListData(chatId: _appProvider.getChatId());
  //   Provider.of<List<MessagesModel>?>(context)!.map((event) {
  //     _appProvider.updatePeerUserRead(
  //         _appProvider.getChatId(), event.docId, true);
  //   });

  //   // updatePeerDevice(Provider.of<MyProvider>(context,listen: false).auth.currentUser!.email, Provider.of<MyProvider>(context,listen: false).peerUserData!["email"]);
  //   super.initState();
  // }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  // }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   // _appProvider.updateUserStatus(FieldValue.serverTimestamp());
  //   // updatePeerDevice(_appProvider.auth.currentUser!.email, "0");
  //   super.dispose();
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   switch (state) {
  //     case AppLifecycleState.paused:
  //       // _appProvider.updateUserStatus(FieldValue.serverTimestamp());
  //       // updatePeerDevice(Provider.of<MyProvider>(context,listen: false).auth.currentUser!.email, "0");
  //       break;
  //     case AppLifecycleState.inactive:
  //       // _appProvider.updateUserStatus(FieldValue.serverTimestamp());
  //       // updatePeerDevice(Provider.of<MyProvider>(context,listen: false).auth.currentUser!.email, "0");
  //       break;
  //     case AppLifecycleState.detached:
  //       // _appProvider.updateUserStatus(FieldValue.serverTimestamp());
  //       // updatePeerDevice(Provider.of<MyProvider>(context,listen: false).auth.currentUser!.email, "0");
  //       break;
  //     case AppLifecycleState.resumed:
  //       // _appProvider.updateUserStatus("Online");
  //       // _appProvider.updatePeerUserRead(_appProvider.getChatId(), true);
  //       // updatePeerDevice(Provider.of<MyProvider>(context,listen: false).auth.currentUser!.email, Provider.of<MyProvider>(context,listen: false).peerUserData!["email"]);
  //       break;
  //   }
  //   super.didChangeAppLifecycleState(state);
  // }

  bool isScrollVisible = false;
  final scrollController = ScrollController();

  // @override
  // void initState() {
  //   super.initState();

  //   scrollController.addListener(() {
  //     if (scrollController.position.atEdge) {
  //       if (scrollController.position.pixels > 0) {
  //         if (isScrollVisible) {
  //           setState(() {
  //             isScrollVisible = false;
  //           });
  //         }
  //       }
  //     } else {
  //       if (!isScrollVisible) {
  //         setState(() {
  //           isScrollVisible = true;
  //         });
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    List<MessagesModel>? messagesList =
        Provider.of<List<MessagesModel>?>(context);
    var provider = Provider.of<AuthProvider>(context, listen: false);
    Provider.of<AuthProvider>(context, listen: true).updatePeerUserRead(
        Provider.of<AuthProvider>(context, listen: false).getChatId(), true);
    return messagesList == null
        ? const Center(child: CircularProgressIndicator())
        : messagesList.isEmpty
            ? const Center(child: Text("Messages Not Found"))
            : Stack(
                children: [
                  NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification notification) {
                      if (notification.metrics.pixels == 0.0) {
                        setState(() {
                          isScrollVisible = false;
                        });
                      } else {
                        setState(() {
                          isScrollVisible = true;
                        });
                      }
                      //   // if (notification.direction == ScrollDirection.idle ||
                      //   //     notification.direction.index != 1) {
                      //   //   setState(() {
                      //   //     isScrollVisible = true;
                      //   //   });
                      //   // }
                      //   //else {
                      //   //   // setState(() {
                      //   //   //   isScrollVisible = false;
                      //   //   // });
                      //   // }
                      // }
                      return true;
                    },
                    child: ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        controller: scrollController,
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
                              child: SenderMessageCard(messages
                                  // messages.fileName,
                                  // messages.msgType.toString(),
                                  // messages.message.toString(),
                                  // messages.msgTime == null
                                  //     ? DateFormat('dd-MM-yyyy hh:mm a').format(
                                  //         DateTime.parse(Timestamp.now()
                                  //             .toDate()
                                  //             .toString()))
                                  //     : DateFormat('dd-MM-yyyy hh:mm a').format(
                                  //         DateTime.parse(messages.msgTime!
                                  //             .toDate()
                                  //             .toString())),
                                  ),
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
                                          DateTime.parse(Timestamp.now()
                                              .toDate()
                                              .toString()))
                                      : DateFormat('dd-MM-yyyy hh:mm a').format(
                                          DateTime.parse(messages.msgTime!
                                              .toDate()
                                              .toString()))),
                            );
                          }
                        }),
                  ),
                  // ),
                  Positioned(
                    bottom: 20, right: 18,
                    // alignment: Alignment.bottomRight,
                    child: Visibility(
                      visible: isScrollVisible,
                      child: InkWell(
                        // radius: 34,
                        // splashRadius: 50,
                        splashColor: Colors.grey,
                        highlightColor: Colors.grey,
                        // color: Colors.red,
                        overlayColor: MaterialStateProperty.all(Colors.grey),
                        // child: Transform.rotate(
                        //   angle: 280 * math.pi / 186,
                        child: const Icon(
                          Icons.expand_circle_down_rounded,
                          // chevron_left,
                          color: Colors.black,
                          size: 38,
                        ),
                        // ),
                        // const Icon(Icons.expand_circle_down_rounded,
                        //     color: Colors.black, size: 38),
                        onTap: () {
                          // provider.
                          scrollController.jumpTo(
                            scrollController.position.minScrollExtent,
                          );

                          // scrollController.animateTo(
                          //   messagesList.length.toDouble(),
                          //   duration: const Duration(milliseconds: 100),
                          //   curve: Curves.easeInOut,
                          // );
                        },
                      ),
                    ),
                  ),
                ],
              );
  }
}
