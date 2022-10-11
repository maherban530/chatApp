import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/last_message_model.dart';
import '../Models/messages_model.dart';

class LastMessageWidget extends StatelessWidget {
  const LastMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // LastMessageModel? lastMessage = Provider.of<LastMessageModel?>(context);
    Iterable<MessagesModel>? lastMessage =
        Provider.of<Iterable<MessagesModel>?>(context);
    if (lastMessage == null || lastMessage.isEmpty) {
      return Container();
    } else {
      return Text("${lastMessage.first.senderId}: ${lastMessage.first.msgType}",
          style: const TextStyle(fontSize: 13));
    }
  }
}
