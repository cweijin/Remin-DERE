import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindere/common/styles/spacing_styles.dart';
import 'package:remindere/features/taskallocation/controllers/task_allocation_controller.dart';
import 'package:remindere/utils/constants/sizes.dart';

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
              const SizedBox(height: RSizes.spaceBtwItems),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.taskName,
                      decoration: const InputDecoration(
                        labelText: 'Task Name',
                      ),
                      // validator: need validator
                    ),
                    const SizedBox(height: RSizes.spaceBtwInputFields),
                    TextFormField(
                      controller: controller.taskDescription,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      // validator: need validator
                    ),
                    const SizedBox(height: RSizes.spaceBtwInputFields),

                    TextFormField(
                      controller: controller.taskAssignees,
                      decoration: const InputDecoration(
                        labelText: 'Assignee',
                      ),
                      // validator: need validator
                    ),
                    const SizedBox(height: RSizes.spaceBtwInputFields),

                    // due date picker
                    TextField(
                      controller: controller.dueDate,
                      decoration: const InputDecoration(
                        labelText: 'Select a Date',
                      ),
                      readOnly: true,
                      onTap: () {
                        controller.selectDate(context);
                      },
                    ),
                    const SizedBox(height: RSizes.spaceBtwInputFields),

                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Attachment',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: RSizes.spaceBtwItems),

              // save event to database
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () =>
                        controller.createTask(), // Save to Firestore Database
                    child: const Text("Assign Task")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
