import 'package:get/get.dart';
import 'package:remindere/data/repositories/calendar_event_repository/calendar_event_repository.dart';
import 'package:remindere/features/taskallocation/models/task_model.dart';
import 'package:remindere/utils/popups/loaders.dart';

class CalendarTaskController extends GetxController {
  static CalendarTaskController get instance => Get.find();

  final taskRepository = Get.put(CalendarEventRepository());
  RxBool refreshData = true.obs;

  // Fetch all user specific tasks.
  Future<List<TaskModel>> getAllUserTasks() async {
    try {
      final tasks = await taskRepository.fetchTaskList();
      return tasks;
    } catch (e) {
      RLoaders.errorSnackBar(title: 'Task not found', message: e.toString());
      return [];
    }
  }
}
