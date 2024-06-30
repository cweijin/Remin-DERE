import 'package:flutter/material.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/features/taskallocation/models/task_model.dart';

class RTaskBlock extends StatelessWidget {
  final TaskModel task;

  const RTaskBlock({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      InkWell(
        splashColor: Colors.grey,
        onTap: () {_showEventDetails(context);},
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              height: 200,
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text(task.taskName)],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(width: RSizes.spaceBtwItems),
    ]);
  }

  // display a pop up with event details
  void _showEventDetails(BuildContext context) {
    showModalBottomSheet(context: context, builder: (BuildContext bc) {
      return Container(
        height: MediaQuery.of(context).size.height*.60,    // Task detail popup-box size
        child: Padding(
          padding: const EdgeInsets.all(RSizes.borderRadiusMd),
          child: Column(         
            children: [
              const Text(
                'Task Details',
                style: TextStyle(
                  fontSize: RSizes.lg
                ),
              ),
              Text(
                "Task name: ${task.taskName}",
                style: const TextStyle(
                  fontSize: RSizes.md
                ),
              ),
              Text(
                "Task Description: ${task.taskDescription}",
                style: const TextStyle(
                  fontSize: RSizes.md
                ),
              ),

              // to display list of assignees, temporarily using string to show list
              Text(
                "Assignees: ${task.assignees.join('')}",
                style: const TextStyle(
                  fontSize: RSizes.md
                ),
              ),

              // to display dueDate
              Text(
                "Due Date: ${task.dueDate.toString()}",
                style: const TextStyle(
                  fontSize: RSizes.md
                ),
              ),

              // to display list of attachments
              Text(
                "Attachments: not implemented yet",
                style: const TextStyle(
                  fontSize: RSizes.md
                ),
              ),
            ]
          )
        )
      );
    });
  }

}
