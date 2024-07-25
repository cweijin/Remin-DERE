import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:remindere/data/repositories/authentication_repository/authentication_repository.dart';
import 'package:remindere/features/development/models/notification/notification_model.dart';
import 'package:remindere/features/personalization/controllers/user_controller.dart';
import 'package:remindere/features/taskallocation/models/task_model.dart';
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
}
