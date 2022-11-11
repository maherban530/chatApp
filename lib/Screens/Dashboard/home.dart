import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Core/route_path.dart';
import '../../Core/theme.dart';
import '../../Models/messages_model.dart';
import '../../Models/user_model.dart';
import '../../Notifications/notifi.dart';
import '../../Provider/auth_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // PushNotificationService().startFcm(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData applicationTheme = Theme.of(context);

    return Scaffold(
      // backgroundColor: applicationTheme.backgroundColor,
      appBar: AppBar(
        // backgroundColor: ApplicationColors.yellowColor,
        title: Text(
          'Chat App',
          style: applicationTheme.textTheme.bodyText1!
              .copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.setting,
              );
            },
            icon: const Icon(
              Icons.settings,
              color: ApplicationColors.backgroundLight,
            ),
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
    ThemeData applicationTheme = Theme.of(context);

    return userList == null
        ? Center(
            child: CircularProgressIndicator(
                color: applicationTheme.primaryColorLight))
        : userList.isEmpty
            ? Center(
                child: Text("Users Not Found",
                    style: applicationTheme.textTheme.bodySmall))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: userList.length,
                // separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (_, int index) {
                  var users = userList[index];
                  return provider.currentUserId == users.uid
                      ? const SizedBox.shrink()
                      : StreamBuilder<List<MessagesModel?>?>(
                          stream:
                              Provider.of<AuthProvider>(context, listen: false)
                                  .getMessages(
                                      chatId: Provider.of<AuthProvider>(context,
                                              listen: false)
                                          .getLastMessageChatId(users.uid)),
                          builder: (context, snapshot1) {
                            return InkWell(
                              onTap: () {
                                //     // if (provider.currentUserId == users.uid) {
                                //     //   buildShowSnackBar(context,
                                //     //       "You can't send message to yourself");
                                //     // } else {
                                provider.usersClickListener(users, context);
                                //     // }
                                //   },
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                child: Row(
                                  children: [
                                    users.userPic!.isEmpty
                                        ? const CircleAvatar(
                                            radius: 26,
                                            backgroundColor: ApplicationColors
                                                .transparentColor,
                                            backgroundImage: AssetImage(
                                                "assets/images/avatar.png"),
                                          )
                                        : CircleAvatar(
                                            radius: 26,
                                            backgroundColor: ApplicationColors
                                                .transparentColor,
                                            backgroundImage: NetworkImage(
                                                users.userPic.toString()),
                                          ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 2.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(users.name.toString(),
                                                maxLines: 1,
                                                softWrap: false,
                                                overflow: TextOverflow.ellipsis,
                                                style: applicationTheme
                                                    .textTheme.bodyText2),
                                            const SizedBox(height: 5),
                                            //       // if (snapshot1.connectionState ==
                                            //     ConnectionState.done) {
                                            snapshot1.data == null ||
                                                    snapshot1.data!.isEmpty
                                                ? Container()
                                                :
                                                // } else {
                                                //   return
                                                StreamBuilder<Users?>(
                                                    stream: Provider.of<
                                                                AuthProvider>(
                                                            context,
                                                            listen: false)
                                                        .getUserDetailsWithId(
                                                            snapshot1
                                                                .data!
                                                                .first!
                                                                .senderId),
                                                    builder:
                                                        (context, snapshot2) {
                                                      if (snapshot2.data ==
                                                          null) {
                                                        return Container();
                                                      } else {
                                                        var messageData =
                                                            snapshot1
                                                                .data!.first!;
                                                        return Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            messageData.senderId ==
                                                                    Provider.of<AuthProvider>(
                                                                            context)
                                                                        .currentUserId
                                                                ? messageData
                                                                        .isRead!
                                                                    ? Icon(
                                                                        Icons
                                                                            .done_all_rounded,
                                                                        color: applicationTheme
                                                                            .primaryColor,
                                                                        size:
                                                                            14,
                                                                      )
                                                                    : Icon(
                                                                        Icons
                                                                            .done_rounded,
                                                                        color: applicationTheme
                                                                            .textTheme
                                                                            .subtitle1!
                                                                            .color!
                                                                            .withOpacity(0.6),
                                                                        size:
                                                                            14,
                                                                      )
                                                                : Container(),
                                                            Flexible(
                                                              fit:
                                                                  FlexFit.loose,
                                                              child: Text(
                                                                getFileType(
                                                                    messageData),
                                                                // "${messageData.senderId == Provider.of<AuthProvider>(context).currentUserId ? "Sent by You" : snapshot2.data!.phoneNumber}: ${getFileType(messageData)}",
                                                                style: applicationTheme
                                                                    .textTheme
                                                                    .subtitle1,
                                                                maxLines: 1,
                                                                softWrap: false,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                    },
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    snapshot1.data == null ||
                                            snapshot1.data!.isEmpty
                                        ? Container(width: 0)
                                        : users.uid ==
                                                    snapshot1.data!.first!
                                                        .receiverId ||
                                                snapshot1.data!
                                                    .where((i) =>
                                                        i!.isRead == false)
                                                    .isEmpty
                                            ? Container(width: 0)
                                            : CircleAvatar(
                                                radius: 14,
                                                backgroundColor:
                                                    applicationTheme
                                                        .primaryColor,
                                                child: FittedBox(
                                                    fit: BoxFit.cover,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3.0),
                                                      child: Text(
                                                        snapshot1.data!
                                                            .where((i) =>
                                                                i!.isRead ==
                                                                false)
                                                            .length
                                                            .toString(),
                                                        style: applicationTheme
                                                            .textTheme
                                                            .subtitle1!
                                                            .copyWith(
                                                                color: ApplicationColors
                                                                    .backgroundLight),
                                                      ),
                                                    )),
                                              ),

                                    // }

                                    ///////////////
                                    // CircleAvatar(
                                    //   radius: 14,
                                    //   child: FittedBox(
                                    //       fit: BoxFit.cover, child: Text('10000')),
                                    // ),
                                  ],
                                ),
                              ),
                            );
                            // ListTile(
                            //   // dense: true,
                            //   // tileColor: Colors.teal.shade50,
                            //   // contentPadding: EdgeInsets.zero,
                            //   leading: CircleAvatar(
                            //     backgroundColor: applicationTheme.primaryColor,
                            //     backgroundImage: const AssetImage(
                            //         "assets/images/avatar.png"),
                            //     // child: Image.asset("assets/images/avatar.png"),
                            //   ),

                            //   title: Text(
                            //       // provider.currentUserId == users.uid
                            //       //   ? "You"
                            //       //   :
                            //       users.name.toString(),
                            //       maxLines: 1,
                            //       softWrap: false,
                            //       overflow: TextOverflow.ellipsis,
                            //       style: applicationTheme.textTheme.bodyText2

                            //       // const TextStyle(
                            //       //     fontSize: 15,
                            //       //     fontWeight: FontWeight.w600,
                            //       //     ),
                            //       ),
                            //   subtitle:
                            //       // if (snapshot1.connectionState ==
                            //       //     ConnectionState.done) {
                            //       snapshot1.data == null ||
                            //               snapshot1.data!.isEmpty
                            //           ? Container()
                            //           :
                            //           // } else {
                            //           //   return
                            //           StreamBuilder<Users?>(
                            //               stream: Provider.of<AuthProvider>(
                            //                       context,
                            //                       listen: false)
                            //                   .getUserDetalsWithId(snapshot1
                            //                       .data!.first!.senderId),
                            //               builder: (context, snapshot2) {
                            //                 if (snapshot2.data == null) {
                            //                   return Container();
                            //                 } else {
                            //                   var messageData =
                            //                       snapshot1.data!.first!;
                            //                   return Row(
                            //                     crossAxisAlignment:
                            //                         CrossAxisAlignment.start,
                            //                     children: [
                            //                       messageData.senderId ==
                            //                               Provider.of<AuthProvider>(
                            //                                       context)
                            //                                   .currentUserId
                            //                           ? messageData.isRead!
                            //                               ? const Icon(
                            //                                   Icons.done_all,
                            //                                   color:
                            //                                       Colors.teal,
                            //                                   // size: 14,
                            //                                 )
                            //                               : const Icon(
                            //                                   Icons.done,
                            //                                   color:
                            //                                       Colors.teal,
                            //                                   // size: 14,
                            //                                 )
                            //                           : Container(),
                            //                       Flexible(
                            //                         fit: FlexFit.loose,
                            //                         child: Text(
                            //                           getFileType(messageData),
                            //                           // "${messageData.senderId == Provider.of<AuthProvider>(context).currentUserId ? "Sent by You" : snapshot2.data!.phoneNumber}: ${getFileType(messageData)}",
                            //                           style: applicationTheme
                            //                               .textTheme.subtitle1,
                            //                           maxLines: 1,
                            //                           softWrap: false,
                            //                           overflow:
                            //                               TextOverflow.ellipsis,
                            //                         ),
                            //                       ),
                            //                     ],
                            //                   );
                            //                 }
                            //               },
                            //             ),

                            //   trailing: snapshot1.data == null ||
                            //           snapshot1.data!.isEmpty
                            //       ? Container(width: 0)
                            //       : users.uid ==
                            //                   snapshot1
                            //                       .data!.first!.receiverId ||
                            //               snapshot1.data!
                            //                   .where((i) => i!.isRead == false)
                            //                   .isEmpty
                            //           ? Container(width: 0)
                            //           : Container(
                            //               //  width: MediaQuery.of(context)
                            //               //          .size
                            //               //          .width *
                            //               //      0.6,
                            //               // height: MediaQuery.of(context)
                            //               //         .size
                            //               //         .height *
                            //               //     0.09,
                            //               decoration: const BoxDecoration(
                            //                 color: Colors.teal,
                            //                 shape: BoxShape.circle,
                            //               ),
                            //               // padding: const EdgeInsets.all(6),

                            //               // shape: RoundedRectangleBorder(
                            //               //   borderRadius:
                            //               //       BorderRadius.circular(20.0),
                            //               // ),

                            //               child: Text(
                            //                 '100',
                            //                 // snapshot1.data!
                            //                 //     .where(
                            //                 //         (i) => i!.isRead == false)
                            //                 //     .length
                            //                 //     .toString(),
                            //                 style: applicationTheme
                            //                     .textTheme.subtitle1!
                            //                     .copyWith(
                            //                         color: applicationTheme
                            //                             .scaffoldBackgroundColor),
                            //               ),
                            //             ),
                            //   // }

                            //   // trailing: StreamBuilder<List<MessagesModel?>?>(
                            //   //   stream: Provider.of<AuthProvider>(context,
                            //   //           listen: false)
                            //   //       .getMessages(
                            //   //           chatId: Provider.of<AuthProvider>(context,
                            //   //                   listen: false)
                            //   //               .getLastMessageChatId(users.uid)),
                            //   //   builder: (context, snapshot1) {
                            //   //     // if (snapshot1.connectionState ==
                            //   //     //     ConnectionState.done) {
                            //   //     if (snapshot1.data == null ||
                            //   //         snapshot1.data!.isEmpty) {
                            //   //       return Container();
                            //   //     } else {
                            //   //       return Text("${snapshot1.data!.length}",
                            //   //           style: const TextStyle(fontSize: 13));
                            //   //     }
                            //   //   },
                            //   // ),

                            //   // StreamProvider(
                            //   //   create: (BuildContext context) =>
                            //   //       Provider.of<AuthProvider>(context,
                            //   //               listen: false)
                            //   //           .getMessages(
                            //   //               chatId: Provider.of<AuthProvider>(
                            //   //                       context,
                            //   //                       listen: false)
                            //   //                   .getLastMessageChatId(users.uid)),
                            //   //   initialData: null,
                            //   //   child: StreamProvider(
                            //   //     create: (BuildContext context) => Provider.of<
                            //   //             AuthProvider>(context, listen: false)
                            //   //         .getUserDetalsWithId(
                            //   //             Provider.of<Iterable<MessagesModel?>?>(
                            //   //                         context,
                            //   //                         listen: false)!
                            //   //                     .first!
                            //   //                     .senderId !=
                            //   //                 null),
                            //   //     initialData: null,
                            //   //     child: const LastMesseWidget(),
                            //   //   ),
                            //   // ),
                            //   onTap: () {
                            //     // if (provider.currentUserId == users.uid) {
                            //     //   buildShowSnackBar(context,
                            //     //       "You can't send message to yourself");
                            //     // } else {
                            //     provider.usersClickListener(users, context);
                            //     // }
                            //   },
                            // );
                          });
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
