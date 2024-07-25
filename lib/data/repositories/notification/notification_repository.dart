import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:remindere/data/repositories/authentication_repository/authentication_repository.dart';
import 'package:remindere/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:remindere/utils/exceptions/firebase_exceptions.dart';
import 'package:remindere/utils/exceptions/format_exceptions.dart';
import 'package:remindere/utils/exceptions/platform_exceptions.dart';

class NotificationRepository extends GetxController {
  static NotificationRepository get instance => Get.find();

  // these are provided if we want to test using a fake firestore.
  NotificationRepository({FirebaseFirestore? firestore, User? user}) {
    _db = firestore ?? FirebaseFirestore.instance;
    _user = user ?? AuthenticationRepository.instance.authUser!;
  }

  // for testing
  late FirebaseFirestore _db;
  late User _user;

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchNotifications() {
    try {
      const limit = 20;
      return _db
          .collection('Users')
          .doc(_user.uid)
          .collection('Notifications')
          .orderBy('Time', descending: true)
          .limit(limit)
          .snapshots();
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
