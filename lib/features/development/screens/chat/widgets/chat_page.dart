import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:remindere/data/repositories/authentication_repository/authentication_repository.dart';
import 'package:remindere/features/development/screens/chat/controllers/chat_controller.dart';
import 'package:remindere/features/development/screens/chat/models/chat_message_model.dart';
import 'package:remindere/features/development/screens/chat/models/chat_model.dart';
import 'package:remindere/features/development/screens/chat/widgets/chat_message_item.dart';

class ChatPage extends StatelessWidget {
  final ChatModel chat;

  const ChatPage({super.key, required this.chat});

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
              GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: StreamBuilder(
                  stream: controller.getMessages(chat.receiverID), // need to fetch from firebase
                  builder: ((context, snapshot) {
                    if (snapshot.hasData && !snapshot.hasError && 
                      snapshot.data!.snapshot.value != null) {

                        log("StreamBuilder: chat snapshot data: ");
                        final data = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
                        log(data.toString());
                        log(data.runtimeType.toString());

                        List<ChatMessageModel> chat = [];
                        data.forEach((index, messages) {
                          log("keys are: ${index.toString()}");
                          log(data[index].toString());
                          log(data[index].runtimeType.toString());
                          chat.add(ChatMessageModel.fromJSON(Map<String, dynamic>.from(data[index])));
                        });
                
                        return ListView.builder(
                          padding: const EdgeInsets.only(top: 12.0),
                          itemCount: chat.length,
                          itemBuilder: (context, index) {
                            return ChatMessageItem(message: chat[index]);
                          }
                        );
                      }
                    return Text("No messages found");
                  }
                )
              )
            ),
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
                    if (!chat.isOpen) {chat.createChat();}  // set chat open to true.
                    controller.sendMessage(userID: authController.authUser!.uid, receiverID: chat.receiverID, chat: chat);
                  },
                  icon: const Icon(Icons.send),
                ),
              ),
              controller: controller.msgController,
            ),
          )
        ]
      )
    );
  }
}