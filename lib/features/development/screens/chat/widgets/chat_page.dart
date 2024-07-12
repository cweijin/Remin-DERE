import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:remindere/common/widgets/appbar/appbar.dart';
import 'package:remindere/data/repositories/authentication_repository/authentication_repository.dart';
import 'package:remindere/features/development/screens/chat/controllers/chat_controller.dart';
import 'package:remindere/features/development/screens/chat/models/chat_model.dart';
import 'package:remindere/features/development/screens/chat/widgets/chat_message_item.dart';
import 'package:remindere/features/development/screens/chat/widgets/chat_view.dart';
import 'package:remindere/utils/constants/colors.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/formatters/formatter.dart';

class ChatPage extends StatelessWidget {
  final ChatModel chat;

  ChatPage({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    final controller = ChatController.instance;
    final authController = AuthenticationRepository.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text(chat.receiverUsername!),
      ),
      body: Column(
        children: [
          // Show the chat messages
          Expanded(
            child: 
            // Obx(() { return 
            GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: ListView.builder(
                  padding: const EdgeInsets.only(top: 12.0),
                  itemCount: chat.messages!.length,
                  itemBuilder: (context, index) {
                    return ChatMessageItem(message: chat.messages![index]);
                  }
              )
            )
            // })
          ),

        // Send Text messages
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            maxLines: null,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'Message...',
              suffixIcon: IconButton(
                onPressed: () {
                  controller.sendMessage(userID: authController.authUser!.uid, receiverID: chat.receiverID);
                },
                icon: const Icon(Icons.send),
              ),
            ),
            controller: controller.msgController,
          ),
        ),
        
        ]
      )
    );
  }
}