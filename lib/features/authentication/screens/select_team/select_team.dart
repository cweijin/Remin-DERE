import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:remindere/features/personalization/controllers/team_controller.dart';
import 'package:remindere/features/teaming/screens/create_team/create_team.dart';
import 'package:remindere/navigation_menu.dart';
import 'package:remindere/utils/helpers/cloud_helper_functions.dart';

class TeamSelectionScreen extends StatelessWidget {
  const TeamSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TeamController controller = Get.find();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Select Team',
              style: Theme.of(context).textTheme.headlineMedium),
          FutureBuilder(
            future: controller.getAllUserTeams(),
            builder: (_, snapshot) {
              final response = RCloudHelperFunctions.checkMultiRecordState(
                snapshot: snapshot,
                nothingFound: ElevatedButton(
                  onPressed: () {
                    Get.off(const CreateTeamScreen());
                  },
                  child: const Text('Create Team!'),
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
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
