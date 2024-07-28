import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindere/features/authentication/controllers/login/login_controller.dart';
import 'package:remindere/utils/constants/colors.dart';
import 'package:remindere/utils/constants/image_strings.dart';
import 'package:remindere/utils/constants/sizes.dart';

class RSocialMediaButtons extends StatelessWidget {
  const RSocialMediaButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: RColors.grey),
            borderRadius: BorderRadius.circular(100),
          ),
          child: IconButton(
            onPressed: () => controller.googleSignIn(),
            icon: const Image(
              width: RSizes.iconMd,
              height: RSizes.iconMd,
              image: AssetImage(RImages.google),
            ),
          ),
        ),
        // const SizedBox(width: RSizes.spaceBtwItems),
        // Container(
        //   decoration: BoxDecoration(
        //     border: Border.all(color: RColors.grey),
        //     borderRadius: BorderRadius.circular(100),
        //   ),
        //   child: IconButton(
        //     onPressed: () {},
        //     icon: const Image(
        //       width: RSizes.iconLg,
        //       height: RSizes.iconLg,
        //       image: AssetImage(RImages.facebook),
        //     ),
        //   ),
        // ),
        // const SizedBox(width: RSizes.spaceBtwItems),
        // Container(
        //   decoration: BoxDecoration(
        //     border: Border.all(color: RColors.grey),
        //     borderRadius: BorderRadius.circular(100),
        //   ),
        //   child: IconButton(
        //     onPressed: () {},
        //     icon: const Image(
        //       width: RSizes.iconLg,
        //       height: RSizes.iconLg,
        //       image: AssetImage(RImages.twitter),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}