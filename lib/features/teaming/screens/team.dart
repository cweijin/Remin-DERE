import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindere/common/styles/spacing_styles.dart';
import 'package:remindere/common/widgets/appbar/appbar.dart';
import 'package:remindere/features/personalization/controllers/team_controller.dart';
import 'package:remindere/features/teaming/models/team_model.dart';
import 'package:remindere/utils/constants/image_strings.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/helpers/cloud_helper_functions.dart';

class TeamScreen extends StatelessWidget {
  final TeamModel team;
  const TeamScreen({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    final controller = TeamController.instance;
    return Scaffold(
      appBar: RAppBar(
        showBackArrow: true,
        leadingOnPressed: () => Get.back(),
      ),
      body: Padding(
        padding: RSpacingStyle.paddingWithAppBarHeight,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(team.teamName,
                  style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: RSizes.spaceBtwSections),
              Text('Members',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: RSizes.spaceBtwItems),
              FutureBuilder(
                future: controller.user.fetchUsers(team.teamMembers),
                builder: (_, snapshot) {
                  final response = RCloudHelperFunctions.checkMultiRecordState(
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
                                style: Theme.of(context).textTheme.labelSmall,
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
    );
  }
}
