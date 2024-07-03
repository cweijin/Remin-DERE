import 'package:flutter/material.dart';
import 'package:remindere/utils/constants/colors.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/features/taskallocation/models/task_model.dart';

class TaskListItem extends StatelessWidget {
  final TaskModel task;

  const TaskListItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  _showEventDetails(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: RColors.lightOrange,
                  padding: const EdgeInsets.all(RSizes.borderRadiusLg),
                  side: const BorderSide(
                    color: RColors.lightestOrange,
                  ),                  
                ),
                child: Row(children: [
                  // duedate on the left
                  Text(
                    "${task.dueDate.day}-${task.dueDate.month}-${task.dueDate.year}",
                    style: const TextStyle(
                      color: RColors.textPrimary
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true                    
                  ),

                  // Task Name on the right
                  Expanded(child:
                    Column(
                      children: [
                        // task name
                        Center(child: Text(task.taskName))
                      ]
                    )
                )
              ])            
      )
    );  
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
                "Due Date: ${task.dueDate.day}-${task.dueDate.month}-${task.dueDate.year}",
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