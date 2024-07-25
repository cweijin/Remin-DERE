import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:remindere/common/widgets/appbar/appbar.dart';
import 'package:remindere/common/widgets/shimmer/shimmer.dart';
import 'package:remindere/features/development/screens/notification/notification.dart';
import 'package:remindere/features/personalization/controllers/user_controller.dart';

import 'dart:developer';

class RHomeAppBar extends StatelessWidget {
  const RHomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return RAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome back to Remin-DERE, ',
              style: Theme.of(context).textTheme.bodySmall),
          Obx(() {
            if (controller.profileLoading.value) {
              return const RShimmerEffect(width: 100, height: 15);
            } else {
              return Text(
                controller.user.value.fullName,
                style: Theme.of(context).textTheme.headlineSmall,
              );
            }
          }),
        ],
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Iconsax.notification),
              onPressed: () {
                controller.notificationRead();
                Get.to(() => const NotificationScreen());
              },
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Obx(() => controller.user.value.unread != 0
                  ? Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    )
                  : const SizedBox()),
            )
          ],
        )
      ],
    );
  }
}
