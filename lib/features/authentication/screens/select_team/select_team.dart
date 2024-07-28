import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:remindere/common/styles/spacing_styles.dart';
import 'package:remindere/features/personalization/controllers/team_controller.dart';
import 'package:remindere/features/teaming/screens/create_team/create_team.dart';
import 'package:remindere/navigation_menu.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/helpers/cloud_helper_functions.dart';

class TeamSelectionScreen extends StatelessWidget {
  const TeamSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TeamController controller = Get.find();
    final deviceStorage = GetStorage();
    return Scaffold(
      body: Padding(
        padding: RSpacingStyle.paddingWithAppBarHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Select Team',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: RSizes.spaceBtwSections),
            FutureBuilder(
              future: controller.getAllUserTeams(),
              builder: (_, snapshot) {
                final response = RCloudHelperFunctions.checkMultiRecordState(
                  snapshot: snapshot,
                  nothingFound: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.off(const CreateTeamScreen(
                          showBackArrow: false,
                        ));
                      },
                      child: const Text('Create Team!'),
                    ),
                  ),
                );

                if (response != null) {
                  return response;
                } else {
                  final teams = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: teams.length,
                      itemBuilder: (_, index) => ListTile(
                        title: Text(teams[index].teamName),
                        onTap: () async {
                          await deviceStorage.write(
                              'CurrentTeam', teams[index].id);
                          await deviceStorage.write(
                              'CurrentTeamName', teams[index].teamName);
                          await TeamController.instance.fetchCurrentTeam();
                          NavigationController.instance.verifyOwnership();
                          Get.offAll(const NavigationMenu());
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
