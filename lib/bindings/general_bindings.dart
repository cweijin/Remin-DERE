import 'package:get/get.dart';
import 'package:remindere/data/repositories/calendar_event_repository/task_repository.dart';
import 'package:remindere/data/repositories/notification/notification_repository.dart';
import 'package:remindere/data/repositories/user/user_repository.dart';
import 'package:remindere/features/calendar/controllers/calendar_task_controller.dart';
import 'package:remindere/features/development/controllers/notification/notification_controller.dart';
import 'package:remindere/features/personalization/controllers/team_controller.dart';
import 'package:remindere/features/personalization/controllers/user_controller.dart';
import 'package:remindere/features/task_management/controllers/task_management_controller.dart';
import 'package:remindere/features/teaming/controllers/create_team/create_team_controller.dart';
import 'package:remindere/utils/helpers/network_manager.dart';

class GeneralBingdings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NetworkManager>(() => NetworkManager());
    Get.lazyPut<TeamController>(() => TeamController(), fenix: true);
    Get.lazyPut<CreateTeamController>(() => CreateTeamController(),
        fenix: true);
    Get.lazyPut<CalendarTaskController>(() => CalendarTaskController(),
        fenix: true);
    Get.lazyPut<UserController>(() => UserController(), fenix: true);
    Get.lazyPut<NotificationController>(() => NotificationController(),
        fenix: true);
    Get.lazyPut<TaskManagementController>(() => TaskManagementController(),
        fenix: true);

    // Repository
    Get.lazyPut<UserRepository>(() => UserRepository(), fenix: true);
    Get.lazyPut<TaskRepository>(() => TaskRepository(), fenix: true);
    Get.lazyPut<NotificationRepository>(() => NotificationRepository(),
        fenix: true);
  }
}
