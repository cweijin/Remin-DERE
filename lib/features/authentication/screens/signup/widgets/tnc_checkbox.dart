import 'package:flutter/material.dart';
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
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(value: true, onChanged: (value) {}),
        ),
        const SizedBox(width: RSizes.spaceBtwItems),
        Text.rich(
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
                      decorationColor: isDark ? RColors.white : RColors.primary,
                    ),
              ),
              TextSpan(text: ' ', style: Theme.of(context).textTheme.bodySmall),
              TextSpan(
                  text: '${RTexts.and} ',
                  style: Theme.of(context).textTheme.bodySmall),
              TextSpan(
                text: '${RTexts.termsOfUse} ',
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                      color: isDark ? RColors.white : RColors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: isDark ? RColors.white : RColors.primary,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
