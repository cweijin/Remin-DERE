import 'package:get/get.dart';
import 'package:remindere/utils/helpers/network_manager.dart';

class GeneralBingdings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
  }
}
