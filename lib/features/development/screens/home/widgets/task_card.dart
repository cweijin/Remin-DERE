import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindere/features/task_management/screens/task_management.dart';
import 'package:remindere/features/task_allocation/models/task_model.dart';
import 'package:remindere/utils/constants/colors.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/formatters/formatter.dart';
import 'package:remindere/utils/helpers/helper_functions.dart';

class RTaskCard extends StatelessWidget {
  final TaskModel task;
  final bool isDark;

  const RTaskCard({
    super.key,
    required this.task,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          splashColor: RColors.grey,
          radius: 50,
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Get.to(() => TaskManagementScreen(task: task));
          },
          child: Card(
            clipBehavior: Clip.antiAlias,
            elevation: 6,
            color: isDark
                ? Colors.transparent
                : const Color.fromARGB(255, 243, 249, 241),
            child: Column(
              children: [
                Container(
                  color: const Color.fromARGB(255, 42, 55, 64),
                  height: 150,
                  width: 250,
                  child: Padding(
                    padding: const EdgeInsets.all(RSizes.defaultSpace),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: RSizes.md),
                                child: Text(
                                    RHelperFunctions.getTaskStatus(task.status),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 250,
                  child: Padding(
                    padding: const EdgeInsets.all(RSizes.md),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.taskName,
                          style: Theme.of(context).textTheme.headlineSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: RSizes.xs),
                        Text(RFormatter.formatDate(task.dueDate)),
                        Text(
                          task.assignees.toString(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Container(
          //   decoration: BoxDecoration(
          //     color: RColors.primary,
          //     borderRadius: BorderRadius.circular(10),
          //   ),
          //   height: 200,
          //   width: 200,
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [Text(task.taskName)],
          //   ),
          // ),
        ),
        const SizedBox(width: RSizes.spaceBtwItems),
      ],
    );
  }
}
