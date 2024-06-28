import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:remindere/common/styles/spacing_styles.dart';
import 'package:remindere/common/widgets/appbar/appbar.dart';
import 'package:remindere/features/teaming/controllers/create_team/create_team_controller.dart';
import 'package:remindere/features/teaming/screens/join_team/join_team.dart';
import 'package:remindere/utils/constants/sizes.dart';

class CreateTeamScreen extends StatelessWidget {
  const CreateTeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CreateTeamController.instance;

    return Scaffold(
      appBar: RAppBar(
        showBackArrow: true,
        leadingOnPressed: () => Get.off(() => const JoinTeamScreen()),
      ),
      body: Padding(
        padding: RSpacingStyle.paddingWithAppBarHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Create a team',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Form(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: RSizes.spaceBtwSections),
                child: Column(
                  children: [
                    // Team Name
                    TextFormField(
                      controller: controller.name,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.direct_right),
                        labelText: 'Team name',
                      ),
                    ),

                    const SizedBox(height: RSizes.spaceBtwInputFields),

                    // Member
                    TextFormField(
                      controller: controller.members,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.direct_right),
                        labelText: 'Add member',
                      ),
                    ),

                    const SizedBox(height: RSizes.spaceBtwSections),

                    //Create Team Buttion
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => controller.createTeam(),
                        child: const Text('Create Team'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
