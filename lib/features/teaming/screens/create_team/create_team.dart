import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:remindere/common/widgets/appbar/appbar.dart';
import 'package:remindere/features/personalization/models/user_model.dart';
import 'package:remindere/features/teaming/controllers/create_team/create_team_controller.dart';
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
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverList.list(
              children: [
                RAppBar(
                  showBackArrow: showBackArrow,
                  leadingOnPressed: () {
                    controller.resetFormField();
                    Get.back();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: RSizes.appBarHeight,
                      left: RSizes.defaultSpace,
                      right: RSizes.defaultSpace),
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
                                    RValidator.validateEmptyText(
                                        'Team name', value),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                              ),

                              const SizedBox(
                                  height: RSizes.spaceBtwInputFields),

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

                              //const SizedBox(height: RSizes.spaceBtwSections),

                              // const SizedBox(height: RSizes.spaceBtwItems),
                            ],
                          ),
                        ),
                      ),
                      Obx(
                        () {
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
                                },
                              ),
                            );
                          }
                        },
                      ),
                      Obx(
                        () => controller.searchResults.isEmpty
                            ? const SizedBox()
                            : Text('Search results',
                                style: Theme.of(context).textTheme.bodyMedium),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SliverPadding(
              padding:
                  const EdgeInsets.symmetric(horizontal: RSizes.defaultSpace),
              sliver: Obx(
                () => SliverList.separated(
                  //key: Key(controller.refreshSearchResult.toString()),
                  itemCount: controller.searchResults.length > 5
                      ? 5
                      : controller.searchResults.length,
                  separatorBuilder: (_, index) {
                    return const Divider();
                  },
                  itemBuilder: (_, index) {
                    UserModel currModel = controller.searchResults[index];
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage(RImages.profile1),
                        radius: 30,
                      ),
                      title: Text(currModel.fullName),
                      subtitle: Text(currModel.email),
                      selected: controller.selectedUsers.contains(currModel),
                      selectedTileColor: RColors.darkGrey.withOpacity(0.2),
                      onTap: () {
                        if (controller.selectedUsers.contains(currModel)) {
                          controller.selectedUsers.remove(currModel);
                          //controller.refreshSearchResult.toggle();
                        } else {
                          controller.selectedUsers.add(currModel);
                          //controller.refreshSearchResult.toggle();
                        }
                      },
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: //Create Team Buttion
                  Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: RSizes.defaultSpace),
                child: Column(
                  children: [
                    const SizedBox(height: RSizes.spaceBtwSections),
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
            )
          ],
        ),
      ),
    );
  }
}
