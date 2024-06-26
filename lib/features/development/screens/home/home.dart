import 'package:flutter/material.dart';
import 'package:remindere/features/development/screens/home/widgets/home_appbar.dart';
import 'package:remindere/features/development/screens/home/widgets/task_block.dart';
import 'package:remindere/features/development/screens/home/widgets/task_tile.dart';
import 'package:remindere/utils/constants/sizes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const tasks = ['Task 1', 'Task 2', 'Task 3', 'Task 4', 'Task 5', 'Task 6'];

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
                // Task Blocks
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: tasks.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return RTaskBlock(child: tasks[index]);
                    },
                  ),
                ),
                const SizedBox(height: RSizes.spaceBtwSections),
                Text('Task List',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: RSizes.spaceBtwItems),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: RSizes.lg),
            sliver: SliverList.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return RTaskTile(child: tasks[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
