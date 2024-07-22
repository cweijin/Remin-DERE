import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:remindere/data/repositories/authentication_repository/authentication_repository.dart';
import 'package:remindere/features/development/screens/chat/controllers/chat_controller.dart';
import 'package:remindere/features/development/screens/chat/models/chat_message_model.dart';
import 'package:remindere/features/development/screens/chat/models/chat_model.dart';
import 'package:remindere/utils/constants/colors.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/formatters/formatter.dart';
import 'package:remindere/features/development/screens/chat/widgets/chat_page.dart';

class ChatIcon extends StatelessWidget {
  final ChatModel chat;

  const ChatIcon({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    final controller = ChatController.instance;
    final authController = AuthenticationRepository.instance;

      return InkWell(
        onTap: () {
          Get.to(ChatPage(chat: chat));
        },
        child: ListTile(
          leading: const CircleAvatar(),
          title: Text(chat.receiverUsername!),
          subtitle: Text(chat.isOpen? 'no messages yet' : "Testing message!"),  // need to change testing message
          trailing: Column(
            children: [
              // for alignement
              const SizedBox(height: RSizes.sm),

              Text(chat.isOpen ? 'start chat' : RFormatter.formatTime(chat.lastMessage)),

              const SizedBox(height: RSizes.sm),

              Container(
                decoration: BoxDecoration(
                  color: RColors.accent,
                  borderRadius: BorderRadius.circular(50)
                ),
                child: Text(" ${chat.unreadMessagesCount} ")  // unread messages
              )
            ],
          ),
        )
      );
  }
}