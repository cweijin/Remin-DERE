import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ChatMessageModel {
  final String id;
  final String message;
  final String senderID;
  final String receiverID;
  final DateTime createdAt;
  final DateTime? readAt;
  final List<File> attachments; // Final??? modify if needed.

  ChatMessageModel({
    required this.id,
    required this.message,
    required this.senderID,
    required this.receiverID,
    required this.createdAt,
    required this.readAt,
    required this.attachments
  });

  String get time => DateFormat('d/M, h:m a').format(DateTime.now());
  bool get fromMe => senderID == FirebaseAuth.instance.currentUser!.uid;

  static ChatMessageModel empty() => ChatMessageModel(
        id: '',
        message: '',
        senderID: '',
        receiverID: '',
        createdAt: DateTime(1000),
        readAt: DateTime(1000),
        attachments: [],
      );
  

  // Whatever function needed.

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'message': message,
      'senderID': senderID,
      'receiverID': receiverID,
      'createdAt': createdAt,
      'readAt': readAt,
      'Attachments': attachments,
    };
  }

  // Factory method to create a ChatMessageModel from a Firebase document snapshot
  factory ChatMessageModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      return ChatMessageModel(
          id: data['id'] ?? ' ',
          message: data['message'] ?? ' ',
          senderID: data['senderID'] ?? ' ',
          receiverID: data['receiverID'] ?? ' ',
          createdAt: data['createdAt'].toDate(),
          readAt: data['readAt'].toDate() ?? DateTime.timestamp(),  // temporary workarouond
          attachments: List<File>.from(data['Attachments']) // workaround
          );
    } else {
      return ChatMessageModel.empty();
    }
  }
}
