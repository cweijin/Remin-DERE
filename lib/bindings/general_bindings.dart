import 'package:get/get.dart';
import 'package:remindere/data/repositories/calendar_event_repository/task_repository.dart';
import 'package:remindere/data/repositories/notification/notification_repository.dart';
import 'package:remindere/data/repositories/team/team_repository.dart';
import 'package:remindere/data/repositories/user/user_repository.dart';
import 'package:remindere/features/authentication/controllers/forget_password/forget_password_controller.dart';
import 'package:remindere/features/calendar/controllers/task_controller.dart';
import 'package:remindere/features/development/controllers/notification/notification_controller.dart';
import 'package:remindere/features/personalization/controllers/account_security_controller.dart';
import 'package:remindere/features/personalization/controllers/personal_details_controller.dart';
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
    Get.lazyPut<TaskController>(() => TaskController(), fenix: true);
    Get.lazyPut<UserController>(() => UserController(), fenix: true);
    Get.lazyPut<NotificationController>(() => NotificationController(),
        fenix: true);
    Get.lazyPut<TaskManagementController>(() => TaskManagementController(),
        fenix: true);
    Get.lazyPut<PersonalDetailsController>(() => PersonalDetailsController(),
        fenix: true);
    Get.lazyPut<ForgetPasswordController>(() => ForgetPasswordController(),
        fenix: true);
    Get.lazyPut<AccountSecurityController>(() => AccountSecurityController(),
        fenix: true);

    // Repository
    Get.lazyPut<UserRepository>(() => UserRepository(), fenix: true);
    Get.lazyPut<TaskRepository>(() => TaskRepository(), fenix: true);
    Get.lazyPut<NotificationRepository>(() => NotificationRepository(),
        fenix: true);
    Get.lazyPut<TeamRepository>(() => TeamRepository(), fenix: true);
  }
}
