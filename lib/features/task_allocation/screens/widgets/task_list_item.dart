import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindere/features/task_management/screens/task_management.dart';
import 'package:remindere/utils/constants/colors.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/features/task_allocation/models/task_model.dart';

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

  static const List<String> listOfDays = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun"
  ];

  const TaskListItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 80,
        child: ElevatedButton(
            onPressed: () {
              Get.to(TaskManagementScreen(task: task));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.all(RSizes.borderRadiusSm),
              side: const BorderSide(
                color: Colors.lightBlue,
              ),
            ),
            child: Row(children: [
              // duedate on the left
              Container(
                  padding: const EdgeInsets.all(RSizes.borderRadiusLg),
                  child: Column(children: [
                    // Day
                    Expanded(
                        child: Text(
                            "${task.dueDate.day} ${listOfMonths[task.dueDate.month - 1]}",
                            style: const TextStyle(
                                color: RColors.textWhite, fontSize: RSizes.lg),
                            textAlign: TextAlign.center,
                            softWrap: false)),

                    // Weekday
                    Text(listOfDays[task.dueDate.weekday - 1],
                        style: const TextStyle(
                            color: RColors.textWhite, fontSize: RSizes.md),
                        textAlign: TextAlign.center,
                        softWrap: false)
                  ])),

              // Task Name on the right
              Container(
                  padding: const EdgeInsets.all(RSizes.borderRadiusLg),
                  child: Text(
                    task.taskName,
                    style: const TextStyle(color: RColors.textWhite),
                    textAlign: TextAlign.left,
                  ))
            ])));
  }

  // display a pop up with event details
  // void _showEventDetails(BuildContext context) {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext bc) {
  //         return Container(
  //             height: MediaQuery.of(context).size.height *
  //                 .60, // Task detail popup-box size
  //             child: Padding(
  //                 padding: const EdgeInsets.all(RSizes.borderRadiusMd),
  //                 child: Column(children: [
  //                   const Text(
  //                     'Task Details',
  //                     style: TextStyle(fontSize: RSizes.lg),
  //                   ),
  //                   Text(
  //                     "Task name: ${task.taskName}",
  //                     style: const TextStyle(fontSize: RSizes.md),
  //                   ),
  //                   Text(
  //                     "Task Description: ${task.taskDescription}",
  //                     style: const TextStyle(fontSize: RSizes.md),
  //                   ),

  //                   // to display list of assignees, temporarily using string to show list
  //                   Text(
  //                     "Assignees: ${task.assignees.join('')}",
  //                     style: const TextStyle(fontSize: RSizes.md),
  //                   ),

  //                   // to display dueDate
  //                   Text(
  //                     "Due Date: ${task.dueDate.day}-${task.dueDate.month}-${task.dueDate.year}",
  //                     style: const TextStyle(fontSize: RSizes.md),
  //                   ),

  //                   // to display list of attachments
  //                   const Text(
  //                     "Attachments: not implemented yet",
  //                     style: TextStyle(fontSize: RSizes.md),
  //                   ),
  //                 ])));
  //       });
  // }
}
