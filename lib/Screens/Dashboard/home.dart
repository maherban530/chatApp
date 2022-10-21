import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Core/route_path.dart';
import '../../Core/theme.dart';
import '../../Models/messages_model.dart';
import '../../Models/user_model.dart';
import '../../Provider/auth_provider.dart';
import '../../Provider/theme_provider.dart';
import '../../Utils/constants.dart';

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
            // style: applicationTheme.textButtonTheme.style,
            onPressed: () {
              _showDialog(context);
            },
            icon: const Icon(
              Icons.lightbulb,
              color: ApplicationColors.backgroundLight,
            ),
          ),
          IconButton(
            onPressed: () {
              final provider =
                  Provider.of<AuthProvider>(context, listen: false);
              provider.logOut();
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.signup,
              );
            },
            icon: const Icon(
              Icons.logout,
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
                                                        .getUserDetalsWithId(
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

void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final theamChanger = Provider.of<ThemeChanger>(context);
      ThemeData applicationTheme = Theme.of(context);

      return AlertDialog(
        backgroundColor: applicationTheme.scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        titlePadding: EdgeInsets.zero,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                splashRadius: 20,
                icon: Icon(Icons.close, color: applicationTheme.primaryColor),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Select Theme",
                  style: applicationTheme.textTheme.bodyText1,
                ),
              ],
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RadioListTile<ThemeMode>(
              title: Text("System Theme",
                  style: applicationTheme.textTheme.subtitle1),
              activeColor: applicationTheme.primaryColor,
              value: ThemeMode.system,
              groupValue: theamChanger.theamMode,
              onChanged: theamChanger.setTheme,
            ),
            RadioListTile<ThemeMode>(
              title: Text(
                "Light Theme",
                style: applicationTheme.textTheme.subtitle1,
              ),
              activeColor: applicationTheme.primaryColor,
              value: ThemeMode.light,
              groupValue: theamChanger.theamMode,
              onChanged: theamChanger.setTheme,
            ),
            RadioListTile<ThemeMode>(
              title: Text(
                "Dark Theme",
                style: applicationTheme.textTheme.subtitle1,
              ),
              activeColor: applicationTheme.primaryColor,
              value: ThemeMode.dark,
              groupValue: theamChanger.theamMode,
              onChanged: theamChanger.setTheme,
            ),
          ],
        ),
        // actions: <Widget>[
        //   ElevatedButton(
        //     child: const Text("OK"),
        //     onPressed: () {

        //       Navigator.of(context).pop();
        //     },
        //   ),
        // ],
      );
    },
  );
}
