import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindere/common/widgets/appbar/appbar.dart';
import 'package:remindere/features/development/screens/home/widgets/task_tile.dart';
import 'package:remindere/features/personalization/controllers/team_controller.dart';
import 'package:remindere/features/personalization/controllers/user_controller.dart';
import 'package:remindere/features/teaming/models/team_model.dart';
import 'package:remindere/utils/constants/image_strings.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/helpers/cloud_helper_functions.dart';
import 'package:remindere/utils/helpers/helper_functions.dart';

class TeamScreen extends StatelessWidget {
  final TeamModel team;
  const TeamScreen({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    final controller = TeamController.instance;
    final userId = UserController.instance.user.value.id;
    bool isDark = RHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: RAppBar(
        showBackArrow: true,
        leadingOnPressed: () => Get.back(),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: RSizes.defaultSpace,
                  right: RSizes.defaultSpace,
                  top: RSizes.appBarHeight),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      children: [
                        Text(team.teamName,
                            style: Theme.of(context).textTheme.displaySmall),
                        team.owner == userId
                            ? IconButton(
                                onPressed: () => controller.deleteTeam(team),
                                icon: const Icon(Icons.delete_outline_rounded))
                            : const SizedBox()
                      ],
                    ),
                    const SizedBox(height: RSizes.spaceBtwSections),
                    Text('Members',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: RSizes.spaceBtwItems),
                    FutureBuilder(
                      future: controller.user.fetchUsers(team.teamMembers),
                      builder: (_, snapshot) {
                        final response =
                            RCloudHelperFunctions.checkMultiRecordState(
                                snapshot: snapshot);

                        if (response != null) {
                          return response;
                        }

                        final assignees = snapshot.data!;

                        return SizedBox(
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: assignees.length,
                            itemBuilder: (_, index) {
                              final model = assignees[index];

                              final image = model.profilePicture.isEmpty
                                  ? const AssetImage(RImages.profile1)
                                  : NetworkImage(model.profilePicture)
                                      as ImageProvider;

                              return SizedBox(
                                width: 80,
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: image,
                                      radius: 30,
                                    ),
                                    Text(
                                      assignees[index].firstName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: RSizes.spaceBtwSections),
                    Text('Assigned Tasks',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: RSizes.spaceBtwItems),
                  ],
                ),
              ),
            ),
          ),
          // Task Tiles
          SliverPadding(
            padding: const EdgeInsets.only(
                left: RSizes.defaultSpace,
                right: RSizes.defaultSpace,
                bottom: RSizes.defaultSpace),
            sliver: Obx(
              () => FutureBuilder(
                // Use key to trigger refresh
                key: Key(controller.task.refreshData.value.toString()),
                future: controller.task.getAllTeamTasks(team.id),
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
