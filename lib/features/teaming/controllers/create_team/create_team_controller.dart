import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:remindere/data/repositories/team/team_repository.dart';
import 'package:remindere/data/repositories/user/user_repository.dart';
import 'package:remindere/features/personalization/models/user_model.dart';
import 'package:remindere/features/teaming/models/team_model.dart';
import 'package:remindere/utils/helpers/network_manager.dart';
import 'package:remindere/utils/popups/full_screen_loader.dart';
import 'package:remindere/utils/popups/loaders.dart';

class CreateTeamController extends GetxController {
  static CreateTeamController get instance => Get.find();
  final name = TextEditingController();
  final members = TextEditingController();
  final localStorage = GetStorage();

  RxBool refreshData = true.obs;
  RxBool refreshSearchResult = true.obs;
  RxList<UserModel> selectedUsers = <UserModel>[].obs;
  List<UserModel> searchResults = [];

  void searchUsers(String input) async {
    try {
      final userRepository = Get.put(UserRepository());
      final allUsers = await userRepository.fetchAllUsers(input);

      searchResults = allUsers;
      refreshSearchResult.toggle();
    } catch (e) {
      RLoaders.errorSnackBar(title: 'User not found', message: e.toString());
    }
  }

  Future<void> createTeam() async {
    try {
      // Start loading
      RFullScreenLoader.openLoadingDialog('Creating your team...');

      // Check Internet Connectivity
      final bool hasConnection = await NetworkManager.instance.isConnected();
      if (!hasConnection) {
        RFullScreenLoader.stopLoading();
        return;
      }

      // Save authenticated user data in Firebase Firestore
      final newTeam = TeamModel(
        teamName: name.text.trim(),
        teamMembers: selectedUsers.map((model) => model.id).toList(),
        id: '',
      );

      final teamRepository = Get.put(TeamRepository());
      await teamRepository.saveTeamDetails(newTeam);

      // Remove Loader
      RFullScreenLoader.stopLoading();

      // Show success message
      RLoaders.successSnackBar(
          title: 'Congratulations',
          message: '${name.text.trim()} has been created!');

      // Refresh Teams Data
      refreshData
          .toggle(); // When refreshData is toggled, Obx will observe and rebuild the TeamCards

      // Reset fields
      resetFormField();

      // Move to profile screen
      Navigator.of(Get.context!).pop();
    } catch (e) {
      // Remove Loader
      RFullScreenLoader.stopLoading();

      RLoaders.errorSnackBar(
          title: 'Some error occured :(', message: e.toString());
    }
  }

  void resetFormField() {
    name.clear();
    members.clear();
    selectedUsers.clear();
    searchResults.clear();
  }
}
