import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/last_message_model.dart';

class LastMessageWidget extends StatelessWidget {
  const LastMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    LastMessageModel? lastMessage = Provider.of<LastMessageModel?>(context);

    if (lastMessage == null) {
      return Container();
    } else {
      return Text(lastMessage.lastMessage.toString(),
          style: const TextStyle(fontSize: 13));
    }
  }
}
