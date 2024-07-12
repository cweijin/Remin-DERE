import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_message_model.dart';

class ChatModel {
  String conversationID;
  String receiverID;
  String? receiverUsername;
  DateTime? updatedAt;
  DateTime lastMessage;
  List<ChatMessageModel>? messages;
  
  // ValueNotifier<int> notifier = ValueNotifier(0);
  bool isOpen = false;

  ChatModel({
    required this.conversationID,
    required this.receiverID,
    required this.receiverUsername,
    required this.updatedAt,
    required this.lastMessage,
    required this.messages
  });

  // int get unreadMessagesCount {
    // return messages?.where((e) => e.senderID == receiverID && e.readAt == null).length ?? 0;
  // }

  static ChatModel empty() => ChatModel(
        conversationID: '',
        receiverID: '',
        receiverUsername: '',
        updatedAt: DateTime(1000),
        lastMessage: DateTime(1000),
        messages: []
      );
  

  // Whatever function needed.

  Map<String, dynamic> toJSON() {
    return {
      'conversationID': conversationID,
      'receiverID': receiverID,
      'receiverUsername': receiverUsername,
      'updatedAt': updatedAt,
      'lastMessage': lastMessage,
      'messages': messages,
      // 'messages': messages?.map((msg) => msg.toJSON()).toList(),
    };
  }

  // Factory method to create a ChatModel from a Firebase document snapshot
  factory ChatModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      return ChatModel(
          conversationID: data['conversationID'] ?? ' ' ,
          receiverID: data['receiverID'] ?? ' ',
          receiverUsername: data['receiverUsername'],
          updatedAt: data['updatedAt'].toDate() ?? data['lastMessage'].toDate(),  // temporary workaround
          lastMessage: data['lastMessage'].toDate(),
          messages: List<ChatMessageModel>.from(data['messages'])   // workaround
          );
    } else {
      return ChatModel.empty();
    }
  }  
}