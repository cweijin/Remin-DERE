import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:remindere/utils/formatters/formatter.dart';

class ChatMessageModel {
  final String id;
  final String message;
  final String senderID;
  final String receiverID;
  final DateTime createdAt;
  final bool read;
  // final List<String> attachments; // Final??? modify if needed.

  ChatMessageModel({
    required this.id,
    required this.message,
    required this.senderID,
    required this.receiverID,
    required this.createdAt,
    required this.read,
    // required this.attachments
  });

  String get time => RFormatter.formatTime(createdAt);
  bool get fromMe => senderID == FirebaseAuth.instance.currentUser!.uid;

  static ChatMessageModel empty() => ChatMessageModel(
        id: '',
        message: '',
        senderID: '',
        receiverID: '',
        createdAt: DateTime(1000),
        read: false,
        // attachments: [],
      );
  

  // Whatever function needed.

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'message': message,
      'senderID': senderID,
      'receiverID': receiverID,
      'createdAt': createdAt.toIso8601String(),
      'read': read,
      // 'Attachments': attachments,
    };
  }

  // factory method to create ChatMessageModel from JSON
  factory ChatMessageModel.fromJSON(
    Map<String, dynamic> data) {
    if (data.isNotEmpty) {
      // final data = snapshot;

      log("ChatMessageModel.fromJSON called");
      log(data.runtimeType.toString());
      log((data['read']).toString());

      return ChatMessageModel(
          id: data['id'],
          message: data['message'],
          senderID: data['senderID'],
          receiverID: data['receiverID'],
          createdAt: DateTime.parse(data['createdAt']),
          read: data['read'],  // temporary workarouond
          // attachments: List<String>.from(data['Attachments']) // workaround
          );
    } else {
      return ChatMessageModel.empty();
    }
  }
}
