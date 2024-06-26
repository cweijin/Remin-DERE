import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:remindere/common/styles/spacing_styles.dart';
import 'package:remindere/features/taskallocation/controllers/task_allocation_controller.dart';

class ManualAllocation extends StatelessWidget {
  const ManualAllocation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TaskAllocationController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: RSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: double.infinity),
              Text('Create Task',
                  style: Theme.of(context).textTheme.headlineMedium),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Task Name',
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Asignee',
                      ),
                    ),
                    
                    // due date picker
                      TextField(
                        controller: controller.date,
                        decoration:  InputDecoration(
                          labelText: 'Select a Date',
                        ),
                        readOnly: true,
                        onTap: () {
                          controller.selectDate(context);

                        },
                      ),

                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Attachment',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}