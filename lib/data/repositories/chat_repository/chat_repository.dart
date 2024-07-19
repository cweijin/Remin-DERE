import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:remindere/data/repositories/authentication_repository/authentication_repository.dart';
import 'package:remindere/features/development/screens/chat/models/chat_message_model.dart';
import 'package:remindere/features/development/screens/chat/models/chat_model.dart';
import 'package:remindere/features/personalization/models/user_model.dart';
import 'package:remindere/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:remindere/utils/exceptions/firebase_exceptions.dart';
import 'package:remindere/utils/exceptions/format_exceptions.dart';
import 'package:remindere/utils/exceptions/platform_exceptions.dart';
import 'package:remindere/utils/popups/loaders.dart';

import '../user/user_repository.dart';

class ChatRepository extends GetxController {
  static ChatRepository get instance => Get.find();
  final DatabaseReference _ref = FirebaseDatabase.instance.ref('/');

  ChatRepository({FirebaseFirestore? firestore, User? user}) {
    _db = firestore ?? FirebaseFirestore.instance;
    _user = user ?? AuthenticationRepository.instance.authUser!;
  }

  late FirebaseFirestore _db;
  late User _user;
  List<UserModel> searchResults = [];
  RxBool refreshSearchResult = true.obs;


  void searchUsers(String input) async {
    try {
      final userRepository = UserRepository.instance;
      final allUsers = await userRepository.fetchAllUsers(input);

      searchResults = allUsers;
      refreshSearchResult.toggle();
    } catch (e) {
      RLoaders.errorSnackBar(title: 'User not found', message: e.toString());
    }
  }

  // save chats
  Future<void> saveChatDetails(ChatModel chat) async {
    try {
      final chatRef =
        _ref.child('users/${_user.uid}/chats').push();

      await chatRef.set(chat.toJSON());

    } on FirebaseAuthException catch (e) {
      throw RFirebaseAuthException(e.code).message;
    } catch (e) {
      throw 'Unknown error. Please try again.';
    }
  }

  // fetch chats
  Stream<List<ChatModel>> fetchChats()  {
    // Get the Stream
    Stream<DatabaseEvent> stream = _ref
        .child('users/${_user.uid}/chats')
        // .orderByChild("timeSend")
        .onValue;    
    
    // Subscribe to the stream!
    // stream.listen((DatabaseEvent event) {
    //   print('Event Type: ${event.type}'); // DatabaseEventType.value;
    //   print('Snapshot: ${event.snapshot}'); // DataSnapshot
    // });

    return stream.map((chat) => 
      chat.snapshot.children
      .map((e) => ChatModel.fromJSON(e.value as Map<String, dynamic>))
      .toList());

    // return stream;
  }

  Future<void> sendMessage(ChatMessageModel message) async {

    var timeSend = DateTime.now().toUtc().toIso8601String();

    final messageRef =
        _ref.child('users/${message.senderID}/chats/${message.receiverID}/messages').push();

    await messageRef.set(message.toJSON());

    // To send the message to the receiver's side as well (if needed)
    _ref
        .child('users/${message.receiverID}/chats/${message.senderID}/messages')
        .push()
        .set(message.toJSON());
  }
}
