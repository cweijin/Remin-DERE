import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:remindere/common/styles/spacing_styles.dart';
import 'package:remindere/features/personalization/controllers/team_controller.dart';
import 'package:remindere/features/personalization/models/user_model.dart';
import 'package:remindere/features/taskallocation/controllers/task_allocation_controller.dart';
import 'package:remindere/utils/constants/image_strings.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/helpers/cloud_helper_functions.dart';
import 'package:remindere/utils/validators/validation.dart';

import 'dart:developer';

class ManualAllocation extends StatelessWidget {
  const ManualAllocation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TaskAllocationController());
    final localStorage = GetStorage();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(
                  top: RSizes.appBarHeight,
                  left: RSizes.defaultSpace,
                  right: RSizes.defaultSpace),
              sliver: SliverList.list(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: double.infinity),
                      Text('Create Task',
                          style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: RSizes.spaceBtwItems),
                      Form(
                        key: controller.taskFormKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: controller.taskName,
                              validator: (value) =>
                                  RValidator.validateEmptyText(
                                      'Task name', value),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                labelText: 'Task Name',
                              ),
                              // validator: need validator
                            ),
                            const SizedBox(height: RSizes.spaceBtwInputFields),
                            TextFormField(
                              controller: controller.taskDescription,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: const InputDecoration(
                                labelText: 'Description (Optional)',
                              ),
                              // validator: need validator
                            ),

                            const SizedBox(height: RSizes.spaceBtwInputFields),

                            // DropdownSearch.multiSelection(
                            //   popupProps: PopupPropsMultiSelection.menu(
                            //     showSearchBox: true,
                            //     itemBuilder: (context, item, isSelected) {
                            //       return ListTile(
                            //         leading: const CircleAvatar(
                            //           backgroundImage: AssetImage(RImages.profile1),
                            //           radius: 30,
                            //         ),
                            //         title: Text('Name'),
                            //         subtitle: Text('Email'),
                            //       );
                            //     },
                            //     selectionWidget: null,
                            //   ),
                            //   items: ['Gello', 'World', 'Hey', '5', '999'],
                            // ),

                            FutureBuilder(
                                future: controller.team
                                    .getTeamMembers(
                                        localStorage.read('CurrentTeam') ?? '')
                                    .then((list) {
                                  return list
                                      .map((model) => ValueItem<UserModel>(
                                          label: model.fullName, value: model))
                                      .toList();
                                }),
                                builder: (_, snapshot) {
                                  final response = RCloudHelperFunctions
                                      .checkMultiRecordState(
                                          snapshot: snapshot);
                                  if (response != null) return response;

                                  final users = snapshot.data!;
                                  return MultiSelectDropDown<UserModel>(
                                    controller:
                                        controller.multiSelectController,
                                    searchEnabled: true,
                                    chipConfig: const ChipConfig(
                                        wrapType: WrapType.wrap),
                                    selectedItemBuilder: (_, value) => Chip(
                                      label: Text(value.value?.firstName ?? ''),
                                      avatar: const CircleAvatar(
                                        backgroundImage:
                                            AssetImage(RImages.profile1),
                                      ),
                                      onDeleted: () {
                                        controller.multiSelectController
                                            .clearSelection(value);
                                      },
                                    ),
                                    onOptionSelected: (selectedOptions) {},
                                    optionBuilder: (_, item, selected) {
                                      return ListTile(
                                        title: Text(
                                          item.value?.firstName ?? '',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        leading: const CircleAvatar(
                                          backgroundImage:
                                              AssetImage(RImages.profile1),
                                        ),
                                      );
                                    },
                                    options: () {
                                      //Workaround (set the controller directly) for options not updated after changing teams
                                      //Is there a better way to do so??
                                      controller.multiSelectController
                                          .setOptions(users);
                                      return users;
                                    }(),
                                  );
                                }),

                            // TextFormField(
                            //   controller: controller.taskAssignees,

                            //   decoration: const InputDecoration(
                            //     labelText: 'Assignee',
                            //   ),
                            //   // validator: need validator
                            // ),

                            const SizedBox(height: RSizes.spaceBtwInputFields),

                            // due date picker
                            TextFormField(
                              controller: controller.dueDate,
                              validator: (value) =>
                                  RValidator.validateEmptyText('Date', value),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                labelText: 'Select a Date (YYYY-MM-DD)',
                              ),
                              readOnly: true,
                              onTap: () {
                                controller.selectDate(context);
                              },
                            ),

                            const SizedBox(height: RSizes.spaceBtwInputFields),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () =>
                                          controller.showAttachment.value =
                                              !controller.showAttachment.value,
                                      icon: Obx(() => controller
                                              .showAttachment.value
                                          ? const Icon(Iconsax.arrow_down_1)
                                          : const Icon(Iconsax.arrow_right_3)),
                                    ),
                                    Obx(
                                      () => Text(
                                        'Attachments [${controller.attachments.length}]',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    )
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    controller.getTaskAttachments();
                                  },
                                  child: const Text('Upload'),
                                ),
                              ],
                            ),

                            // TextFormField(
                            //   controller: controller.attachments,
                            //   decoration: const InputDecoration(
                            //     labelText: 'Attachment (Optional)',
                            //   ),
                            // ),

                            const SizedBox(height: RSizes.spaceBtwInputFields),

                            // OutlinedButton(
                            //   onPressed: () {},
                            //   child: const Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //       Icon(Icons.attach_file_rounded),
                            //       SizedBox(width: RSizes.spaceBtwItems),
                            //       Text('Upload Attachments (Optional)'),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SliverPadding(
              padding:
                  const EdgeInsets.symmetric(horizontal: RSizes.defaultSpace),
              sliver: Obx(() => SliverList.builder(
                    itemCount: controller.attachments.length,
                    itemBuilder: (_, index) {
                      final files = controller.attachments
                          .map((file) => file.name)
                          .toList();
                      return Column(
                        children: [
                          Chip(
                            label: Text(
                              files[index],
                              overflow: TextOverflow.ellipsis,
                            ),
                            onDeleted: () {},
                          ),
                        ],
                      );
                    },
                  )),
            ),

            // save event to database
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: RSizes.defaultSpace),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.createTask();
                      FocusManager.instance.primaryFocus?.unfocus();
                    }, // Save to Firestore Database
                    child: const Text("Assign Task"),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
