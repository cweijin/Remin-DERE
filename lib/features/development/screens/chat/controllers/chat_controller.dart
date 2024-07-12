import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindere/data/repositories/chat_repository/chat_repository.dart';
import 'package:remindere/features/development/screens/chat/models/chat_message_model.dart';
import 'package:remindere/features/development/screens/chat/models/chat_model.dart';
import 'package:remindere/navigation_menu.dart';
import 'package:remindere/utils/helpers/network_manager.dart';
import 'package:remindere/utils/popups/full_screen_loader.dart';
import 'package:remindere/utils/popups/loaders.dart';

class ChatController extends GetxController {
  // data for chatview
  static ChatController get instance => Get.find();
  final chatRepository = Get.put(ChatRepository());
  RxBool refreshData = true.obs;

  // data for chat
  TextEditingController msgController = TextEditingController();


  // need immplement sending messages and receiving messages

  // Fetch all user specific chats for chatview.  
  Future<List<ChatModel>> getUserChats() async {
    try {
      final chats = null; //await ChatRepository.fetchChats();
      return chats;
    } catch (e) {
      RLoaders.errorSnackBar(title: 'Chats not found', message: e.toString());
      return [];
    }
  }


  // Create task
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
        message: '',
        senderID: userID,
        receiverID: receiverID,
        createdAt: DateTime.now(),
        readAt: null,
        attachments: [],
      );

      final chatRepository = Get.put(ChatRepository());
      // await chatRepository.saveChatDetails(newMessage);
      
      msgController.clear(); // clear the message after sending

      // Remove Loader
      RFullScreenLoader.stopLoading();

      // Show success message
      RLoaders.successSnackBar(
          title: 'Congratulations', message: 'Message has been sent!');

    } catch (e) {
      // Remove Loader
      RFullScreenLoader.stopLoading();

      RLoaders.errorSnackBar(
          title: 'Some error occured :(', message: e.toString());
    }
  }

  // Future<void> sendMessage() async {
  //   if (msgController.text.isEmpty) return;
  //   User user = FirebaseAuth.instance.currentUser!;
  //   Timestamp now = Timestamp.now();
  //   if (conversationId == null) {
  //     DocumentReference<Map<String, dynamic>> doc = await FirebaseFirestore.instance.collection('conversations').add({
  //       'members': [friendId, user.uid],
  //       'updatedAt': Timestamp.now()
  //     });
  //     conversationId = doc.id;
  //   }
  //   DocumentReference<Map<String, dynamic>> doc = await FirebaseFirestore.instance.collection('messages').add({
  //     'message': newMessage,
  //     'authorId': user.uid,
  //     'createdAt': now,
  //     'readAt': null,
  //     'conversationId': conversationId,
  //   });
  //   conversationUpdated();
  //   messages!.add(Message(doc.id, newMessage, user.uid, now.toDate(), null));
  // }
  

  // Future<void> fetchMessages() async {
  //   CollectionReference<Map<String, dynamic>> collection = FirebaseFirestore.instance.collection('messages');
  //   late QuerySnapshot<Map<String, dynamic>> result;
  //   if (messages == null) {
  //     result = await collection.where('conversationId', isEqualTo: conversationId).get();
  //     messages = result.docs.map((e) {
  //       Map data = e.data();
  //       return Message(
  //         e.id,
  //         data['message'],
  //         e['authorId'],
  //         (e['createdAt'] as Timestamp).toDate(),
  //         (e['readAt'] as Timestamp?)?.toDate(),
  //       );
  //     }).toList();
  //     messages!.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  //   } else {
  //     List<Message> toReadMessages = messages!.where((e) => e.fromMe && e.readAt == null).toList();
  //     if (toReadMessages.isNotEmpty) {
  //       result = await collection
  //           .where('conversationId', isEqualTo: conversationId)
  //           .where(FieldPath.documentId, whereIn: toReadMessages.map((e) => e.id).toList())
  //           .get();
  //     } else {
  //       result = await collection.where('conversationId', isEqualTo: conversationId).where('readAt', isNull: true).get();
  //     }
  //     List<Message> temp = result.docs.map((e) {
  //       Map data = e.data();
  //       return Message(
  //         e.id,
  //         data['message'],
  //         e['authorId'],
  //         (e['createdAt'] as Timestamp).toDate(),
  //         (e['readAt'] as Timestamp?)?.toDate(),
  //       );
  //     }).toList();
  //     print(temp);
  //     temp.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  //     messages!.removeWhere((e) => e.fromMe && e.readAt == null);
  //     messages!.addAll(temp);
  //   }
  //   print(messages!.map((e) => '${e.message} | ${e.readAt == null}'));
  //   if (isOpen) markAsRead();
  //   notifier.value = DateTime.now().millisecondsSinceEpoch;
  // }


  // Future<void> markAsRead() async {
  //   if (unreadMessagesCount > 0) {
  //     CollectionReference<Map<String, dynamic>> collection = FirebaseFirestore.instance.collection('messages');
  //     Timestamp now = Timestamp.now();
  //     WriteBatch batch = FirebaseFirestore.instance.batch();
  //     QuerySnapshot<Map<String, dynamic>> snapshot = await collection
  //         .where('conversationId', isEqualTo: conversationId)
  //         .where('authorId', isEqualTo: friendId)
  //         .where('readAt', isNull: true)
  //         .get();
  //     snapshot.docs.forEach((document) {
  //       batch.update(document.reference, {'readAt': now});
  //     });

  //     await batch.commit();
  //     await conversationUpdated();
  //     messages!.forEach((element) {
  //       element.readAt ??= now.toDate();
  //     });
  //   }
  // }

  // Future<void> conversationUpdated() async {
  //   await FirebaseFirestore.instance.collection('conversations').doc(conversationID).update({'updatedAt': Timestamp.now()});
  // }

  void resetFormField() {
    msgController.clear();
  }
}