import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:remindere/common/widgets/appbar/appbar.dart';
import 'package:remindere/features/authentication/controllers/forget_password/forget_password_controller.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/constants/text_strings.dart';
import 'package:remindere/utils/validators/validation.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ForgetPasswordController.instance;
    return Scaffold(
      appBar: RAppBar(showBackArrow: true, leadingOnPressed: () => Get.back()),
      body: Padding(
        padding: const EdgeInsets.all(RSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Headings
            Text('Forget password',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: RSizes.spaceBtwItems),
            Text(
                'Provide us with your email and we will send you a password reset link.',
                style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: RSizes.spaceBtwSections * 2),

            // Text Field
            Form(
              key: controller.forgetPasswordFormKey,
              child: TextFormField(
                controller: controller.email,
                validator: RValidator.validateEmail,
                decoration: const InputDecoration(
                    labelText: RTexts.email,
                    prefixIcon: Icon(Iconsax.direct_right)),
              ),
            ),
            const SizedBox(height: RSizes.spaceBtwSections),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () => controller.sendPasswordResetEmail(),
                  child: const Text(RTexts.submit)),
            )
          ],
        ),
      ),
    );
  }
}
