import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindere/common/styles/spacing_styles.dart';
import 'package:remindere/common/widgets/appbar/appbar.dart';
import 'package:remindere/features/development/controllers/notification/notification_controller.dart';
import 'package:remindere/features/development/models/notification/notification_model.dart';
import 'package:remindere/utils/constants/image_strings.dart';
import 'package:remindere/utils/helpers/cloud_helper_functions.dart';
import 'package:remindere/utils/helpers/helper_functions.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = NotificationController.instance;

    return Scaffold(
      appBar: RAppBar(
        showBackArrow: true,
        leadingOnPressed: () => Get.back(),
        title: Text(
          'Notifications',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Padding(
        padding: RSpacingStyle.paddingWithAppBarHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Text('New', style: Theme.of(context).textTheme.headlineSmall),
            Expanded(
              child: StreamBuilder(
                stream: controller.getNotifications(),
                builder: (_, snapshot) {
                  final response = RCloudHelperFunctions.checkMultiRecordState(
                      snapshot: snapshot);

                  if (response != null) {
                    return response;
                  }

                  final models = snapshot.data!;

                  return ListView.separated(
                    itemCount: models.length,
                    itemBuilder: (_, index) {
                      final notification = models[index];
                      final ownerFuture =
                          controller.user.fetchUsers([notification.createdBy]);

                      return FutureBuilder(
                        future: ownerFuture,
                        builder: (_, snapshot) {
                          final response =
                              RCloudHelperFunctions.checkMultiRecordState(
                                  snapshot: snapshot,
                                  nothingFound: const SizedBox());

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
                            isThreeLine: true,
                            leading: CircleAvatar(
                              backgroundImage: image,
                            ),
                            title: switch (notification.type) {
                              NotificationType.taskCreation => Text.rich(
                                  TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: owner.firstName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall),
                                      const TextSpan(
                                          text: ' assigned you a task in '),
                                      TextSpan(
                                          text: '${notification.where}:',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall),
                                    ],
                                  ),
                                ),
                              NotificationType.teamCreation => Text.rich(
                                  TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: owner.firstName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall),
                                      const TextSpan(
                                          text: ' added you to a team:'),
                                    ],
                                  ),
                                ),
                              NotificationType.taskSubmission => Text.rich(
                                  TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: owner.firstName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall),
                                      const TextSpan(
                                          text: ' submitted a task in '),
                                      TextSpan(
                                          text: '${notification.where}:',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall),
                                    ],
                                  ),
                                ),
                              NotificationType.statusUpdate => Text.rich(
                                  TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: owner.firstName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall),
                                      const TextSpan(text: ' marked '),
                                      TextSpan(
                                          text: notification.where,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall),
                                      const TextSpan(text: ' as:'),
                                    ],
                                  ),
                                ),
                              NotificationType.none =>
                                const Text('Invalid Notification')
                            },
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notification.title,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  RHelperFunctions.getDuration(
                                      notification.timeCreated),
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                )
                              ],
                            ),
                            onTap: () {},
                          );
                        },
                      );
                    },
                    separatorBuilder: (_, index) => const Divider(),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
