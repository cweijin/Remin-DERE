import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindere/data/repositories/authentication_repository/authentication_repository.dart';
import 'package:remindere/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:remindere/utils/helpers/network_manager.dart';
import 'package:remindere/utils/popups/full_screen_loader.dart';
import 'package:remindere/utils/popups/loaders.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  // Variables
  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  // Send reset password email
  void sendPasswordResetEmail() async {
    try {
      // Start Loading
      RFullScreenLoader.openLoadingDialog('Processing your request...');

      // Check internet connection
      final hasConnection = await NetworkManager.instance.isConnected();

      if (!hasConnection) {
        RFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!forgetPasswordFormKey.currentState!.validate()) {
        RFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance
          .sendPasswordResetEmail(email.text.trim());

      //Remove Loader
      RFullScreenLoader.stopLoading();

      // Show success screen
      RLoaders.successSnackBar(
          title: 'Email sent',
          message: 'Check your email for the reset password link'.tr);

      //Redirect
      Get.off(() => ResetPasswordScreen(email: email.text.trim()));
    } catch (e) {
      //Remove Loader
      RFullScreenLoader.stopLoading();

      // Show error screen
      RLoaders.errorSnackBar(title: 'Oh no :(', message: e.toString());
    }
  }

  // Resend reset password email
  void resendPasswordResetEmail(String email) async {
    try {
      // Start Loading
      RFullScreenLoader.openLoadingDialog('Processing your request...');

      // Check internet connection
      final hasConnection = await NetworkManager.instance.isConnected();

      if (!hasConnection) {
        RFullScreenLoader.stopLoading();
        return;
      }

      // Send email to reset password
      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      //Remove Loader
      RFullScreenLoader.stopLoading();

      // Show success screen
      RLoaders.successSnackBar(
          title: 'Email sent',
          message: 'Check your email for the reset password link'.tr);
    } catch (e) {
      //Remove Loader
      RFullScreenLoader.stopLoading();

      // Show error screen
      RLoaders.errorSnackBar(title: 'Oh no :(', message: e.toString());
    }
  }
}
