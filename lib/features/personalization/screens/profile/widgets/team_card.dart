import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:remindere/features/personalization/controllers/team_controller.dart';
import 'package:remindere/features/teaming/models/team_model.dart';
import 'package:remindere/features/teaming/screens/team.dart';
import 'package:remindere/utils/constants/sizes.dart';

class RTeamCard extends StatelessWidget {
  const RTeamCard({
    super.key,
    required this.team,
    required this.isDark,
  });

  final bool isDark;
  final TeamModel team;

  @override
  Widget build(BuildContext context) {
    TeamController controller = Get.find();
    final localStorage = GetStorage();

    return Row(children: [
      InkWell(
        splashColor: Colors.grey,
        onTap: () => Get.to(() => TeamScreen(team: team)),
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.transparent
                    : const Color.fromARGB(255, 243, 249, 241),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.grey.withOpacity(0.3) : Colors.grey,
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              height: 200,
              width: 200,
              child: Padding(
                padding: const EdgeInsets.all(RSizes.md),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      team.teamName,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    team.id == localStorage.read("CurrentTeam")
                        ? Text('(Selected)',
                            style: Theme.of(context).textTheme.bodySmall)
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Iconsax.more),
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: TextButton(
                onPressed: () async {
                  controller.selectTeam(team.id);
                  await localStorage.write('CurrentTeamName', team.teamName);
                },
                child: const Text('Change'),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(width: RSizes.spaceBtwItems),
    ]);
  }
}
