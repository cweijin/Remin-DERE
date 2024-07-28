import 'dart:io';
import 'package:test/test.dart';
import 'package:remindere/features/task_allocation/models/task_model.dart';

void main() {
  test('Task Model Empty', () {
    // Find all widgets needed
    final task = TaskModel.empty();

    // execute the actual test
    //final snapshot = task.toJSON;
    // final fetchTask = TaskModel.fromSnapshot(snapshot);

    // check outputs
    expect(task.taskName, '');
    expect(task.taskDescription, '');
    expect(task.assignees, List<String>.empty());
    expect(task.taskDescription, '');
    expect(task.attachments, List<File>.empty());
  });
}
