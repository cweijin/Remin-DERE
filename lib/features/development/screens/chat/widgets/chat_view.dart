import 'package:flutter/material.dart';
import 'package:remindere/common/styles/spacing_styles.dart';
import 'package:remindere/features/development/screens/chat/models/chat_model.dart';
import 'package:remindere/features/development/screens/chat/widgets/chat_icon.dart';

class ChatView extends StatelessWidget {
  // Shows all the users that can be messaged
  final List<ChatModel> chats;

  const ChatView({super.key, required this.chats});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(); // seperation of scrollables
      },
      itemCount: chats.length,
      scrollDirection: Axis.vertical,
      padding: RSpacingStyle.paddingWithAppBarHeight,
      itemBuilder: (BuildContext context, int index) {
        return ChatIcon(chat: chats[index]);
      },
    );
  }
}
