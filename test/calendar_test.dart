import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remindere/features/calendar/screens/calendar.dart';
import 'package:test/test.dart';
import 'package:remindere/features/taskallocation/models/task_model.dart';

void main() {
  test('Calendar Empty', () {
    // Find all widgets needed
    final CalendarScreen = TaskModel.empty();

    // // execute the actual test
    // final snapshot = task.toJSON;
    // // final fetchTask = TaskModel.fromSnapshot(snapshot);

    // // check outputs
    // expect(task.taskName, '');
    // expect(task.taskDescription, '');
    // expect(task.assignees, List<String>.empty());
    // expect(task.taskDescription, '');
    // expect(task.attachments, List<File>.empty());
  });
}
