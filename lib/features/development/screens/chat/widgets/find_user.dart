// find friends to chat with

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindere/features/development/screens/chat/controllers/chat_controller.dart';
import 'package:remindere/features/development/screens/chat/widgets/chat_page.dart';

class FindUser extends StatelessWidget {
  // this helps build the list of possible users to chat with.
  const FindUser({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    ChatController controller = ChatController.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find User')
      ),
      body: InkWell(
        onTap: () {
          // Get.to(ChatPage(chat: chat));
          controller.getUsers('');
        },
        child: ListView(),
      )
    );
  }
}