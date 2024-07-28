import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:remindere/data/repositories/calendar_event_repository/task_repository.dart';
import 'package:remindere/features/calendar/controllers/task_controller.dart';
import 'package:remindere/features/personalization/controllers/user_controller.dart';
import 'package:remindere/features/personalization/models/user_model.dart';
import 'package:remindere/features/task_allocation/models/task_model.dart';
import 'package:remindere/features/task_management/models/comment_model.dart';
import 'package:remindere/features/task_management/models/submission_model.dart';
import 'package:remindere/utils/helpers/network_manager.dart';
import 'package:remindere/utils/popups/full_screen_loader.dart';
import 'package:remindere/utils/popups/loaders.dart';

class TaskManagementController extends GetxController {
  static TaskManagementController get instance => Get.find();

  final user = UserController.instance;
  final task = TaskController.instance;
  final comment = TextEditingController();
  final message = TextEditingController();
  final RxList<XFile> attachments = <XFile>[].obs;
  final Rx<UserModel> view = UserModel.empty().obs;

  final taskRepository = TaskRepository.instance;

  final userModel = UserController.instance.user.value;

  final deviceStorage = GetStorage();

  void postComment(String taskId,
      {bool isPrivate = false, bool isOwner = false}) async {
    if (isPrivate && message.text.isEmpty) return;
    if (!isPrivate && comment.text.isEmpty) return;

    final model = CommentModel(
      comment: isPrivate ? message.text.trim() : comment.text.trim(),
      ownerId: UserController.instance.user.value.id,
      taskId: taskId,
      createdAt: DateTime.timestamp(),
    );

    try {
      taskRepository.saveComment(
          model, isPrivate, isOwner ? view.value.id : user.user.value.id);
      // Clear user input after comment is posted.
      comment.clear();
      message.clear();
    } catch (e) {
      RLoaders.errorSnackBar(
          title: 'Oops', message: 'Something went wrong: $e');
    }
  }

  // Fetch comment to display, set isPrivate true when used for private comment
  Stream<List<CommentModel>> getComment(String taskId,
      {bool isPrivate = false, String? assigneeId}) {
    try {
      return taskRepository.fetchComment(
          taskId, assigneeId ?? user.user.value.id, isPrivate);
    } catch (e) {
      RLoaders.errorSnackBar(
          title: 'Oops', message: 'Something went wrong: $e');
      return const Stream.empty();
    }
  }

  // Download file from Storage url
  void downloadAttachment(String url) async {
    await taskRepository.downloadFile(url);
  }

  // Get submission attachments
  void getSubmissionAttachments() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
      );

      if (result != null) {
        attachments.value = result.xFiles;
        attachments.refresh();
      }
    } catch (e) {
      RLoaders.errorSnackBar(
          title: 'Oops', message: 'Something went wrong: $e');
    }
  }

  // Fetch submission model from Firebase from asignee id.
  Future<SubmissionModel> getSubmission(String teamId, String taskId,
      {bool isOwner = false}) async {
    try {
      return await taskRepository.fetchSubmission(
          teamId, taskId, isOwner ? view.value.id : user.user.value.id);
    } catch (e) {
      RLoaders.errorSnackBar(
          title: 'Oops', message: 'Something went wrong: $e');
      return SubmissionModel.empty();
    }
  }

  void submitWork(TaskModel task) async {
    try {
      // Start loading
      RFullScreenLoader.openLoadingDialog('Submitting your work...');

      // Check Internet Connectivity
      final bool hasConnection = await NetworkManager.instance.isConnected();

      if (!hasConnection) {
        RFullScreenLoader.stopLoading();
        return;
      }

      // Upload selected files to Firebase Storage
      final attachmentUrls = await taskRepository.uploadFiles(
          'Teams/${deviceStorage.read('CurrentTeam')}/Submission/',
          attachments);

      // Save authenticated user data in Firebase Firestore
      final newSubmission = SubmissionModel(
        attachments: attachmentUrls,
        taskOwnerId: task.owner,
        taskId: task.id!,
        taskName: task.taskName,
        submittedAt: DateTime.timestamp(),
      );

      await taskRepository.saveSubmissionDetails(newSubmission);

      // Remove Loader
      RFullScreenLoader.stopLoading();

      // Show success message
      RLoaders.successSnackBar(
          title: 'Congratulations', message: 'Submitted successfully!');
    } catch (e) {
      // Remove Loader
      RFullScreenLoader.stopLoading();

      RLoaders.errorSnackBar(
          title: 'Some error occured :(', message: e.toString());
    }
  }

  void markAsCompleted(TaskModel task) async {
    try {
      // Start loading
      RFullScreenLoader.openLoadingDialog('Processing...');

      // Check Internet Connectivity
      final bool hasConnection = await NetworkManager.instance.isConnected();

      if (!hasConnection) {
        RFullScreenLoader.stopLoading();
        return;
      }

      await taskRepository.updateTaskStatus(TaskStatus.completed, task);

      // Remove Loader
      RFullScreenLoader.stopLoading();

      // Show success message
      RLoaders.successSnackBar(
          title: 'Congratulations', message: 'Marked as complete!');
    } catch (e) {
      // Remove Loader
      RFullScreenLoader.stopLoading();

      RLoaders.errorSnackBar(
          title: 'Some error occured :(', message: e.toString());
    }
  }

  void deleteTask(TaskModel task) async {
    try {
      // Start loading
      RFullScreenLoader.openLoadingDialog('Deleting...');

      // Check Internet Connectivity
      final bool hasConnection = await NetworkManager.instance.isConnected();

      if (!hasConnection) {
        RFullScreenLoader.stopLoading();
        return;
      }

      await taskRepository.removeTaskDetails(task);

      // Tells obx to refresh the assigned task list
      this.task.refreshData.toggle();

      Get.back();

      // Remove Loader
      RFullScreenLoader.stopLoading();

      // Show success message
      RLoaders.successSnackBar(
          title: 'Congratulations', message: 'Task deleted!');
    } catch (e) {
      // Remove Loader
      RFullScreenLoader.stopLoading();

      RLoaders.errorSnackBar(
          title: 'Some error occured :(', message: e.toString());
    }
  }

  void selectView(UserModel model) {
    view.value = model;
    view.refresh();
  }
}
