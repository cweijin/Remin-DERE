import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindere/features/authentication/controllers/signup/signup_controller.dart';
import 'package:remindere/utils/constants/colors.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/constants/text_strings.dart';

class RTNCCheckbox extends StatelessWidget {
  const RTNCCheckbox({
    super.key,
    required this.isDark,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final controller = SignupController.instance;
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Obx(
            () => Checkbox(
                value: controller.checkTNC.value,
                onChanged: (value) =>
                    controller.checkTNC.value = !controller.checkTNC.value),
          ),
        ),
        const SizedBox(width: RSizes.spaceBtwItems),
        Flexible(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${RTexts.iAgreeToThe} ',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextSpan(
                  text: RTexts.privacyPolicy,
                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                        color: isDark ? RColors.white : RColors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor:
                            isDark ? RColors.white : RColors.primary,
                      ),
                ),
                TextSpan(
                    text: ' ', style: Theme.of(context).textTheme.bodySmall),
                TextSpan(
                    text: '${RTexts.and} ',
                    style: Theme.of(context).textTheme.bodySmall),
                TextSpan(
                  text: '${RTexts.termsOfUse} ',
                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                        color: isDark ? RColors.white : RColors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor:
                            isDark ? RColors.white : RColors.primary,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
