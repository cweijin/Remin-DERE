import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindere/common/widgets/appbar/appbar.dart';
import 'package:remindere/features/authentication/controllers/forget_password/forget_password_controller.dart';
import 'package:remindere/features/authentication/screens/login/login.dart';
import 'package:remindere/features/authentication/screens/password_configuration/forget_password.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/constants/text_strings.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, required this.email});

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
                'Password Reset Email Sent',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSizes.spaceBtwItems),

              Text(
                'We have sent you a secure link to safely change your password and keep your account protected.',
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSizes.spaceBtwSections),

              // Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user == null) {
                        Get.offAll(() => const LoginScreen());
                      } else {
                        Get.back();
                      }
                    },
                    child: const Text(RTexts.done)),
              ),
              const SizedBox(height: RSizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () => ForgetPasswordController.instance
                        .resendPasswordResetEmail(email),
                    child: const Text(RTexts.resendEmail)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
