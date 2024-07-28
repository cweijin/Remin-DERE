import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindere/common/widgets/appbar/appbar.dart';
import 'package:remindere/features/personalization/controllers/account_security_controller.dart';
import 'package:remindere/features/personalization/screens/account_security/re_authenticate.dart';
import 'package:remindere/utils/constants/sizes.dart';

class AccountSecurityScreen extends StatelessWidget {
  const AccountSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AccountSecurityController.instance;

    return Scaffold(
      appBar: RAppBar(
        showBackArrow: true,
        leadingOnPressed: () => Get.back(),
        title: const Text('Account Security'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(RSizes.defaultSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                  onPressed: () => Get.to(
                        () => const ReAuthenticateScreen(
                          emailRequired: false,
                        ),
                      ),
                  child: const Text('Reset Email')),
            ),
            const SizedBox(height: RSizes.spaceBtwItems),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () => controller.sendPasswordResetEmail(),
                  child: const Text('Reset Password')),
            ),
            const SizedBox(height: RSizes.spaceBtwItems),
            Center(
              child: TextButton(
                child: const Text(
                  'Close account',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () => controller.deleteAccountWarningPopup(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
