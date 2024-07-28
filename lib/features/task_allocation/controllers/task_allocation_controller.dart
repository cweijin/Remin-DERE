import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:remindere/data/repositories/authentication_repository/authentication_repository.dart';
import 'package:remindere/data/repositories/calendar_event_repository/task_repository.dart';
import 'package:remindere/features/personalization/controllers/team_controller.dart';
import 'package:remindere/features/personalization/models/user_model.dart';
import 'package:remindere/features/task_allocation/models/task_model.dart';
import 'package:remindere/navigation_menu.dart';
import 'package:remindere/utils/helpers/network_manager.dart';
import 'package:remindere/utils/popups/full_screen_loader.dart';
import 'package:remindere/utils/popups/loaders.dart';

class TaskAllocationController extends GetxController {
  TaskAllocationController get instance => Get.find();

  // Variables
  final dueDate = TextEditingController(); // date editing controller
  final taskName = TextEditingController(); // task name editing controller
  final taskDescription =
      TextEditingController(); // task description editing controller
  final RxList<XFile> attachments =
      <XFile>[].obs; // attachment editing controller
  DateTime? _picked; // for datetime
  final navigate = NavigationController.instance; // To navigate screens
  TeamController team = Get.find();
  final multiSelectController = MultiSelectController<UserModel>();

  final taskRepository = TaskRepository.instance;
  final deviceStorage = GetStorage();

  GlobalKey<FormState> taskFormKey = GlobalKey<FormState>();

  RxBool showAttachment = true.obs;

  // Date Picker
  Future<void> selectDate(BuildContext context) async {
    _picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2100))
        .then(
      (value) async {
        if (value != null) {
          final time = await showTimePicker(
              context: context, initialTime: TimeOfDay.now());

          if (time != null) {
            return _picked =
                value.copyWith(hour: time.hour, minute: time.minute);
          }
        }
        return null;
      },
    );

    if (_picked != null) {
      dueDate.value = TextEditingValue(
          text:
              '${_picked.toString().split(':')[0]}:${_picked.toString().split(':')[1]}');
    }
  }

  // get a date if possible
  DateTime pickedDate() {
    if (_picked == null) {
      // else return current date (replace with validation check in manual_allocation.dart in future)
      return DateTime.now();
    }
    return _picked!;
  }

  // Create task
  Future<void> createTask() async {
    try {
      // Start loading
      RFullScreenLoader.openLoadingDialog('Processing task information...');

      // Check Internet Connectivity
      final bool hasConnection = await NetworkManager.instance.isConnected();
      if (!hasConnection) {
        RFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!taskFormKey.currentState!.validate()) {
        RFullScreenLoader.stopLoading();
        return;
      }

      // Upload selected files to Firebase Storage
      final attachmentUrls = await taskRepository.uploadFiles(
          'Teams/${deviceStorage.read('CurrentTeam')}/Attachments/',
          attachments);

      // Save authenticated user data in Firebase Firestore
      final newTask = TaskModel(
          taskName: taskName.text.trim(),
          taskDescription: taskDescription.text.trim(),
          assignees: multiSelectController.selectedOptions
              .map((item) => item.value!.id)
              .toList(),
          dueDate: DateTime.parse(dueDate.text.trim()),
          attachments: attachmentUrls,
          owner: AuthenticationRepository.instance.authUser!.uid,
          team: deviceStorage.read('CurrentTeam') ?? '',
          status: TaskStatus.toDo);

      await taskRepository.saveTaskDetails(newTask);

      // Remove Loader
      RFullScreenLoader.stopLoading();

      // Show success message
      RLoaders.successSnackBar(
          title: 'Congratulations', message: 'Task has been created!');

      // Reset fields
      resetFormField();

      // Navigate to home page
      navigate.navigateTo(0);

      // Move to home page
      Get.off(() => const NavigationMenu());
    } catch (e) {
      // Remove Loader
      RFullScreenLoader.stopLoading();

      RLoaders.errorSnackBar(
          title: 'Some error occured :(', message: e.toString());
    }
  }

  // Get task attachments
  void getTaskAttachments() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
      );

      if (result != null) {
        attachments.value = result.xFiles;
        attachments.refresh();
        // final attachmentUrls = await taskRepository.uploadFiles(
        //     'Teams/${deviceStorage.read('CurrentTeam')}/Attachments/',
        //     attachments);

        // RLoaders.successSnackBar(
        //     title: 'Congratulations', message: 'Files uploaded!');

        // return attachmentUrls;
      }
    } catch (e) {
      RLoaders.errorSnackBar(
          title: 'Oops', message: 'Something went wrong: $e');
    }
  }

  void resetFormField() {
    dueDate.clear();
    taskName.clear();
    taskDescription.clear();
    multiSelectController.clearAllSelection();
    attachments.clear();
    _picked = null;
  }
}
