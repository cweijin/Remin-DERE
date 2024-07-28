import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindere/features/task_management/screens/task_management.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/device/device_utility.dart';
import 'package:remindere/features/task_allocation/models/task_model.dart';
import 'package:remindere/utils/formatters/formatter.dart';
import 'package:remindere/utils/helpers/helper_functions.dart';

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

    return Column(
      children: [
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(task.taskName,
                          style: Theme.of(context).textTheme.headlineSmall),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: switch (task.status) {
                            TaskStatus.toDo => Colors.grey[300],
                            TaskStatus.inProgress => Colors.blue[300],
                            TaskStatus.completed => Colors.green[300],
                            TaskStatus.overdue => Colors.red[300],
                          },
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: RSizes.md),
                          child: Text(
                              RHelperFunctions.getTaskStatus(task.status),
                              style: Theme.of(context).textTheme.headlineSmall),
                        ),
                      )
                    ],
                  ),
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
      ],
    );
  }
}
