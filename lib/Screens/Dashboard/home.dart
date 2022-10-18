import 'package:chat_app/Core/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Core/route_path.dart';
import '../../Models/last_message_model.dart';
import '../../Models/messages_model.dart';
import '../../Models/user_model.dart';
import '../../Provider/auth_provider.dart';
import '../../Widgets/last_message.dart';
import '../../Widgets/utils.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    ThemeData applicationTheme = Theme.of(context);

    return Scaffold(
      backgroundColor: applicationTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: ApplicationColors.yellowColor,
        actions: [
          TextButton.icon(
            style: applicationTheme.textButtonTheme.style,
            onPressed: () {
              final provider =
                  Provider.of<AuthProvider>(context, listen: false);
              provider.logOut();
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.signup,
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text("LogOut"),
          ),
        ],
      ),
      body: StreamProvider(
        create: (BuildContext context) =>
            Provider.of<AuthProvider>(context, listen: false).getUsersData(),
        initialData: null,
        // child: const UserList(),
        builder: (context, child) {
          return const UserList();
        },
      ),
    );
  }
}

class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    List<Users>? userList = Provider.of<List<Users>?>(context);
    var provider = Provider.of<AuthProvider>(context, listen: false);
    return userList == null
        ? const Center(child: CircularProgressIndicator())
        : userList.isEmpty
            ? const Center(child: Text("Users Not Found"))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: userList.length,
                itemBuilder: (_, int index) {
                  var users = userList[index];
                  return provider.currentUserId == users.uid
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: StreamBuilder<List<MessagesModel?>?>(
                              stream: Provider.of<AuthProvider>(context,
                                      listen: false)
                                  .getMessages(
                                      chatId: Provider.of<AuthProvider>(context,
                                              listen: false)
                                          .getLastMessageChatId(users.uid)),
                              builder: (context, snapshot1) {
                                return ListTile(
                                  // dense: true,
                                  tileColor: Colors.teal.shade50,
                                  leading: const Icon(
                                      // provider.currentUserId == users.uid
                                      //   ? Icons.account_circle
                                      //   :
                                      Icons.account_circle_outlined),
                                  title: Text(
                                    // provider.currentUserId == users.uid
                                    //   ? "You"
                                    //   :
                                    users.name.toString(),
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  subtitle:
                                      // if (snapshot1.connectionState ==
                                      //     ConnectionState.done) {
                                      snapshot1.data == null ||
                                              snapshot1.data!.isEmpty
                                          ? Container()
                                          :
                                          // } else {
                                          //   return
                                          StreamBuilder<Users?>(
                                              stream: Provider.of<AuthProvider>(
                                                      context,
                                                      listen: false)
                                                  .getUserDetalsWithId(snapshot1
                                                      .data!.first!.senderId),
                                              builder: (context, snapshot2) {
                                                if (snapshot2.data == null) {
                                                  return Container();
                                                } else {
                                                  var messageData =
                                                      snapshot1.data!.first!;
                                                  return Text(
                                                      "${messageData.senderId == Provider.of<AuthProvider>(context).currentUserId ? "Sent by You" : snapshot2.data!.phoneNumber}: ${getFileType(messageData)}",
                                                      style: const TextStyle(
                                                          fontSize: 13));
                                                }
                                              },
                                            ),

                                  trailing: snapshot1.data == null ||
                                          snapshot1.data!.isEmpty
                                      ? Container(width: 0)
                                      : users.uid ==
                                                  snapshot1.data!.first!
                                                      .receiverId ||
                                              snapshot1.data!
                                                  .where(
                                                      (i) => i!.isRead == false)
                                                  .isEmpty
                                          ? Container(width: 0)
                                          : Card(
                                              elevation: 1,
                                              color: Colors.teal,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 2,
                                                        horizontal: 6),
                                                child: Text(
                                                  snapshot1.data!
                                                      .where((i) =>
                                                          i!.isRead == false)
                                                      .length
                                                      .toString(),
                                                  // snapshot1.data!.contains(element).length.toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                  // }

                                  // trailing: StreamBuilder<List<MessagesModel?>?>(
                                  //   stream: Provider.of<AuthProvider>(context,
                                  //           listen: false)
                                  //       .getMessages(
                                  //           chatId: Provider.of<AuthProvider>(context,
                                  //                   listen: false)
                                  //               .getLastMessageChatId(users.uid)),
                                  //   builder: (context, snapshot1) {
                                  //     // if (snapshot1.connectionState ==
                                  //     //     ConnectionState.done) {
                                  //     if (snapshot1.data == null ||
                                  //         snapshot1.data!.isEmpty) {
                                  //       return Container();
                                  //     } else {
                                  //       return Text("${snapshot1.data!.length}",
                                  //           style: const TextStyle(fontSize: 13));
                                  //     }
                                  //   },
                                  // ),

                                  // StreamProvider(
                                  //   create: (BuildContext context) =>
                                  //       Provider.of<AuthProvider>(context,
                                  //               listen: false)
                                  //           .getMessages(
                                  //               chatId: Provider.of<AuthProvider>(
                                  //                       context,
                                  //                       listen: false)
                                  //                   .getLastMessageChatId(users.uid)),
                                  //   initialData: null,
                                  //   child: StreamProvider(
                                  //     create: (BuildContext context) => Provider.of<
                                  //             AuthProvider>(context, listen: false)
                                  //         .getUserDetalsWithId(
                                  //             Provider.of<Iterable<MessagesModel?>?>(
                                  //                         context,
                                  //                         listen: false)!
                                  //                     .first!
                                  //                     .senderId !=
                                  //                 null),
                                  //     initialData: null,
                                  //     child: const LastMesseWidget(),
                                  //   ),
                                  // ),
                                  onTap: () {
                                    // if (provider.currentUserId == users.uid) {
                                    //   buildShowSnackBar(context,
                                    //       "You can't send message to yourself");
                                    // } else {
                                    provider.usersClickListener(users, context);
                                    // }
                                  },
                                );
                              }),
                        );
                });
  }

  String getFileType(MessagesModel messageType) {
    switch (messageType.msgType) {
      case 'text':
        return messageType.message.toString();
      case 'image':
        return '📷 Photo';
      case 'voice message':
        return '🎧 Audio Record';
      case 'video':
        return '📸 Video';
      case 'document':
        return '📃 Document';
      case 'audio':
        return '🎵 Audio';
      default:
        return '';
    }
  }
}
