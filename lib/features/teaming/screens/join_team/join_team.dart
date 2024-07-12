import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:remindere/common/styles/spacing_styles.dart';
import 'package:remindere/common/widgets/appbar/appbar.dart';
import 'package:remindere/features/teaming/screens/create_team/create_team.dart';
import 'package:remindere/utils/constants/sizes.dart';

class JoinTeamScreen extends StatelessWidget {
  const JoinTeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RAppBar(
        showBackArrow: true,
        leadingOnPressed: () => Get.back(),
      ),
      body: Padding(
        padding: RSpacingStyle.paddingWithAppBarHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Join a team',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Form(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: RSizes.spaceBtwSections),
                child: Column(
                  children: [
                    // Team code
                    TextFormField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.direct_right),
                        labelText: 'Enter team code',
                      ),
                    ),

                    const SizedBox(height: RSizes.spaceBtwSections),

                    //Join Team Buttion
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('Join Team'),
                      ),
                    ),

                    const SizedBox(height: RSizes.spaceBtwItems),

                    //Create Team Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () =>
                            Get.off(() => const CreateTeamScreen()),
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
