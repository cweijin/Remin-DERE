import 'package:flutter/material.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/constants/image_strings.dart';
import 'package:remindere/utils/constants/text_strings.dart';

class RLoginHeader extends StatelessWidget {
  const RLoginHeader({
    super.key,
    required this.isDark,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: double.maxFinite),
        Center(
          child: Image(
            height: 150,
            image:
                AssetImage(isDark ? RImages.darkAppLogo : RImages.lightAppLogo),
          ),
        ),
        const SizedBox(
          height: RSizes.md,
        ),
        Text(
          RTexts.loginTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: RSizes.md),
        Text(RTexts.loginSubTitle,
            style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
