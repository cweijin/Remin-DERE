import 'package:get/get.dart';
import 'package:remindere/data/repositories/notification/notification_repository.dart';
import 'package:remindere/features/development/models/notification/notification_model.dart';
import 'package:remindere/features/personalization/controllers/user_controller.dart';
import 'package:remindere/utils/popups/loaders.dart';

class NotificationController extends GetxController {
  static NotificationController get instance => Get.find();

  final notificationRepository = NotificationRepository.instance;
  final user = UserController.instance;

  // Fetch all user specific teams
  Stream<List<NotificationModel>> getNotifications() {
    try {
      final notifications = notificationRepository
          .fetchNotifications()
          .map<List<NotificationModel>>((snapshot) => snapshot.docs
              .map((e) => NotificationModel.fromSnapshot(e))
              .toList());

      return notifications;
    } catch (e) {
      RLoaders.errorSnackBar(
          title: 'Notification Error', message: e.toString());
      return const Stream.empty();
    }
  }
}
