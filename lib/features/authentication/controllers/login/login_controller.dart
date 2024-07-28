import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:remindere/data/repositories/authentication_repository/authentication_repository.dart';
import 'package:remindere/features/personalization/controllers/user_controller.dart';
import 'package:remindere/utils/helpers/network_manager.dart';
import 'package:remindere/utils/popups/full_screen_loader.dart';
import 'package:remindere/utils/popups/loaders.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();
  // Variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  final user = UserController.instance;
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    email.text = localStorage.read('rememberEmail') ?? '';
    super.onInit();
  }

  // Email Password Sign-in
  Future<void> emailAndPasswordSignIn() async {
    try {
      // Start Loading
      RFullScreenLoader.openLoadingDialog('Logging you in...');

      // Check Internet Connectivity
      final bool hasConnection = await NetworkManager.instance.isConnected();
      if (!hasConnection) {
        RFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation (email is hadled through autovalidation, this is just to ensure password field is not empty)
      if (!loginFormKey.currentState!.validate()) {
        RFullScreenLoader.stopLoading();
        return;
      }

      // Save Local Data if Remember Me is selected or remove local data if remember me is not selected
      if (rememberMe.value) {
        await localStorage.write('rememberEmail', email.text.trim());
      } else {
        await localStorage.remove('rememberEmail');
      }

      await AuthenticationRepository.instance
          .loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      // Remove Loader
      RFullScreenLoader.stopLoading();

      // Redirect
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      // Remove Loader
      RFullScreenLoader.stopLoading();

      RLoaders.errorSnackBar(
          title: 'Some error occured :(', message: e.toString());
    }
  }

  // Google SignIn Auth
  Future<void> googleSignIn() async {
    try {
      // Start Loading
      RFullScreenLoader.openLoadingDialog('Logging you in...');

      // Check Internet Connectivity
      final bool hasConnection = await NetworkManager.instance.isConnected();
      if (!hasConnection) {
        RFullScreenLoader.stopLoading();
        return;
      }

      // Google Auth
      final userCredentials =
          await AuthenticationRepository.instance.signInWithGoogle();

      // Save user record
      await user.saveUserRecord(userCredentials);

      // Remove Loader
      RFullScreenLoader.stopLoading();

      // Redirect
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      // Remove Loader
      RFullScreenLoader.stopLoading();

      RLoaders.errorSnackBar(
          title: 'Some error occured :(', message: e.toString());
    } finally {
      // Remove Loader
      RFullScreenLoader.stopLoading();
    }
  }
}
