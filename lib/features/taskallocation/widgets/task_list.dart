import 'package:flutter/material.dart';
import 'package:remindere/common/styles/spacing_styles.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/features/taskallocation/models/task_model.dart';
import 'package:remindere/features/taskallocation/widgets/task_list_item.dart';


class TaskList extends StatelessWidget {
  // this helps build the changeable list of events. based on a to-do list.
  final List<TaskModel> tasks;

  const TaskList({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: RSizes.spaceBtwItems); // seperation of scrollables
      },
      itemCount: tasks.length,
      scrollDirection: Axis.vertical,
      padding: RSpacingStyle.paddingWithAppBarHeight,
      itemBuilder: (BuildContext context, int index) {
        tasks.sort(((taskA, taskB) => taskA.dueDate.compareTo(taskB.dueDate)));   // arrange based on dueDate
        return TaskListItem(task: tasks[index]);
      },
    );
  }
}
