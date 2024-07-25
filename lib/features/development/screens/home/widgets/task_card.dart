import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:remindere/utils/constants/colors.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/features/taskallocation/models/task_model.dart';
import 'package:remindere/utils/formatters/formatter.dart';

class RTaskCard extends StatelessWidget {
  final TaskModel task;

  const RTaskCard({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      InkWell(
        splashColor: RColors.grey,
        radius: 50,
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          _showEventDetails(context);
        },
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 6,
          // color: const Color.fromARGB(255, 243, 249, 241),
          child: Column(
            children: [
              Container(
                color: const Color.fromARGB(255, 42, 55, 64),
                height: 150,
                width: 250,
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
                    Text(
                      "Attachments: not implemented yet",
                      style: const TextStyle(fontSize: RSizes.md),
                    ),
                  ])));
        });
  }
}
