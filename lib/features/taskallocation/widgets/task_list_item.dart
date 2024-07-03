import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:remindere/utils/constants/colors.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/features/taskallocation/models/task_model.dart';

class TaskListItem extends StatelessWidget {
  final TaskModel task;

  static const List<String> listOfMonths = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  static const List<String> listOfDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  const TaskListItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
              height: 70,
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
                  Container(
                    padding: const EdgeInsets.all(RSizes.borderRadiusLg),
                    child: Column(
                      children: [
                        // Day
                        Text(
                          "${task.dueDate.day} ${listOfMonths[task.dueDate.month-1]}",
                          style: const TextStyle(
                            color: RColors.textSecondary
                          ),
                          textAlign: TextAlign.center,
                          softWrap: true                    
                        ),

                        // Weekday
                        Text(
                          listOfDays[task.dueDate.weekday-1],
                          style: const TextStyle(
                            color: RColors.textSecondary
                          ),
                          textAlign: TextAlign.center,
                          softWrap: true                    
                        )
                      ]
                    )
                  ),
                  // Task Name on the right
                  Container(
                    padding: const EdgeInsets.all(RSizes.borderRadiusLg),
                        child: Text(
                          task.taskName,
                          style: const TextStyle(
                            color: RColors.textWhite
                          ),
                          textAlign: TextAlign.left,
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