import 'package:flutter/material.dart';
import 'package:remindere/features/development/screens/home/widgets/home_appbar.dart';
import 'package:remindere/features/development/screens/home/widgets/task_card.dart';
import 'package:remindere/features/development/screens/home/widgets/task_tile.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/features/calendar/controllers/calendar_task_controller.dart';
import 'package:get/get.dart';
import 'package:remindere/utils/helpers/cloud_helper_functions.dart';
import 'package:remindere/utils/helpers/helper_functions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = RHelperFunctions.isDarkMode(context);
    final controller = CalendarTaskController.instance;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: RHomeAppBar()),

          SliverPadding(
            padding: const EdgeInsets.only(
              top: RSizes.appBarHeight,
              left: RSizes.lg,
              right: RSizes.lg,
            ),
            sliver: SliverList.list(
              children: [
                Text('Upcoming Task',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: RSizes.spaceBtwItems),
                // Task Cards
                SizedBox(
                  height: 258,
                  child: Obx(
                    () => FutureBuilder(
                      // Use key to trigger refresh
                      key: Key(controller.refreshData.value.toString()),
                      future: controller.getUserTasks(DateTime.now()),
                      builder: (context, snapshot) {
                        // Helper function to handle loader, no record, or error message
                        final response =
                            RCloudHelperFunctions.checkMultiRecordState(
                                snapshot: snapshot);
                        if (response != null) return response;

                        final tasks = snapshot.data!;
                        tasks.sort(((taskA, taskB) => taskA.dueDate.compareTo(
                            taskB.dueDate))); // arrange based on dueDate

                        return ListView.builder(
                          itemCount: tasks.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return RTaskCard(
                              task: tasks[index],
                              isDark: isDark,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: RSizes.spaceBtwSections),
                Text('Task List',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: RSizes.spaceBtwItems),
              ],
            ),
          ),

          // Task Tiles
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: RSizes.lg),
            sliver: Obx(
              () => FutureBuilder(
                // Use key to trigger refresh
                key: Key(controller.refreshData.value.toString()),
                future: controller.getAllUserTasks(),
                builder: (context, snapshot) {
                  // Helper function to handle loader, no record, or error message
                  final response = RCloudHelperFunctions.checkMultiRecordState(
                      snapshot: snapshot);
                  if (response != null) {
                    return SliverToBoxAdapter(
                      child: response,
                    );
                  }

                  final tasks = snapshot.data!;
                  tasks.sort(((taskA, taskB) => taskA.dueDate
                      .compareTo(taskB.dueDate))); // arrange based on dueDate

                  return SliverList.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return RTaskTile(
                        task: tasks[index],
                        isDark: isDark,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
