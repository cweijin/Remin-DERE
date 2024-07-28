import 'package:cloud_firestore/cloud_firestore.dart';

enum TaskStatus { toDo, inProgress, completed, overdue }

class TaskModel {
  final String taskName;
  final String taskDescription;
  final List<String> assignees;
  final DateTime dueDate;
  final List<String> attachments; // Final??? modify if needed.
  final String owner;
  final String team;
  final TaskStatus status;

  String? id;

  TaskModel({
    required this.taskName,
    required this.taskDescription,
    required this.assignees,
    required this.dueDate,
    required this.attachments,
    required this.owner,
    required this.team,
    required this.status,
    this.id,
  });

  static TaskModel empty() => TaskModel(
        taskName: '',
        taskDescription: '',
        assignees: [],
        dueDate: DateTime(1000),
        attachments: [],
        owner: '',
        team: '',
        status: TaskStatus.toDo,
        id: '',
      );

  // Whatever function needed.

  Map<String, dynamic> toJSON() {
    return {
      'TaskName': taskName,
      'TaskDescription': taskDescription,
      'Assignees': assignees,
      'DueDate': dueDate,
      'Attachments': attachments,
      'Team': team,
      'Owner': owner,
      'Status': status.name,
    };
  }

  // Factory method to create a TaskModel from a Firebase document snapshot
  factory TaskModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      return TaskModel(
          taskName: data['TaskName'] ?? '',
          taskDescription: data['TaskDescription'] ?? '',
          assignees: List<String>.from(data['Assignees'] ?? []), // workaround
          dueDate: data['DueDate'].toDate(),
          attachments:
              List<String>.from(data['Attachments'] ?? []), // workaround
          owner: data['Owner'] ?? '',
          team: data['Team'] ?? '',
          status: data['DueDate'].toDate().isBefore(DateTime.now())
              ? TaskStatus.overdue
              : data['Status'] == TaskStatus.toDo.name
                  ? TaskStatus.toDo
                  : data['Status'] == TaskStatus.inProgress.name
                      ? TaskStatus.inProgress
                      : data['Status'] == TaskStatus.completed.name
                          ? TaskStatus.completed
                          : TaskStatus.toDo,
          id: document.id);
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
