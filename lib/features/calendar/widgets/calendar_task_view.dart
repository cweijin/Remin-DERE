import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindere/utils/helpers/cloud_helper_functions.dart';
import 'package:remindere/features/calendar/controllers/calendar_task_controller.dart';
import 'package:remindere/features/taskallocation/screens/widgets/task_list.dart';

class RTaskView extends StatelessWidget {
  const RTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CalendarTaskController.instance;

    // to show assigned tasks
    return Expanded(
      child: Obx(
        () => FutureBuilder(
          // Use key to trigger refresh
          key: Key(controller.refreshData.value.toString()),
          future: controller.getUserTasks(DateTime
              .now()), // currently set to only show tasks due after today.
          builder: (context, snapshot) {
            // Helper function to handle loader, no record, or error message
            final response =
                RCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot);
            if (response != null) return response;

            final tasks = snapshot.data!;

            return TaskList(tasks: tasks);
          },
        ),
      ),
    );
  }
}
