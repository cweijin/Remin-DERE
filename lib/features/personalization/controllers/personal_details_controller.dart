import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindere/data/repositories/user/user_repository.dart';
import 'package:remindere/features/personalization/controllers/user_controller.dart';
import 'package:remindere/features/personalization/models/user_model.dart';
import 'package:remindere/utils/helpers/network_manager.dart';
import 'package:remindere/utils/popups/full_screen_loader.dart';
import 'package:remindere/utils/popups/loaders.dart';

class PersonalDetailsController extends GetxController {
  static PersonalDetailsController get instance => Get.find();

  // Controllers
  final user = UserController.instance;

  // Variables
  final firstName = TextEditingController(); // Controller for first name input
  final lastName = TextEditingController(); // Controller for last name input
  final username = TextEditingController(); // Controller for username input
  final phoneNumber =
      TextEditingController(); // Controller for phone number input
  GlobalKey<FormState> detailsFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    firstName.text = user.user.value.firstName;
    lastName.text = user.user.value.lastName;
    username.text = user.user.value.username;
    phoneNumber.text = user.user.value.phoneNumber;
  }

  // Signup
  Future<void> updateDetails() async {
    try {
      // Start loading
      RFullScreenLoader.openLoadingDialog('Processing your information...');

      // Check Internet Connectivity
      final bool hasConnection = await NetworkManager.instance.isConnected();
      if (!hasConnection) {
        RFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!detailsFormKey.currentState!.validate()) {
        RFullScreenLoader.stopLoading();
        return;
      }

      // Save authenticated user data in Firebase Firestore
      final newDetails = UserModel(
        id: user.user.value.id,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        username: username.text.trim(),
        email: user.user.value.email,
        phoneNumber: phoneNumber.text.trim(),
        profilePicture: user.user.value.profilePicture,
      );

      final userRepository = UserRepository.instance;

      await userRepository.updateUserDetails(newDetails);

      await user.fetchUserRecord();

      Get.back();

      // Remove Loader
      RFullScreenLoader.stopLoading();

      // Show success message
      RLoaders.successSnackBar(
          title: 'Congratulations', message: 'Your details have been updated!');
    } catch (e) {
      // Remove Loader
      RFullScreenLoader.stopLoading();

      RLoaders.errorSnackBar(
          title: 'Some error occured :(', message: e.toString());
    }
  }
}
