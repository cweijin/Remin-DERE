import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindere/utils/helpers/cloud_helper_functions.dart';
import 'package:remindere/features/calendar/controllers/task_controller.dart';
import 'package:remindere/features/task_allocation/screens/widgets/task_list.dart';

class RTaskView extends StatelessWidget {
  const RTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TaskController.instance;

    // to show assigned tasks
    return Expanded(
      child: Obx(
        () => FutureBuilder(
          // Use key to trigger refresh
          key: Key(controller.refreshData.value.toString()),
          future: (controller.team.value
              ? controller.getTeamTasks(Timestamp.now().toDate())
              : controller.getUserTasks(Timestamp.now()
                  .toDate())), // currently set to only show tasks due after today.
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
