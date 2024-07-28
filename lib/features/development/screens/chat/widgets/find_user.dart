// find friends to chat with

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:remindere/common/styles/spacing_styles.dart';
import 'package:remindere/features/development/screens/chat/controllers/chat_controller.dart';
import 'package:remindere/features/development/screens/chat/models/chat_model.dart';
import 'package:remindere/features/development/screens/chat/widgets/chat_icon.dart';
import 'package:remindere/features/development/screens/chat/widgets/chat_page.dart';

class FindUser extends StatelessWidget {
  // this helps build the list of possible users to chat with.
  const FindUser({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ChatController controller = ChatController.instance;
    TextEditingController search = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find User')
      ),

      body: SafeArea(
        child: Column(
          children: [
            // search bar
            TextFormField(
              controller: search,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    controller.getUsers(search.text);
                  },
                  icon: const Icon(
                    Iconsax.search_favorite
                  ),
                )
              ),
            ),

            // show list of users to start chat
            Expanded(
              child: Obx(() => ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(); // seperation of scrollables
                  },
                  itemCount: controller.users.length,
                  scrollDirection: Axis.vertical,
                  padding: RSpacingStyle.paddingWithAppBarHeight,
                  itemBuilder: (BuildContext context, int index) {
                    return ChatIcon(
                      chat: ChatModel(
                        receiverID: controller.users[index].id,
                        receiverUsername: controller.users[index].username,
                        updatedAt: Timestamp.now().toDate(),
                        lastMessage: Timestamp.now().toDate(),
                        messageDetails: '',
                        unreadMessagesCount: 0
                      )
                    );
                  },
                )
              )
            )
          ]
        )
      )
    );
  }
}