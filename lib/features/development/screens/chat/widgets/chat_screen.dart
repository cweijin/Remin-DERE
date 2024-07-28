import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindere/features/development/screens/chat/models/chat_model.dart';
import 'package:remindere/features/development/screens/chat/widgets/chat_view.dart';
import 'package:remindere/features/development/screens/chat/controllers/chat_controller.dart';

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
        child: Obx(
      () => StreamBuilder(
        // Use key to trigger refresh
        key: Key(controller.refreshData.value.toString()),
        stream: controller
            .getUserChats(), // currently set to show all chats. can update to only show users with chat history
        builder: (context, snapshot) {
          // Helper function to handle loader, no record, or error message
          // final response =
          //     RCloudHelperFunctions.checkMultiRecordState(
          //       snapshot: snapshot, nothingFound: const Center(child: Text('you have no friends')),
          //     );
          // if (response != null) return response;
          if (snapshot.hasData &&
              !snapshot.hasError &&
              snapshot.data!.snapshot.value != null) {
            // log("StreamBuilder: snapshot data: ");

            final data =
                Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);

            List<ChatModel> chats = [];
            data.forEach((index, chat) {
              // log("keys are: ${index.toString()}");
              // log(data[index].toString());
              // log(data[index].runtimeType.toString());
              chats.add(
                  ChatModel.fromJSON(Map<String, dynamic>.from(data[index])));
            });

            chats.sort((chatA, chatB) => chatB.lastMessage.compareTo(
                chatA.lastMessage)); // sort based on latest last message

            return ChatView(chats: chats);
          }

          return const Center(child: Text('you have no friends'));
        },
      ),
    ));
  }
}
