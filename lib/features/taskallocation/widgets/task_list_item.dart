import 'package:flutter/material.dart';
import 'package:remindere/features/taskallocation/models/task_model.dart';

class TaskListItem extends StatelessWidget {
  final TaskModel task;

  TaskListItem({required this.task});

  @override
  Widget build(BuildContext context) {
    return  Container(
              height: 50,
              color: Colors.amber[600],
              child: Column(
                children: [
                  Center(child: Text(task.taskName)),
                  Text(task.taskDescription)
                ],
              )
    );
  }
}

            // Task widget implementation
            // Container(
            //       height: 50,
            //       color: Colors.amber[600],
            //       child: const Center(child: Text('Entry A')),
            //     ),
            //     Container(
            //       height: 50,
            //       color: Colors.amber[500],
            //       child: const Center(child: Text('Entry B')),
            //     ),
            //     Container(
            //       height: 50,
            //       color: Colors.amber[100],
            //       child: const Center(child: Text('Entry C')),
            //     ),