import 'package:get/get.dart';
import 'package:remindere/features/personalization/controllers/team_controller.dart';
import 'package:remindere/utils/helpers/network_manager.dart';

class GeneralBingdings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(TeamController());
  }
}
