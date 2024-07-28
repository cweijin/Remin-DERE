import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:remindere/common/styles/spacing_styles.dart';
import 'package:remindere/common/widgets/shimmer/shimmer.dart';
import 'package:remindere/data/repositories/authentication_repository/authentication_repository.dart';
import 'package:remindere/features/personalization/controllers/team_controller.dart';
import 'package:remindere/features/personalization/controllers/user_controller.dart';
import 'package:remindere/features/personalization/screens/account_security/account_security.dart';
import 'package:remindere/features/personalization/screens/personal_details/personal_details.dart';
import 'package:remindere/features/personalization/screens/profile/widgets/team_card.dart';
import 'package:remindere/features/teaming/controllers/create_team/create_team_controller.dart';
import 'package:remindere/features/teaming/screens/join_team/join_team.dart';
import 'package:remindere/utils/constants/image_strings.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/device/device_utility.dart';
import 'package:remindere/utils/helpers/cloud_helper_functions.dart';
import 'package:remindere/utils/helpers/helper_functions.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = UserController.instance;
    final teamController = TeamController.instance;
    final createTeamController = Get.put(CreateTeamController());
    final width = RDeviceUtils.getScreenWidth(context);
    bool isDark = RHelperFunctions.isDarkMode(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                const SizedBox(height: 380),
                Image.asset(
                  RImages.background1,
                  width: double.infinity,
                ),
                Positioned(
                  top: 200,
                  left: width - 180,
                  child: Obx(
                    () {
                      final networkImage =
                          userController.user.value.profilePicture;
                      final image = networkImage.isNotEmpty
                          ? NetworkImage(networkImage) as ImageProvider
                          : const AssetImage(RImages.profile1) as ImageProvider;
                      return userController.imageUploading.value
                          ? const RShimmerEffect(
                              width: 160, height: 160, radius: 80)
                          : CircleAvatar(
                              radius: 80,
                              backgroundImage: image,
                            );
                    },
                  ),
                ),
                Positioned(
                  top: 310,
                  left: width - 60,
                  child: IconButton(
                    icon: const Icon(Iconsax.edit),
                    onPressed: () => userController.uploadUserProfilePicture(),
                  ),
                ),
                Positioned(
                  top: 320,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      top: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          if (userController.profileLoading.value) {
                            return const RShimmerEffect(width: 100, height: 15);
                          } else {
                            return Text(
                              userController.user.value.fullName,
                              style: Theme.of(context).textTheme.headlineMedium,
                            );
                          }
                        }),
                        // Text("Software Engineer",
                        //     style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: RSpacingStyle.paddingWithAppBarHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Your teams",
                          style: Theme.of(context).textTheme.headlineSmall),
                      TextButton(
                          onPressed: () => Get.to(() => const JoinTeamScreen()),
                          child: const Text('Join or create a team')),
                    ],
                  ),
                  const SizedBox(height: RSizes.spaceBtwItems),
                  SizedBox(
                    height: 210,
                    child: Obx(
                      () => FutureBuilder(
                        // Use key to trigger refresh
                        key: Key(
                            createTeamController.refreshData.value.toString() +
                                teamController.refreshData.value.toString()),
                        future: teamController.getAllUserTeams(),
                        builder: (_, snapshot) {
                          // Helper function to handle loader, no record, or error message
                          final response =
                              RCloudHelperFunctions.checkMultiRecordState(
                                  snapshot: snapshot);
                          if (response != null) return response;

                          final teams = snapshot.data!;

                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: teams.length,
                            itemBuilder: (_, index) => RTeamCard(
                              team: teams[index],
                              isDark: isDark,
                            ),
                          );
                        },
                      ),
                    ),
                    // child: ListView.builder(
                    //   scrollDirection: Axis.horizontal,
                    //   itemBuilder: (_, index) =>
                    //       const TeamCard(name: 'Testing'),
                    // ),
                  ),
                  const SizedBox(height: RSizes.spaceBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () =>
                          Get.to(() => const PersonalDetailsScreen()),
                      child: const Text("Personal Details"),
                    ),
                  ),
                  const SizedBox(height: RSizes.spaceBtwItems),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () =>
                          Get.to(() => const AccountSecurityScreen()),
                      child: const Text("Account Security"),
                    ),
                  ),
                  // const SizedBox(height: RSizes.spaceBtwItems),
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: OutlinedButton(
                  //     onPressed: () {},
                  //     child: const Text("Settings"),
                  //   ),
                  // ),
                  const SizedBox(height: RSizes.spaceBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          AuthenticationRepository.instance.logout();
                        },
                        child: const Text('Logout')),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
