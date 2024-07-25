import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:remindere/data/repositories/authentication_repository/authentication_repository.dart';
import 'package:remindere/features/development/screens/chat/models/chat_message_model.dart';
import 'package:remindere/features/development/screens/chat/models/chat_model.dart';
import 'package:remindere/features/personalization/controllers/user_controller.dart';
import 'package:remindere/features/personalization/models/user_model.dart';
import 'package:remindere/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:remindere/utils/popups/loaders.dart';

import '../user/user_repository.dart';

class ChatRepository extends GetxController {
  static ChatRepository get instance => Get.find();
  final DatabaseReference _ref = FirebaseDatabase.instance.ref('/');

  // these are provided if we want to test using a fake firestore.
  ChatRepository({FirebaseFirestore? firestore, User? user}) {
    _db = firestore ?? FirebaseFirestore.instance;
    _user = user ?? AuthenticationRepository.instance.authUser!;
  }

  // for testing
  late FirebaseFirestore _db;
  late User _user;
  final userRepository = UserRepository.instance;
  final userController = UserController.instance;

  List<UserModel> searchResults = [];
  RxBool refreshSearchResult = true.obs;

  void searchUsers(String input) async {
    try {
      final allUsers = await userRepository.fetchAllUsers(input);

      searchResults = allUsers;
      refreshSearchResult.toggle();
    } catch (e) {
      RLoaders.errorSnackBar(title: 'User not found', message: e.toString());
    }
  }

  // fetch chats
  Stream<DatabaseEvent> fetchChats() {
    // Get the Stream
    Stream<DatabaseEvent> stream = _ref
        .child('users/${_user.uid}/chats')
        // .orderByChild("timeSend")
        .onValue;

    return stream;
  }

  // fetch messages
  Stream<DatabaseEvent> fetchMessages(String chatID) {
    // Get the Stream
    Stream<DatabaseEvent> stream = _ref
        .child('users/${_user.uid}/chats/$chatID/messages')
        // .orderByChild("timeSend")
        .onValue;

    return stream;
  }

  Future<void> sendMessage(ChatMessageModel message, ChatModel chat) async {
    final messageRef = _ref
        .child('users/${message.senderID}/chats/${message.receiverID}/messages')
        .push();

    await messageRef.set(message.toJSON());

    // To send the message to the receiver's side as well (if needed)
    _ref
        .child('users/${message.receiverID}/chats/${message.senderID}/messages')
        .push()
        .set(message.toJSON());

    // update chat details
    saveChatDetails(chat, message);
  }

  // save chats
  Future<void> saveChatDetails(ChatModel chat, ChatMessageModel message) async {
    try {
      final sender = userController.user.value;
      chat.updateLastMessage(message.createdAt); // updates unread message count

      final chatRef =
          _ref.child('users/${sender.id}/chats/${chat.receiverID}/details');

      await chatRef.set(chat.toJSON());

      // To send the message to the receiver's side as well (if needed)
      final otherChat = ChatModel(
          receiverID: sender.id,
          receiverUsername: sender.username,
          updatedAt: chat.updatedAt,
          lastMessage: message.createdAt,
          unreadMessagesCount: chat.unreadMessagesCount);
      otherChat.updateUnread(); // updates unread message count

      _ref
          .child('users/${chat.receiverID}/chats/${sender.id}/details')
          .set(otherChat.toJSON());
    } on FirebaseAuthException catch (e) {
      throw RFirebaseAuthException(e.code).message;
    } catch (e) {
      throw 'Unknown error. Please try again.';
    }
  }

  Future<void> readMessages(ChatModel chat) async {
    final sender = userController.user.value;
    final chatRef =
        _ref.child('users/${sender.id}/chats/${chat.receiverID}/details');

    chat.readMessages();
    await chatRef.set(chat.toJSON());
  }
}
