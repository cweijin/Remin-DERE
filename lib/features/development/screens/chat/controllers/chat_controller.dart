import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:remindere/data/repositories/chat_repository/chat_repository.dart';
import 'package:remindere/data/repositories/user/user_repository.dart';
import 'package:remindere/features/development/screens/chat/models/chat_message_model.dart';
import 'package:remindere/features/development/screens/chat/models/chat_model.dart';
import 'package:remindere/features/personalization/models/user_model.dart';
import 'package:remindere/navigation_menu.dart';
import 'package:remindere/utils/helpers/network_manager.dart';
import 'package:remindere/utils/popups/full_screen_loader.dart';
import 'package:remindere/utils/popups/loaders.dart';

import 'dart:developer';


class ChatController extends GetxController {
  // data for chatview
  static ChatController get instance => Get.find();
  final UserRepository user = Get.find();
  final chatRepository = Get.put(ChatRepository());
  RxBool refreshData = true.obs;
  RxList<UserModel> users = <UserModel>[].obs;

  // data for chat
  TextEditingController msgController = TextEditingController();


  // need immplement sending messages and receiving messages
  void getUsers(String username) async {
    // final chatRepository = ChatRepository.instance;
    // chatRepository.searchUsers(username);
    // return chatRepository.searchResults.map((user) => user.fullName).toList();
    users.value = await user.fetchAllUsers(username);
  }

  // Fetch all user specific chats for chatview.  
  Stream<List<ChatModel>> getUserChats() {
    try {
      final chatRepository = ChatRepository.instance;
      final chats = chatRepository.fetchChats(); //await ChatRepository.fetchChats();

      log('function called');
      log(chats.toString());

      return chats;
    } catch (e) {
      RLoaders.errorSnackBar(title: 'Chats not found', message: e.toString());
      return const Stream.empty();
    }
  }

  // Create Message
  Future<void> sendMessage({required String userID, required String receiverID}) async {
    if (msgController.text.isEmpty) return;

    try {
      // Start loading
      RFullScreenLoader.openLoadingDialog('Sending message...');

      // Check Internet Connectivity
      final bool hasConnection = await NetworkManager.instance.isConnected();
      if (!hasConnection) {
        RFullScreenLoader.stopLoading();
        return;
      }

      // Save authenticated message data in Firebase Firestore
      final newMessage = ChatMessageModel(  
        id: 'testing id',
        message: msgController.text,
        senderID: userID,
        receiverID: receiverID,
        createdAt: DateTime.now(),
        readAt: null,
        attachments: [],
      );

      final chatRepository = ChatRepository.instance;
      await chatRepository.sendMessage(newMessage);
      
      msgController.clear(); // clear the message after sending

      // Remove Loader
      RFullScreenLoader.stopLoading();

    } catch (e) {
      RLoaders.errorSnackBar(
          title: 'Some error occured :(', message: e.toString());
    }
  }

  void resetFormField() {
    msgController.clear();
  }
}