import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindere/common/widgets/appbar/appbar.dart';
import 'package:remindere/features/personalization/controllers/account_security_controller.dart';
import 'package:remindere/navigation_menu.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/constants/text_strings.dart';

class ResetEmailScreen extends StatelessWidget {
  const ResetEmailScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RAppBar(
        leadingIcon: CupertinoIcons.clear,
        leadingOnPressed: () => Get.back(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(RSizes.defaultSpace),
          child: Column(
            children: [
              // Email, Title & Subtitle
              Text(
                email,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSizes.spaceBtwItems),

              Text(
                'Verification email sent',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSizes.spaceBtwItems),

              Text(
                'We have sent you a secure link to safely change your email and keep your account protected.',
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSizes.spaceBtwSections),

              // Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async =>
                        await Get.off(() => const NavigationMenu()),
                    child: const Text(RTexts.done)),
              ),
              const SizedBox(height: RSizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () => AccountSecurityController.instance
                        .resendUpdateEmail(email),
                    child: const Text(RTexts.resendEmail)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
