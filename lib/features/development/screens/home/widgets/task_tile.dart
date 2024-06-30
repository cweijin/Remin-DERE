import 'package:flutter/material.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/device/device_utility.dart';
import 'package:remindere/features/taskallocation/models/task_model.dart';

class RTaskTile extends StatelessWidget {
  final TaskModel task;
  // final String? task;

  const RTaskTile({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    final width = RDeviceUtils.getScreenWidth(context);

    return Column(children: [
      InkWell(
        splashColor: Colors.grey,
        onTap: () {
          _showEventDetails(context);
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 100,
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text(task ?? ''),
              Text(task.taskName),
            ],
          ),
        ),
      ),
      const SizedBox(height: RSizes.spaceBtwItems),
    ]);
  }

  // display a pop up with event details
  void _showEventDetails(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              height: MediaQuery.of(context).size.height *
                  .60, // Task detail popup-box size
              child: Padding(
                  padding: const EdgeInsets.all(RSizes.borderRadiusMd),
                  child: Column(children: [
                    const Text(
                      'Task Details',
                      style: TextStyle(fontSize: RSizes.lg),
                    ),
                    Text(
                      "Task name: ${task.taskName}",
                      style: const TextStyle(fontSize: RSizes.md),
                    ),
                    Text(
                      "Task Description: ${task.taskDescription}",
                      style: const TextStyle(fontSize: RSizes.md),
                    ),

                    // to display list of assignees, temporarily using string to show list
                    Text(
                      "Assignees: ${task.assignees.join('')}",
                      style: const TextStyle(fontSize: RSizes.md),
                    ),

                    // to display dueDate
                    Text(
                      "Due Date: ${task.dueDate.day}-${task.dueDate.month}-${task.dueDate.year}",
                      style: const TextStyle(fontSize: RSizes.md),
                    ),

                    // to display list of attachments
                    Text(
                      "Attachments: not implemented yet",
                      style: const TextStyle(fontSize: RSizes.md),
                    ),
                  ])));
        });
  }
}
