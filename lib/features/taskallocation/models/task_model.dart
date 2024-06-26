import 'dart:io';

class TaskModel {
  final String taskName;
  final String taskDescription;
  final List<String> asignees;
  final DateTime dueDate;
  final List<File> attachments; // Final??? modify if needed.

  TaskModel({
    required this.taskName,
    required this.taskDescription,
    required this.asignees,
    required this.dueDate,
    required this.attachments,
  });

  static TaskModel empty() => TaskModel(
        taskName: '',
        taskDescription: '',
        asignees: [],
        dueDate: DateTime(1000),
        attachments: [],
      );

  // Whatever function needed.

  Map<String, dynamic> toJSON() {
    return {
      'TaskName': taskName,
      'TaskDescription': taskDescription,
      'Asignees': asignees,
      'DueDate': dueDate,
      'Attachments': attachments,
    };
  }
}
