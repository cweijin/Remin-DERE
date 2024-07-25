import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String taskName;
  final String taskDescription;
  final List<String> assignees;
  final DateTime dueDate;
  final List<String> attachments; // Final??? modify if needed.

  TaskModel({
    required this.taskName,
    required this.taskDescription,
    required this.assignees,
    required this.dueDate,
    required this.attachments,
  });

  static TaskModel empty() => TaskModel(
        taskName: '',
        taskDescription: '',
        assignees: [],
        dueDate: DateTime(1000),
        attachments: [],
      );

  // Whatever function needed.

  Map<String, dynamic> toJSON() {
    return {
      'TaskName': taskName,
      'TaskDescription': taskDescription,
      'Assignees': assignees,
      'DueDate': dueDate,
      'Attachments': attachments,
    };
  }

  // Factory method to create a TaskModel from a Firebase document snapshot
  factory TaskModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      return TaskModel(
          taskName: data['TaskName'] ?? ' ',
          taskDescription: data['TaskDescription'] ?? ' ',
          assignees: List<String>.from(data['Assignees']), // workaround
          dueDate: data['DueDate'].toDate(),
          attachments: List<String>.from(data['Attachments']) // workaround
          );
    } else {
      return TaskModel.empty();
    }
  }

  @override
  operator ==(other) {
    if (other is TaskModel) {
      return dueDate == other.dueDate &&
          taskDescription == other.taskDescription &&
          taskName == other.taskName;
    }

    return false;
  }

  @override
  int get hashCode => Object.hash(dueDate, taskDescription, taskName);
}
