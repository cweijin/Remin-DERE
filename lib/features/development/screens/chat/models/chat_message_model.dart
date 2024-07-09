import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String message;
  final String senderID;
  final String receiverID;
  final DateTime timestamp;
  final List<File> attachments; // Final??? modify if needed.

  ChatMessageModel({
    required this.message,
    required this.senderID,
    required this.receiverID,
    required this.timestamp,
    required this.attachments
  });

  static ChatMessageModel empty() => ChatMessageModel(
        message: '',
        senderID: '',
        receiverID: '',
        timestamp: DateTime(1000),
        attachments: [],
      );
  

  // Whatever function needed.

  Map<String, dynamic> toJSON() {
    return {
      'message': message,
      'senderID': senderID,
      'receiverID': receiverID,
      'timestamp': timestamp,
      'Attachments': attachments,
    };
  }

  // Factory method to create a TaskModel from a Firebase document snapshot
  factory ChatMessageModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      return ChatMessageModel(
          message: data['message'] ?? ' ',
          senderID: data['senderID'] ?? ' ',
          receiverID: data['receiverID'] ?? ' ',
          timestamp: data['timestamp'].toDate(),
          attachments: List<File>.from(data['Attachments']) // workaround
          );
    } else {
      return ChatMessageModel.empty();
    }
  }
}
