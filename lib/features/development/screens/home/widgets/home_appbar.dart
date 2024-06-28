import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:remindere/common/widgets/appbar/appbar.dart';
import 'package:remindere/common/widgets/shimmer/shimmer.dart';
import 'package:remindere/features/personalization/controllers/user_controller.dart';

class RHomeAppBar extends StatelessWidget {
  const RHomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
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
                icon: const Icon(Iconsax.notification), onPressed: () {}),
            Positioned(
              right: 0,
              child: Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
