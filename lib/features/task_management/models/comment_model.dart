import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String comment;
  final String ownerId;
  final String taskId;
  final DateTime createdAt;
  CommentModel(
      {required this.comment,
      required this.ownerId,
      required this.taskId,
      required this.createdAt});

  static CommentModel empty() => CommentModel(
        comment: '',
        ownerId: '',
        taskId: '',
        createdAt: DateTime(1000),
      );

  // Convert model to JSON structure for storing data in Firebase.
  Map<String, dynamic> toJSON() {
    return {
      'Comment': comment,
      'Owner': ownerId,
      'TaskId': taskId,
      'CreatedAt': createdAt.toIso8601String(),
    };
  }

  // Factory method to create a CommentModel from a JSON
  factory CommentModel.fromJSON(Map<String, dynamic> data) {
    if (data.isNotEmpty) {
      return CommentModel(
        comment: data['Comment'] ?? '',
        ownerId: data['Owner'] ?? '',
        taskId: data['TaskId'] ?? '',
        createdAt: DateTime.parse(data['CreatedAt']).toLocal(),
      );
    } else {
      return CommentModel.empty();
    }
  }
}
