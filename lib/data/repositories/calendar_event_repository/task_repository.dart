import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:remindere/data/repositories/authentication_repository/authentication_repository.dart';
import 'package:remindere/features/development/models/notification/notification_model.dart';
import 'package:remindere/features/personalization/controllers/user_controller.dart';
import 'package:remindere/features/task_allocation/models/task_model.dart';
import 'package:remindere/features/task_management/models/comment_model.dart';
import 'package:remindere/features/task_management/models/submission_model.dart';
import 'package:remindere/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:remindere/utils/exceptions/firebase_exceptions.dart';
import 'package:remindere/utils/exceptions/format_exceptions.dart';
import 'package:remindere/utils/exceptions/platform_exceptions.dart';
import 'package:remindere/utils/helpers/helper_functions.dart';

class TaskRepository extends GetxController {
  static TaskRepository get instance => Get.find();

  TaskRepository({FirebaseFirestore? firestore, User? user}) {
    _db = firestore ?? FirebaseFirestore.instance;
    _user = user ?? AuthenticationRepository.instance.authUser!;
  }

  late FirebaseFirestore _db;
  late User _user;

  final localStorage = GetStorage();

  Future<void> saveTaskDetails(TaskModel task) async {
    try {
      // Current selected team
      String currentTeam = localStorage.read('CurrentTeam');

      await _db
          .collection('Teams')
          .doc(currentTeam)
          .collection('Tasks')
          .add(task.toJSON());

      // Create a notification to update related users
      final notification = NotificationModel(
        title: task.taskName,
        timeCreated: Timestamp.now().toDate(),
        where: localStorage.read('CurrentTeamName'),
        createdBy: _user.uid,
        type: NotificationType.taskCreation,
      );

      //Upload task to each of the assignees
      for (String id in task.assignees) {
        await _db
            .collection('Users')
            .doc(id)
            .collection('Tasks')
            .add(task.toJSON());

        // No need to notify owner
        if (id == UserController.instance.user.value.id) continue;

        await _db
            .collection('Users')
            .doc(id)
            .collection('Notifications')
            .add(notification.toJSON());

        await _db
            .collection('Users')
            .doc(id)
            .update({'Unread': FieldValue.increment(1)});
      }
    } on FirebaseAuthException catch (e) {
      throw RFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw RFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const RFormatException();
    } on PlatformException catch (e) {
      throw RPlatformException(e.code).message;
    } catch (e) {
      throw 'Unknown error. Please try again.';
    }
  }

  Future<void> removeTaskDetails(TaskModel task) async {
    try {
      await _db
          .collection('Teams')
          .doc(task.team)
          .collection('Tasks')
          .doc(task.id)
          .delete();

      // // Create a notification to update related users
      // final notification = NotificationModel(
      //   title: task.taskName,
      //   timeCreated: Timestamp.now().toDate(),
      //   where: localStorage.read('CurrentTeamName'),
      //   createdBy: _user.uid,
      //   type: NotificationType.taskCreation,
      // );

      //Delete task data for each of the assignees
      for (String id in task.assignees) {
        await _db
            .collection('Users')
            .doc(id)
            .collection('Tasks')
            .doc(task.id)
            .delete();

        // // No need to notify owner
        // if (id == UserController.instance.user.value.id) continue;

        // await _db
        //     .collection('Users')
        //     .doc(id)
        //     .collection('Notifications')
        //     .add(notification.toJSON());

        // await _db
        //     .collection('Users')
        //     .doc(id)
        //     .update({'Unread': FieldValue.increment(1)});
      }
    } on FirebaseAuthException catch (e) {
      throw RFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw RFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const RFormatException();
    } on PlatformException catch (e) {
      throw RPlatformException(e.code).message;
    } catch (e) {
      throw 'Unknown error. Please try again.';
    }
  }

  // Fetch user tasks
  Future<List<TaskModel>> fetchUserTaskList() async {
    try {
      final result = await _db
          .collection("Users")
          .doc(_user.uid)
          .collection("Tasks")
          .orderBy('DueDate')
          .get();
      // return this
      return result.docs
          .map((docSnapshot) => TaskModel.fromSnapshot(docSnapshot))
          .toList();
    } catch (e) {
      throw 'Something went wrong while fetching task list. Please try again later.';
    }
  }

  // Fetch team specific tasks from Firestore
  Future<List<TaskModel>> fetchTeamTaskList({String? teamId}) async {
    try {
      final result = await _db
          .collection('Teams')
          .doc(teamId ?? localStorage.read('CurrentTeam'))
          .collection('Tasks')
          .orderBy('DueDate')
          .get();

      return result.docs
          .map((docSnapshot) => TaskModel.fromSnapshot(docSnapshot))
          .toList();
    } catch (e) {
      throw 'Something went wrong while fetching task list. Please try again later.';
    }
  }

  // Upload comment data
  Future<void> saveComment(
      CommentModel comment, String assigneeId, bool isPrivate) async {
    try {
      final ref = FirebaseDatabase.instance
          .ref()
          .child(isPrivate
              ? 'Tasks/${comment.taskId}/Private/$assigneeId'
              : 'Tasks/${comment.taskId}/Comments')
          .push();

      await ref.set(comment.toJSON());
    } on FirebaseAuthException catch (e) {
      throw RFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw RFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const RFormatException();
    } on PlatformException catch (e) {
      throw RPlatformException(e.code).message;
    } catch (e) {
      throw 'Unknown error. Please try again.';
    }
  }

  Stream<List<CommentModel>> fetchComment(
      String taskId, String assigneeId, bool isPrivate) {
    try {
      final ref = FirebaseDatabase.instance.ref().child(isPrivate
          ? 'Tasks/$taskId/Private/$assigneeId'
          : 'Tasks/$taskId/Comments');

      final commentStream = ref.onValue.asyncMap(
          (event) => Map<String, Map>.from(event.snapshot.value as Map));

      final modelStream = commentStream.map(
        (element) => element.map(
          (key, val) {
            final temp = Map<String, dynamic>.from(val);
            return MapEntry(key, CommentModel.fromJSON(temp));
          },
        ),
      );

      final sorted = modelStream.map(
        (models) {
          List<CommentModel> modelList = <CommentModel>[];
          models.forEach((key, val) => modelList.add(val));
          modelList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          return modelList;
        },
      );

      return sorted;
    } catch (e) {
      throw 'Something went wrong while fetching comments. Please try again later.';
    }
  }

  Future<void> saveSubmissionDetails(
      SubmissionModel submission, String teamId) async {
    try {
      await _db
          .collection('Teams')
          .doc(teamId)
          .collection('Tasks')
          .doc(submission.taskId)
          .collection('Submissions')
          .doc(_user.uid)
          .set(submission.toJSON());

      // Create a notification to update task owner the submission
      final notification = NotificationModel(
        title: submission.taskName,
        where: localStorage.read('CurrentTeamName'),
        timeCreated: DateTime.now(),
        createdBy: _user.uid,
        type: NotificationType.taskSubmission,
      );

      await _db
          .collection('Users')
          .doc(submission.taskOwnerId)
          .collection('Notifications')
          .add(notification.toJSON());

      await _db
          .collection('Users')
          .doc(submission.taskOwnerId)
          .update({'Unread': FieldValue.increment(1)});
    } on FirebaseAuthException catch (e) {
      throw RFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw RFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const RFormatException();
    } on PlatformException catch (e) {
      throw RPlatformException(e.code).message;
    } catch (e) {
      throw 'Unknown error. Please try again.';
    }
  }

  // Update one single field of the task
  Future<void> updateTaskStatus(TaskStatus status, TaskModel task) async {
    try {
      Map<String, dynamic> json = {'Status': status.name};
      await _db
          .collection('Teams')
          .doc(task.team)
          .collection('Tasks')
          .doc(task.id)
          .update(json);

      // Create a notification to update task owner the submission
      final notification = NotificationModel(
        title: RHelperFunctions.getTaskStatus(status),
        where: task.taskName,
        timeCreated: DateTime.now(),
        createdBy: _user.uid,
        type: NotificationType.statusUpdate,
      );

      //Send notification to assignees
      for (String id in task.assignees) {
        // No need to notify owner
        if (id == UserController.instance.user.value.id) continue;

        await _db
            .collection('Users')
            .doc(id)
            .collection('Notifications')
            .add(notification.toJSON());

        await _db
            .collection('Users')
            .doc(id)
            .update({'Unread': FieldValue.increment(1)});
      }
    } on FirebaseAuthException catch (e) {
      throw RFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw RFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const RFormatException();
    } on PlatformException catch (e) {
      throw RPlatformException(e.code).message;
    } catch (e) {
      throw 'Unknown error. Please try again.';
    }
  }

  // Fetch team specific tasks from Firestore
  Future<SubmissionModel> fetchSubmission(
      String teamId, String taskId, String assigneeId) async {
    try {
      final result = await _db
          .collection('Teams')
          .doc(teamId)
          .collection('Tasks')
          .doc(taskId)
          .collection('Submissions')
          .doc(assigneeId)
          .get();

      if (result.data() == null) {
        return SubmissionModel.empty();
      }

      return SubmissionModel.fromJSON(result.data()!);
    } catch (e) {
      throw 'Something went wrong while fetching task list. Please try again later.';
    }
  }

  // Upload any files
  Future<List<String>> uploadFiles(String path, List<XFile> files) async {
    try {
      final urls = files.map((file) async {
        final ref = FirebaseStorage.instance.ref(path).child(file.name);
        await ref.putFile(File(file.path));
        final url = await ref.getDownloadURL();
        return url;
      }).toList();

      return await Future.wait(urls);
    } on FirebaseAuthException catch (e) {
      throw RFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw RFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const RFormatException();
    } on PlatformException catch (e) {
      throw RPlatformException(e.code).message;
    } catch (e) {
      throw 'Unknown error. Please try again.';
    }
  }

  // Download file from link
  Future<void> downloadFile(String url) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(url);

      final appDocDir = await getDownloadsDirectory();
      final filePath = "${appDocDir!.path}/attachments/${ref.name}";
      final file = File(filePath);

      await file.create(recursive: true);
      final downloadTask = ref.writeToFile(file);

      // downloadTask.snapshotEvents.listen(
      //   (taskSnapshot) {
      //     switch (taskSnapshot.state) {
      //       case TaskState.running:
      //         taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
      //         break;
      //       case TaskState.paused:
      //         break;
      //       case TaskState.success:
      //         break;
      //       case TaskState.canceled:
      //         break;
      //       case TaskState.error:
      //         break;
      //     }
      // },
      // );

      await OpenFile.open(file.path);
    } on FirebaseAuthException catch (e) {
      throw RFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw RFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const RFormatException();
    } on PlatformException catch (e) {
      throw RPlatformException(e.code).message;
    } catch (e) {
      throw 'Unknown error. Please try again.';
    }
  }
}
