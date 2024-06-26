// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:remindere/features/authentication/screens/login/login.dart';
// import 'package:remindere/navigation_menu.dart';
// import 'package:remindere/utils/exceptions/firebase_auth_exceptions.dart';
// import 'package:remindere/utils/exceptions/firebase_exceptions.dart';
// import 'package:remindere/utils/exceptions/format_exceptions.dart';
// import 'package:remindere/utils/exceptions/platform_exceptions.dart';

// class CalendarEventRepository extends GetxController {
//   static CalendarEventRepository get instance => Get.find();

//   // Variables
//   final deviceStorage = GetStorage();
  

//   // SignIn
//   Future<UserCredential> addEventToCalendar(
//       String email, String eventName) async { // how to store the event key? use datetime.now()?
//     try {
//       return await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
//     } on FirebaseAuthException catch (e) {
//       throw RFirebaseAuthException(e.code).message;
//     } on FirebaseException catch (e) {
//       throw RFirebaseException(e.code).message;
//     } on FormatException catch (_) {
//       throw const RFormatException();
//     } on PlatformException catch (e) {
//       throw RPlatformException(e.code).message;
//     } catch (e) {
//       throw 'Unknown error. Please try again.';
//     }
//   }
// }
