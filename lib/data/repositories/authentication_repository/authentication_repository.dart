import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:remindere/features/authentication/screens/login/login.dart';
import 'package:remindere/features/authentication/screens/select_team/select_team.dart';
import 'package:remindere/navigation_menu.dart';
import 'package:remindere/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:remindere/utils/exceptions/firebase_exceptions.dart';
import 'package:remindere/utils/exceptions/format_exceptions.dart';
import 'package:remindere/utils/exceptions/platform_exceptions.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  // Variables
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  // Get Authenticated User Data
  User? get authUser => _auth.currentUser;

  // Called from main.dart on app launch
  @override
  void onReady() {
    // Remove the native splash screen
    FlutterNativeSplash.remove();
    // Redirect to the correct screen
    screenRedirect();
  }

  // Function to Show Relevant Screen
  void screenRedirect() async {
    final user = _auth.currentUser;

    if (user != null) {
      // If user is logged in
      Get.offAll(() => const NavigationMenu());

      if (deviceStorage.read('CurrentTeam') == null) {
        Get.to(() => const TeamSelectionScreen());
      }
      // } else {
      //   Get.offAll(() => const NavigationMenu());
      // }
    } else {
      // Local Storage
      deviceStorage.writeIfNull('firstTime', true);
      deviceStorage.read('firstTime') == true
          ? Get.offAll(() =>
              const LoginScreen()) // Should change to onboarding screen, if first time user
          : Get.offAll(() => const LoginScreen());
    }
  }

  /* ---- Email & Passwrod sign-in ---- */

  // SignIn
  Future<UserCredential> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
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

  // Register
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
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
