import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindere/features/task_management/screens/task_management.dart';
import 'package:remindere/utils/constants/colors.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/device/device_utility.dart';
import 'package:remindere/features/task_allocation/models/task_model.dart';
import 'package:remindere/utils/formatters/formatter.dart';

class RTaskTile extends StatelessWidget {
  final TaskModel task;
  final bool isDark;
  // final String? task;

  const RTaskTile({
    super.key,
    required this.task,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final width = RDeviceUtils.getScreenWidth(context);

    return Column(children: [
      InkWell(
        splashColor: Colors.grey,
        onTap: () {
          Get.to(() => TaskManagementScreen(task: task));
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.transparent
                : const Color.fromARGB(255, 243, 249, 241),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.grey.withOpacity(0.3) : Colors.grey,
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          height: 100,
          width: width,
          child: Padding(
            padding: const EdgeInsets.all(RSizes.md),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: width,
                ),
                // Text(task ?? ''),
                Text(task.taskName,
                    style: Theme.of(context).textTheme.headlineSmall),
                Text(RFormatter.formatDate(task.dueDate)),
                Text(
                  task.assignees.toString(),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
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
          return SizedBox(
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
                    const Text(
                      "Attachments: not implemented yet",
                      style: TextStyle(fontSize: RSizes.md),
                    ),
                  ])));
        });
  }
}
