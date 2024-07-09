import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remindere/data/repositories/calendar_event_repository/calendar_event_repository.dart';
import 'package:remindere/features/taskallocation/models/task_model.dart';

void main() {
  test('Testing repository', () async {
    FakeFirebaseFirestore db = FakeFirebaseFirestore();
    MockFirebaseAuth user = MockFirebaseAuth();
    user.signInAnonymously();
    CalendarEventRepository repository =
        CalendarEventRepository(firestore: db, user: user.currentUser);

    final model = TaskModel(
        taskName: 'Task',
        taskDescription: 'Testing',
        assignees: ['Hejun'],
        dueDate: DateTime(2024, 8, 31),
        attachments: []);

    repository.saveTaskDetails(model);

    expect(await repository.fetchTaskList().then((value) => value[0]), model);
  });
}
