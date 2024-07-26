import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType { teamCreation, taskCreation, taskSubmission, none }

class NotificationModel {
  final String title;
  final String team;
  final DateTime timeCreated;
  final String createdBy;
  final NotificationType type;

  // Constructor for UserModel
  NotificationModel({
    required this.title,
    required this.team,
    required this.timeCreated,
    required this.createdBy,
    required this.type,
  });

  // Static function to create an empty notification model
  static NotificationModel empty() => NotificationModel(
        title: '',
        team: '',
        timeCreated: DateTime(0),
        createdBy: '',
        type: NotificationType.none,
      );

  // Convert model to JSON structure for storing data in Firebase.
  Map<String, dynamic> toJSON() {
    return {
      'Title': title,
      'Team': team,
      'Time': timeCreated,
      'CreatedBy': createdBy,
      'Type': switch (type) {
        NotificationType.taskCreation => 'task',
        NotificationType.teamCreation => 'team',
        NotificationType.taskSubmission => 'submit',
        NotificationType.none => 'Invalid'
      }
    };
  }

  // Factory method to create a UserModel from a Firebase document snapshot
  factory NotificationModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return NotificationModel(
        title: data['Title'] ?? '',
        team: data['Team'] ?? '',
        timeCreated: data['Time'].toDate() ?? DateTime.now(),
        createdBy: data['CreatedBy'] ?? '',
        type: data['Type'] == 'task'
            ? NotificationType.taskCreation
            : data['Type'] == 'team'
                ? NotificationType.teamCreation
                : data['Type'] == 'submit'
                    ? NotificationType.taskSubmission
                    : NotificationType.none,
      );
    } else {
      return NotificationModel.empty();
    }
  }
}
