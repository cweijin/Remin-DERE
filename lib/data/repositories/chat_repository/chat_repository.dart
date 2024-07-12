import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:remindere/data/repositories/authentication_repository/authentication_repository.dart';
import 'package:remindere/features/development/screens/chat/models/chat_message_model.dart';
import 'package:remindere/features/development/screens/chat/models/chat_model.dart';
import 'package:remindere/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:remindere/utils/exceptions/firebase_exceptions.dart';
import 'package:remindere/utils/exceptions/format_exceptions.dart';
import 'package:remindere/utils/exceptions/platform_exceptions.dart';

class ChatRepository extends GetxController {
  static ChatRepository get instance => Get.find();

  ChatRepository({FirebaseFirestore? firestore, User? user}) {
    _db = firestore ?? FirebaseFirestore.instance;
    _user = user ?? AuthenticationRepository.instance.authUser!;
  }

  late FirebaseFirestore _db;
  late User _user;

  // save chats
  Future<void> saveChatDetails(ChatModel chat) async {
    try {
      await _db
          .collection("Users")
          .doc(_user.uid)
          .collection("Chats")
          .add(chat.toJSON());
    } on FirebaseAuthException catch (e) {
      throw RFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw RFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const RFormatException();
    } on PlatformException catch (e) {
      throw RPlatformException(e.code).message;
    } catch (e) {
      throw 'Unknown error. Please try again.';
    }
  }

  // fetch chats
  Future<List<ChatModel>> fetchChats() async {
    try {
      final result = await _db
          .collection("Users")
          .doc(_user.uid)
          .collection("Chats")
          .get();
      // return this
      return result.docs
          .map((docSnapshot) => ChatModel.fromSnapshot(docSnapshot))
          .toList();
    } catch (e) {
      throw 'Something went wrong while fetching chats. Please try again later.';
    }
  }
}
