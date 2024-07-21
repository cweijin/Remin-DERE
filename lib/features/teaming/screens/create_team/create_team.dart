import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:remindere/common/styles/spacing_styles.dart';
import 'package:remindere/common/widgets/appbar/appbar.dart';
import 'package:remindere/features/personalization/models/user_model.dart';
import 'package:remindere/features/personalization/screens/profile/widgets/team_card.dart';
import 'package:remindere/features/teaming/controllers/create_team/create_team_controller.dart';
import 'package:remindere/features/teaming/screens/join_team/join_team.dart';
import 'package:remindere/utils/constants/colors.dart';
import 'package:remindere/utils/constants/image_strings.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/validators/validation.dart';

class CreateTeamScreen extends StatelessWidget {
  final bool showBackArrow;

  const CreateTeamScreen({
    super.key,
    this.showBackArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    final controller = CreateTeamController.instance;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: RAppBar(
          showBackArrow: showBackArrow,
          leadingOnPressed: () {
            controller.resetFormField();
            Get.back();
          },
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
                          validator: (value) =>
                              RValidator.validateEmptyText('Team name', value),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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

                        // Text(
                        //   'Selected',
                        //   style: Theme.of(context).textTheme.headlineSmall,
                        // ),
                        const SizedBox(height: RSizes.spaceBtwSections),

                        Obx(() {
                          if (controller.selectedUsers.isEmpty) {
                            return const SizedBox();
                          } else {
                            return SizedBox(
                              height: 100,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.selectedUsers.length,
                                  itemBuilder: (_, index) {
                                    return SizedBox(
                                      width: 90,
                                      child: Column(
                                        children: [
                                          const CircleAvatar(
                                            backgroundImage:
                                                AssetImage(RImages.profile1),
                                            radius: 40,
                                          ),
                                          Text(
                                            controller
                                                .selectedUsers[index].firstName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            );
                          }
                        }),

                        const SizedBox(height: RSizes.spaceBtwItems),

                        Text('Search results',
                            style: Theme.of(context).textTheme.bodyMedium),

                        const SizedBox(height: RSizes.spaceBtwItems),

                        SizedBox(
                          height: 450,
                          child: Obx(
                            () => ListView.separated(
                              key: Key(
                                  controller.refreshSearchResult.toString()),
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.searchResults.length > 5
                                  ? 5
                                  : controller.searchResults.length,
                              separatorBuilder: (_, index) {
                                return const Divider();
                              },
                              itemBuilder: (_, index) {
                                UserModel currModel =
                                    controller.searchResults[index];
                                return ListTile(
                                  leading: const CircleAvatar(
                                    backgroundImage:
                                        AssetImage(RImages.profile1),
                                    radius: 30,
                                  ),
                                  title: Text(currModel.fullName),
                                  subtitle: Text(currModel.email),
                                  selected: controller.selectedUsers
                                      .contains(currModel),
                                  selectedTileColor:
                                      RColors.darkGrey.withOpacity(0.2),
                                  onTap: () {
                                    if (controller.selectedUsers
                                        .contains(currModel)) {
                                      controller.selectedUsers
                                          .remove(currModel);
                                      controller.refreshSearchResult.toggle();
                                    } else {
                                      controller.selectedUsers.add(currModel);
                                      controller.refreshSearchResult.toggle();
                                    }
                                  },
                                );
                              },
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
      ),
    );
  }
}
