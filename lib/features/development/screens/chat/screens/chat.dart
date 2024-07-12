import 'package:flutter/material.dart';
import 'package:remindere/features/development/screens/chat/widgets/chat_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chat'),
          centerTitle: true,
        ),
        backgroundColor: Colors.yellow,
        body: const SafeArea(
          child: Column(
              children: [
                RChatScreen(),
                // can add stuff if needed
              ]
            )
          )
        );
  }
}
