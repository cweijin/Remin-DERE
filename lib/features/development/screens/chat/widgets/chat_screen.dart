import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindere/data/repositories/authentication_repository/authentication_repository.dart';
import 'package:remindere/features/development/screens/chat/models/chat_message_model.dart';
import 'package:remindere/features/development/screens/chat/models/chat_model.dart';
import 'package:remindere/features/development/screens/chat/widgets/chat_message_item.dart';
import 'package:remindere/features/development/screens/chat/widgets/chat_view.dart';
import 'package:remindere/features/development/screens/chat/widgets/find_user.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/helpers/cloud_helper_functions.dart';
// import 'package:remindere/common/styles/spacing_styles.dart';
import 'package:remindere/features/development/screens/chat/controllers/chat_controller.dart';
import 'package:remindere/utils/constants/colors.dart';

class RChatScreen extends StatelessWidget {
  // this helps build the changeable list of chats.
  const RChatScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // chat view controller
    final controller = Get.put(ChatController());

    // to show all chats
    return Expanded(
      child: Column(
        children: [
          // Find users to chat with
          InkWell(
            onTap: () {
              Get.to(const FindUser());
            },
            radius: RSizes.appBarHeight,
            child: const SizedBox(   
              height: RSizes.appBarHeight,      
              width: RSizes.buttonWidth,
              child: Text('Find User')    
            )        
          ),

          Obx(
            () => StreamBuilder(
              // Use key to trigger refresh
              key: Key(controller.refreshData.value.toString()),
              stream: controller.getUserChats(), // currently set to show all chats. can update to only show users with chat history
              builder: (context, snapshot) {
                // Helper function to handle loader, no record, or error message
                final response =
                    RCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot);
                if (response != null) return response;

                final chats = snapshot.data!;

                return ChatView(chats: chats);
              },
            ),
          )
        ]
      )
    );

    // For testing purposes

  // testing purposes
    // List<ChatMessageModel> messageTest = [
    //   ChatMessageModel(id: 'random id for deletion', message: 'no messages yet', senderID: 'testing ID', receiverID: 'test', createdAt: DateTime.now(), readAt: DateTime.now(), attachments: []),
    //   ChatMessageModel(id: 'random id for deletion 2', message: 'hi', senderID: 'testing ID', receiverID: 'test', createdAt: DateTime.now(), readAt: DateTime.now(), attachments: []),
    //   ChatMessageModel(id: 'random id for deletion 3', message: 'no messages yet', senderID: AuthenticationRepository.instance.authUser!.uid, receiverID: 'test', createdAt: DateTime.now(), readAt: null, attachments: []),
    // ];
    
    // List<ChatModel> chatsTest = [
    //   ChatModel(conversationID: 'testID', receiverID: 'noone', receiverUsername: 'chat test', updatedAt: DateTime.now(), lastMessage: DateTime.now(), messages: messageTest),
    //   ChatModel(conversationID: 'testID2', receiverID: 'someone', receiverUsername: 'chat test 2', updatedAt: DateTime.now(), lastMessage: DateTime.now(), messages: messageTest)      
    // ];

    // return Expanded(
    //   child: ChatView(chats: chatsTest)
    // );
  }
}


