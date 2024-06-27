import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindere/common/styles/spacing_styles.dart';
import 'package:remindere/features/taskallocation/controllers/task_allocation_controller.dart';
import 'package:remindere/data/repositories/calendar_event_repository/calendar_event_repository.dart';
import 'package:remindere/features/taskallocation/models/task_model.dart';

class ManualAllocation extends StatelessWidget {
  const ManualAllocation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TaskAllocationController());
    final taskDB = Get.put(CalendarEventRepository());  // database for calendar

    final taskName = TextEditingController();   // to store details
    final taskDescription = TextEditingController();
    final taskAssignees = TextEditingController();


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
                      controller: taskName,
                      decoration: const InputDecoration(
                        labelText: 'Task Name',
                      ),
                      // validator: need validator
                    ),
                    TextFormField(
                      controller: taskDescription,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      // validator: need validator
                    ),
                    TextFormField(
                      controller: taskAssignees,
                      decoration: const InputDecoration(
                        labelText: 'Asignee',
                      ),
                      // validator: need validator
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

              // save event to database
              ElevatedButton(
                onPressed: () { // create a task instance first
                  TaskModel task = TaskModel(
                    taskName: taskName.text, 
                    taskDescription: taskDescription.text, 
                    asignees: [taskAssignees.text], 
                    dueDate: controller.pickedDate(), 
                    attachments: [] // empty
                  );

                  taskDB.saveTaskDetails(task); // then save it to firebase
                },
                child: Text("Assign Task"))
            ],
          ),
        ),
      ),
    );
  }
}