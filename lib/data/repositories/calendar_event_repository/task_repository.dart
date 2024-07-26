import 'dart:async';
import 'dart:io';
import 'dart:developer';

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
import 'package:remindere/features/task_allocation/models/task_model.dart';
import 'package:remindere/features/task_management/models/comment_model.dart';
import 'package:remindere/features/task_management/models/submission_model.dart';
import 'package:remindere/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:remindere/utils/exceptions/firebase_exceptions.dart';
import 'package:remindere/utils/exceptions/format_exceptions.dart';
import 'package:remindere/utils/exceptions/platform_exceptions.dart';

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
      //Current selected team
      String currentTeam = localStorage.read('CurrentTeam');

      await _db
          .collection('Teams')
          .doc(currentTeam)
          .collection('Tasks')
          .add(task.toJSON());

      // Create a notification to update related users
      final notification = NotificationModel(
        title: task.taskName,
        team: localStorage.read('CurrentTeamName'),
        timeCreated: DateTime.now(),
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

  // modeled after team_repository.dart
  Future<List<TaskModel>> fetchTaskList() async {
    try {
      final result = await _db
          .collection("Users")
          .doc(_user.uid)
          .collection("Tasks")
          .get();
      // return this
      return result.docs
          .map((docSnapshot) => TaskModel.fromSnapshot(docSnapshot))
          .toList();
    } catch (e) {
      throw 'Something went wrong while fetching task list. Please try again later.';
    }
  }

  // Upload comment data
  Future<void> saveComment(CommentModel comment, bool isPrivate) async {
    try {
      final ref = FirebaseDatabase.instance
          .ref()
          .child(isPrivate
              ? 'Tasks/${comment.taskId}/Private/${AuthenticationRepository.instance.authUser!.uid}'
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

  Future<void> saveSubmissionDetails(SubmissionModel submission) async {
    try {
      //Current selected team
      String currentTeam = localStorage.read('CurrentTeam');

      await _db
          .collection('Teams')
          .doc(currentTeam)
          .collection('Tasks')
          .doc(submission.taskId)
          .collection('Submission')
          .doc(_user.uid)
          .set(submission.toJSON());

      // Create a notification to update task owner the submission
      final notification = NotificationModel(
        title: submission.taskName,
        team: localStorage.read('CurrentTeamName'),
        timeCreated: DateTime.now(),
        createdBy: _user.uid,
        type: NotificationType.taskSubmission,
      );

      log('${submission.taskOwnerId}');

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

  Stream<List<CommentModel>> fetchComment(String taskId, bool isPrivate) {
    try {
      final ref = FirebaseDatabase.instance.ref().child(isPrivate
          ? 'Tasks/$taskId/Private/${AuthenticationRepository.instance.authUser!.uid}'
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
      //         // TODO: Handle this case.
      //         break;
      //       case TaskState.success:
      //         // TODO: Handle this case.
      //         break;
      //       case TaskState.canceled:
      //         // TODO: Handle this case.
      //         break;
      //       case TaskState.error:
      //         // TODO: Handle this case.
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
