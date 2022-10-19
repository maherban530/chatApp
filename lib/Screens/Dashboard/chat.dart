import 'package:chat_app/Provider/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/messages_model.dart';
import '../../Widgets/last_seen_chat.dart';
import '../../Widgets/message_compose.dart';
import '../../Widgets/messages.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> with WidgetsBindingObserver {
  late AuthProvider _appProvider;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _appProvider = Provider.of<AuthProvider>(context, listen: false);
    _appProvider.updateUserStatus("Online");
    _appProvider.updatePeerUserRead(_appProvider.getChatId(), true);
    // updatePeerDevice(Provider.of<MyProvider>(context,listen: false).auth.currentUser!.email, Provider.of<MyProvider>(context,listen: false).peerUserData!["email"]);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _appProvider.updatePeerUserRead(_appProvider.getChatId(), true);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _appProvider.updateUserStatus(
      Timestamp.now(),
    );
    _appProvider.updatePeerUserRead(_appProvider.getChatId(), true);

    // updatePeerDevice(_appProvider.auth.currentUser!.email, "0");
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        _appProvider.updateUserStatus(
          Timestamp.now(),
        );
        _appProvider.updatePeerUserRead(_appProvider.getChatId(), true);

        // updatePeerDevice(Provider.of<MyProvider>(context,listen: false).auth.currentUser!.email, "0");
        break;
      case AppLifecycleState.inactive:
        _appProvider.updateUserStatus(
          Timestamp.now(),
        );
        _appProvider.updatePeerUserRead(_appProvider.getChatId(), true);

        // updatePeerDevice(Provider.of<MyProvider>(context,listen: false).auth.currentUser!.email, "0");
        break;
      case AppLifecycleState.detached:
        _appProvider.updateUserStatus(
          Timestamp.now(),
        );
        _appProvider.updatePeerUserRead(_appProvider.getChatId(), true);
        // updatePeerDevice(Provider.of<MyProvider>(context,listen: false).auth.currentUser!.email, "0");
        break;
      case AppLifecycleState.resumed:
        _appProvider.updateUserStatus("Online");
        _appProvider.updatePeerUserRead(_appProvider.getChatId(), true);
        // _appProvider.updatePeerUserRead(_appProvider.getChatId(), true);
        // updatePeerDevice(Provider.of<MyProvider>(context,listen: false).auth.currentUser!.email, Provider.of<MyProvider>(context,listen: false).peerUserData!["email"]);
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData applicationTheme = Theme.of(context);

    return Scaffold(
        // backgroundColor: applicationTheme.backgroundColor,
        appBar: AppBar(
          leadingWidth: 20,
          title: Row(
            children: [
              Provider.of<AuthProvider>(context, listen: false)
                      .peerUserData!
                      .userPic!
                      .isEmpty
                  ? CircleAvatar(
                      radius: 22,
                      backgroundColor: applicationTheme.primaryColor,
                      backgroundImage:
                          const AssetImage("assets/images/avatar.png"),
                    )
                  : CircleAvatar(
                      radius: 22,
                      backgroundColor: applicationTheme.primaryColor,
                      backgroundImage: NetworkImage(
                          Provider.of<AuthProvider>(context, listen: false)
                              .peerUserData!
                              .userPic
                              .toString()),
                    ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      Provider.of<AuthProvider>(context, listen: false)
                          .peerUserData!
                          .name
                          .toString(),
                      style: const TextStyle(
                          fontSize: 18.5, fontWeight: FontWeight.bold)),
                  const LastSeenChat(),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  // notifyUserWithCall("Calling from ${Provider.of<MyProvider>(context,listen: false).auth.currentUser!.displayName}",
                  //   Provider.of<MyProvider>(context,listen: false).peerUserData!["email"],
                  //   Provider.of<MyProvider>(context,listen: false).peerUserData!["userId"],
                  //   Provider.of<MyProvider>(context,listen: false).peerUserData!["name"],
                  //   "video"
                  // );
                  // Navigator.pushNamed(context, 'video_call');
                },
                icon: const Icon(Icons.videocam)),
            IconButton(
              onPressed: () {
                // notifyUserWithCall("Calling from ${Provider.of<MyProvider>(context,listen: false).auth.currentUser!.displayName}",
                //     Provider.of<MyProvider>(context,listen: false).peerUserData!["email"],
                //     Provider.of<MyProvider>(context,listen: false).peerUserData!["userId"],
                //     Provider.of<MyProvider>(context,listen: false).peerUserData!["name"],
                //     "audio"
                // );
                // Navigator.pushNamed(context, 'audio_call');
              },
              icon: const Icon(Icons.call),
            ),
          ],
        ),
        body: Column(
          children: const [
            Expanded(
              child: Messages(),
            ),
            MessagesCompose(),
          ],
        ));
  }
}
