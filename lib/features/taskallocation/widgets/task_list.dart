import 'package:flutter/material.dart';
import 'package:remindere/common/styles/spacing_styles.dart';
import 'package:remindere/features/taskallocation/models/task_model.dart';
import 'package:remindere/features/taskallocation/widgets/task_list_item.dart';


class TaskList extends StatelessWidget {
  // this helps build the changeable list of events. based on a to-do list.
  final List<TaskModel> tasks;

  TaskList({required this.tasks});

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      padding: RSpacingStyle.paddingWithAppBarHeight,
      children: getChildrenTasks(),
    );
  }

  // fetch from repo
  List<Widget> getChildrenTasks() {
    return tasks.map((todo) => TaskListItem(task: todo)).toList();
  }
}
