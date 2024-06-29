import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:remindere/features/taskallocation/models/task_model.dart';
import 'package:remindere/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:remindere/utils/exceptions/firebase_exceptions.dart';
import 'package:remindere/utils/exceptions/format_exceptions.dart';
import 'package:remindere/utils/exceptions/platform_exceptions.dart';

class CalendarEventRepository extends GetxController {
  static CalendarEventRepository get instance => Get.find();
  final _auth = FirebaseAuth.instance;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveTaskDetails(TaskModel task) async {
    try {
      final user = _auth.currentUser;
      await _db
          .collection("Users")
          .doc(user!.uid)
          .collection("Tasks")
          .add(task.toJSON()); // Find a way for the auto doc id!!!
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
      final user = _auth.currentUser;
      final result = await _db
                        .collection("Users")
                        .doc(user!.uid)
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

}
