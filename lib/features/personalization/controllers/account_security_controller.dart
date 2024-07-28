import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindere/data/repositories/authentication_repository/authentication_repository.dart';
import 'package:remindere/features/authentication/screens/login/login.dart';
import 'package:remindere/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:remindere/features/personalization/controllers/user_controller.dart';
import 'package:remindere/features/personalization/screens/account_security/re_authenticate.dart';
import 'package:remindere/features/personalization/screens/account_security/reset_email.dart';
import 'package:remindere/features/personalization/screens/account_security/update_email.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/helpers/network_manager.dart';
import 'package:remindere/utils/popups/full_screen_loader.dart';
import 'package:remindere/utils/popups/loaders.dart';

class AccountSecurityController extends GetxController {
  static AccountSecurityController get instance => Get.find();

  //Controllers
  final user = UserController.instance;

  // Variables
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> newEmailFormKey = GlobalKey<FormState>();
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  final newEmail = TextEditingController();
  RxBool hidePassword = true.obs;

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

      await AuthenticationRepository.instance
          .sendPasswordResetEmail(user.user.value.email);

      //Remove Loader
      RFullScreenLoader.stopLoading();

      // Show success screen
      RLoaders.successSnackBar(
          title: 'Email sent',
          message: 'Check your email for the reset password link'.tr);

      //Redirect
      Get.off(() => ResetPasswordScreen(email: user.user.value.email));
    } catch (e) {
      //Remove Loader
      RFullScreenLoader.stopLoading();

      // Show error screen
      RLoaders.errorSnackBar(title: 'Oh no :(', message: e.toString());
    }
  }

  // Send verification email to update new email
  void updateEmail() async {
    try {
      // Start Loading
      RFullScreenLoader.openLoadingDialog('Processing your request...');

      // Check internet connection
      final hasConnection = await NetworkManager.instance.isConnected();

      if (!hasConnection) {
        RFullScreenLoader.stopLoading();
        return;
      }

      if (!newEmailFormKey.currentState!.validate()) {
        RFullScreenLoader.stopLoading();
        return;
      }

      String newEmail = this.newEmail.text.trim();

      await AuthenticationRepository.instance.updateEmail(newEmail);

      //Remove Loader
      RFullScreenLoader.stopLoading();

      //Redirect
      Get.off(() => ResetEmailScreen(email: newEmail));

      resetFormField();

      // Show success screen
      RLoaders.successSnackBar(
          title: 'Email sent',
          message:
              'Check your new email to verify before it will be updated'.tr);
    } catch (e) {
      //Remove Loader
      RFullScreenLoader.stopLoading();

      // Show error screen
      RLoaders.errorSnackBar(title: 'Oh no :(', message: e.toString());
    }
  }

  // resend email updating verification email
  void resendUpdateEmail(String email) async {
    try {
      // Start Loading
      RFullScreenLoader.openLoadingDialog('Processing your request...');

      // Check internet connection
      final hasConnection = await NetworkManager.instance.isConnected();

      if (!hasConnection) {
        RFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.updateEmail(email);

      //Remove Loader
      RFullScreenLoader.stopLoading();

      // Show success screen
      RLoaders.successSnackBar(
          title: 'Email sent',
          message:
              'Check your new email to verify before it will be updated'.tr);
    } catch (e) {
      //Remove Loader
      RFullScreenLoader.stopLoading();

      // Show error screen
      RLoaders.errorSnackBar(title: 'Oh no :(', message: e.toString());
    }
  }

  Future<void> reAuthenticateUser({bool emailRequired = true}) async {
    try {
      // Start Loading
      RFullScreenLoader.openLoadingDialog('Processing...');

      // Check internet connection
      final hasConnection = await NetworkManager.instance.isConnected();

      if (!hasConnection) {
        RFullScreenLoader.stopLoading();
        return;
      }

      if (!reAuthFormKey.currentState!.validate()) {
        RFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance
          .reAuthenticateWithEmailAndPassword(
              emailRequired ? verifyEmail.text.trim() : user.user.value.email,
              verifyPassword.text.trim());

      // Currently only two scenario, email not required when updating email
      if (!emailRequired) {
        //Remove Loader
        RFullScreenLoader.stopLoading();
        Get.off(() => const UpdateEmailScreen());
      } else {
        await AuthenticationRepository.instance.deleteAccount();
        //Remove Loader
        RFullScreenLoader.stopLoading();
        Get.offAll(() => const LoginScreen());
        RLoaders.successSnackBar(
            title: 'Account Removed',
            message: 'Your account along with all data have been removed.');
      }

      resetFormField();
    } catch (e) {
      //Remove Loader
      RFullScreenLoader.stopLoading();

      // Show error screen
      RLoaders.errorSnackBar(title: 'Oh no :(', message: e.toString());
    }
  }

  // Delete Account Warning
  void deleteAccountWarningPopup() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(RSizes.md),
      title: 'Delete Account',
      middleText:
          'Are you sure you want to delete your account permanently? This action is not reversible and all of your data will be removed permanently.',
      confirm: ElevatedButton(
        onPressed: () {
          Navigator.of(Get.overlayContext!).pop();
          Get.to(() => const ReAuthenticateScreen(emailRequired: true));
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            side: const BorderSide(color: Colors.red)),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: RSizes.lg),
          child: Text('Delete'),
        ),
      ),
      cancel: OutlinedButton(
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
        child: const Text('Cancel'),
      ),
    );
  }

  // Send verification email to update new email
  Future<void> deleteUserAccount() async {
    try {
      // Start Loading
      RFullScreenLoader.openLoadingDialog('Processing...');

      // Check internet connection
      final hasConnection = await NetworkManager.instance.isConnected();

      if (!hasConnection) {
        RFullScreenLoader.stopLoading();
        return;
      }

      // First re-authenticate user
      final auth = AuthenticationRepository.instance;
      final provider =
          auth.authUser!.providerData.map((e) => e.providerId).first;

      if (provider == 'google.com') {
        await auth.signInWithGoogle();
        await auth.deleteAccount();
        RFullScreenLoader.stopLoading();
        Get.offAll(() => const LoginScreen());
        RLoaders.successSnackBar(
            title: 'Account Removed',
            message: 'Your account along with all data have been removed.');
      } else if (provider == 'password') {
        RFullScreenLoader.stopLoading();
        Get.to(() => const ReAuthenticateScreen(emailRequired: true));
      }
    } catch (e) {
      //Remove Loader
      RFullScreenLoader.stopLoading();

      // Show error screen
      RLoaders.errorSnackBar(title: 'Oh no :(', message: e.toString());
    }
  }

  void resetFormField() {
    verifyEmail.clear();
    verifyPassword.clear();
    newEmail.clear();
  }
}
