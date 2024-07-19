import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:remindere/features/personalization/controllers/team_controller.dart';
import 'package:remindere/utils/constants/sizes.dart';

class TeamCard extends StatelessWidget {
  const TeamCard({
    super.key,
    required this.name,
    required this.members,
    required this.teamId,
  });

  final String name;
  final List<String> members;
  final String teamId;

  @override
  Widget build(BuildContext context) {
    TeamController controller = Get.find();
    final localStorage = GetStorage();

    return Row(children: [
      InkWell(
        splashColor: Colors.grey,
        onTap: () {
          controller.selectTeam(teamId);
          _showTeamDetails(context);
        },
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              height: 200,
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(name, style: Theme.of(context).textTheme.headlineSmall),
                  teamId == localStorage.read("CurrentTeam")
                      ? Text('(Selected)',
                          style: Theme.of(context).textTheme.bodySmall)
                      : const SizedBox(),
                ],
              ),
            ),
            Positioned(
              right: 0,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Iconsax.more),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(width: RSizes.spaceBtwItems),
    ]);
  }

  // display a pop up with event details
  void _showTeamDetails(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              height: MediaQuery.of(context).size.height *
                  .60, // Task detail popup-box size
              child: Padding(
                  padding: const EdgeInsets.all(RSizes.borderRadiusMd),
                  child: Column(children: [
                    const Text(
                      'Team Details',
                      style: TextStyle(fontSize: RSizes.lg),
                    ),
                    Text(
                      "Team name: ${name}",
                      style: const TextStyle(fontSize: RSizes.md),
                    ),
                    Text(
                      "Task member: ${members}",
                      style: const TextStyle(fontSize: RSizes.md),
                    ),
                  ])));
        });
  }
}
