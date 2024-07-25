import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindere/features/development/screens/chat/widgets/chat_screen.dart';
import 'package:remindere/features/development/screens/chat/widgets/find_user.dart';
import 'package:remindere/utils/constants/sizes.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chat'),
          centerTitle: true,
        ),
        body: SafeArea(
            child: Column(children: [
          // Find Users screen
          InkWell(
              onTap: () {
                Get.to(const FindUser());
              },
              radius: RSizes.appBarHeight,
              child: const SizedBox(
                  height: RSizes.appBarHeight,
                  width: RSizes.buttonWidth,
                  child: Center(child: Text('Find User')))),

          // Open chats
          const RChatScreen()
        ])));
  }
}
