import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindere/common/styles/spacing_styles.dart';
import 'package:remindere/common/widgets/appbar/appbar.dart';
import 'package:remindere/features/personalization/controllers/user_controller.dart';
import 'package:remindere/features/task_allocation/models/task_model.dart';
import 'package:remindere/features/task_management/controllers/task_management_controller.dart';
import 'package:remindere/features/task_management/screens/widgets/attachment_card.dart';
import 'package:remindere/utils/constants/image_strings.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/formatters/formatter.dart';
import 'package:remindere/utils/helpers/cloud_helper_functions.dart';
import 'package:remindere/utils/helpers/helper_functions.dart';

class TaskManagementScreen extends StatelessWidget {
  const TaskManagementScreen({super.key, required this.task});

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    final controller = TaskManagementController.instance;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus,
      child: Scaffold(
        appBar: RAppBar(
          showBackArrow: true,
          leadingOnPressed: () => Get.back(),
        ),
        body: Padding(
          padding: RSpacingStyle.paddingWithAppBarHeight,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.taskName,
                    style: Theme.of(context).textTheme.displayMedium),
                Text('due ${RFormatter.formatDate(task.dueDate)}'),
                const SizedBox(height: RSizes.spaceBtwSections),
                const Divider(),
                const SizedBox(height: RSizes.spaceBtwSections),
                Text(task.taskDescription),
                const SizedBox(height: RSizes.spaceBtwSections),
                Text('Assignees',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: RSizes.spaceBtwItems),
                FutureBuilder(
                  future: controller.user.fetchUsers(task.assignees),
                  builder: (_, snapshot) {
                    final response =
                        RCloudHelperFunctions.checkMultiRecordState(
                            snapshot: snapshot);

                    if (response != null) {
                      return response;
                    }

                    final assignees = snapshot.data!;

                    return SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: assignees.length,
                        itemBuilder: (_, index) {
                          final model = assignees[index];
                          final image = model.profilePicture.isEmpty
                              ? const AssetImage(RImages.profile1)
                              : NetworkImage(model.profilePicture)
                                  as ImageProvider;

                          return SizedBox(
                            width: 80,
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: image,
                                  radius: 30,
                                ),
                                Text(
                                  assignees[index].firstName,
                                  style: Theme.of(context).textTheme.labelSmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: RSizes.spaceBtwSections),
                task.attachments.isEmpty
                    ? const SizedBox()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Attachments',
                              style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: RSizes.spaceBtwItems),
                          SizedBox(
                            height: 290,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: task.attachments.length,
                              itemBuilder: (_, index) {
                                return RAttachmentCard(
                                    fileUrl: task.attachments[index]);
                              },
                            ),
                          ),
                          const SizedBox(height: RSizes.spaceBtwSections),
                        ],
                      ),
                Text('Comments',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: RSizes.spaceBtwItems),
                StreamBuilder(
                  stream: controller.getComment(task.id!),
                  builder: (_, snapshot) {
                    final response =
                        RCloudHelperFunctions.checkMultiRecordState(
                            snapshot: snapshot,
                            nothingFound: const Center(
                                child: Text('Leave your comment here')));

                    if (response != null) {
                      return response;
                    }

                    final models = snapshot.data!;

                    return SizedBox(
                      height: 200,
                      child: ListView.separated(
                        itemCount: models.length,
                        itemBuilder: (_, index) {
                          final comment = models[index];
                          final ownerFuture =
                              controller.user.fetchUsers([comment.ownerId]);
                          return FutureBuilder(
                            future: ownerFuture,
                            builder: (_, snapshot) {
                              final response =
                                  RCloudHelperFunctions.checkMultiRecordState(
                                snapshot: snapshot,
                              );

                              if (response != null) {
                                return response;
                              }

                              final owner = snapshot.data![0];
                              final image = owner.profilePicture.isNotEmpty
                                  ? NetworkImage(owner.profilePicture)
                                  : const AssetImage(RImages.profile1)
                                      as ImageProvider;

                              return ListTile(
                                titleAlignment: ListTileTitleAlignment.center,
                                leading: CircleAvatar(
                                  backgroundImage: image,
                                ),
                                title: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: owner.fullName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      TextSpan(
                                        text:
                                            ' ${RHelperFunctions.getDuration(comment.createdAt)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      ),
                                    ],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(comment.comment),
                              );
                            },
                          );
                        },
                        separatorBuilder: (_, index) => const Divider(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: RSizes.spaceBtwItems),
                TextField(
                  controller: controller.comment,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0))),
                    hintText: 'Comment...',
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.postComment(task.id!);
                      },
                      icon: const Icon(Icons.send),
                    ),
                  ),
                ),
                const SizedBox(height: RSizes.spaceBtwSections),
                const Divider(),
                const SizedBox(height: RSizes.spaceBtwSections),
                Text('Submission',
                    style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: RSizes.spaceBtwItems),
                Text('Attachment',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: RSizes.spaceBtwItems),
                Obx(
                  () => controller.attachments.isEmpty
                      ? const Center(child: Text('No attachment selected'))
                      : SizedBox(
                          height: 290,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.attachments.length,
                            itemBuilder: (_, index) {
                              final file = controller.attachments[index];
                              return RAttachmentCard(
                                  fileUrl: '', fileName: file.name);
                            },
                          ),
                        ),
                ),
                const SizedBox(height: RSizes.spaceBtwSections),
                Text('Message',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: RSizes.spaceBtwItems),
                StreamBuilder(
                  stream: controller.getComment(task.id!, isPrivate: true),
                  builder: (_, snapshot) {
                    final response =
                        RCloudHelperFunctions.checkMultiRecordState(
                            snapshot: snapshot,
                            nothingFound: const Center(
                                child: Text('Leave your comment here')));

                    if (response != null) {
                      return response;
                    }

                    final models = snapshot.data!;

                    return SizedBox(
                      height: 200,
                      child: ListView.separated(
                        itemCount: models.length,
                        itemBuilder: (_, index) {
                          final comment = models[index];
                          final ownerFuture =
                              controller.user.fetchUsers([comment.ownerId]);
                          return FutureBuilder(
                            future: ownerFuture,
                            builder: (_, snapshot) {
                              final response =
                                  RCloudHelperFunctions.checkMultiRecordState(
                                snapshot: snapshot,
                              );

                              if (response != null) {
                                return response;
                              }

                              final owner = snapshot.data![0];
                              final image = owner.profilePicture.isNotEmpty
                                  ? NetworkImage(owner.profilePicture)
                                  : const AssetImage(RImages.profile1)
                                      as ImageProvider;

                              return ListTile(
                                titleAlignment: ListTileTitleAlignment.center,
                                leading: CircleAvatar(
                                  backgroundImage: image,
                                ),
                                title: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: owner.fullName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      TextSpan(
                                        text:
                                            ' ${RHelperFunctions.getDuration(comment.createdAt)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      ),
                                    ],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(comment.comment),
                              );
                            },
                          );
                        },
                        separatorBuilder: (_, index) => const Divider(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: RSizes.spaceBtwItems),
                TextField(
                  controller: controller.comment,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0))),
                    hintText: 'Message...',
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.postComment(task.id!, isPrivate: true);
                      },
                      icon: const Icon(Icons.send),
                    ),
                  ),
                ),
                const SizedBox(height: RSizes.spaceBtwSections),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      controller.getSubmissionAttachments();
                    },
                    child: const Text('Upload Files'),
                  ),
                ),
                const SizedBox(height: RSizes.spaceBtwItems),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => controller.submitWork(task),
                    child: const Text('Submit'),
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
