import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:remindere/common/styles/spacing_styles.dart';
import 'package:remindere/common/widgets/appbar/appbar.dart';
import 'package:remindere/features/personalization/screens/profile/widgets/team_card.dart';
import 'package:remindere/features/teaming/controllers/create_team/create_team_controller.dart';
import 'package:remindere/features/teaming/screens/join_team/join_team.dart';
import 'package:remindere/utils/constants/image_strings.dart';
import 'package:remindere/utils/constants/sizes.dart';

class CreateTeamScreen extends StatelessWidget {
  const CreateTeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CreateTeamController.instance;

    return Scaffold(
      appBar: RAppBar(
        showBackArrow: true,
        leadingOnPressed: () => Get.off(() {
          //controller.resetFormField();
          return const JoinTeamScreen();
        }),
      ),
      body: SingleChildScrollView(
        child: Padding(
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

                      // //Member testing
                      // Container(
                      //   decoration: BoxDecoration(
                      //       border: Border.all(color: Colors.black)),
                      //   child: const Row(
                      //     children: [
                      //       Column(
                      //         children: [Icon(Iconsax.direct_right)],
                      //       ),
                      //       Wrap(
                      //         children: [
                      //           SizedBox(
                      //             height: 50,
                      //             width: 100,
                      //             child: TextField(
                      //               decoration: InputDecoration(
                      //                   border: InputBorder.none,
                      //                   focusedBorder: InputBorder.none,
                      //                   enabledBorder: InputBorder.none,
                      //                   errorBorder: InputBorder.none,
                      //                   disabledBorder: InputBorder.none,
                      //                   hintText: 'name / email'),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      //Member
                      TextFormField(
                        controller: controller.members,
                        onChanged: controller.searchUsers,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Iconsax.direct_right),
                          labelText: 'Add member',
                        ),
                      ),

                      const SizedBox(height: RSizes.spaceBtwSections),

                      Text(
                        'Selected',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),

                      SizedBox(
                        height: 100,
                        child: Obx(
                          () => ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.selectedUsers.length,
                            itemBuilder: (_, index) {
                              return SizedBox(
                                width: 80,
                                child: Column(
                                  children: [
                                    const CircleAvatar(
                                      backgroundImage:
                                          AssetImage(RImages.profile1),
                                      radius: 35,
                                    ),
                                    Text(
                                        controller
                                            .searchResults[index].firstName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 300,
                        child: Obx(
                          () => ListView.builder(
                            key: Key(controller.refreshSearchResult.toString()),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.searchResults.length > 5
                                ? 5
                                : controller.searchResults.length,
                            itemBuilder: (_, index) => InkWell(
                              onTap: () {
                                if (controller.selectedUsers.contains(
                                    controller.searchResults[index])) {
                                  controller.selectedUsers
                                      .remove(controller.searchResults[index]);
                                } else {
                                  controller.selectedUsers
                                      .add(controller.searchResults[index]);
                                }
                              },
                              child: ListTile(
                                title: Text(
                                    controller.searchResults[index].fullName),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(),

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
      ),
    );
  }
}
