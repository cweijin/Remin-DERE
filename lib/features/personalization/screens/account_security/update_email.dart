import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:remindere/common/widgets/appbar/appbar.dart';
import 'package:remindere/features/personalization/controllers/account_security_controller.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/constants/text_strings.dart';
import 'package:remindere/utils/validators/validation.dart';

class UpdateEmailScreen extends StatelessWidget {
  const UpdateEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AccountSecurityController.instance;
    return GestureDetector(
      onTap: FocusManager.instance.primaryFocus!.unfocus,
      child: Scaffold(
        appBar: RAppBar(
          showBackArrow: true,
          leadingOnPressed: () {
            Get.back();
            controller.resetFormField();
          },
        ),
        body: Padding(
          padding: const EdgeInsets.all(RSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Headings
              Text(
                'Update Email',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: RSizes.spaceBtwItems),
              Text(
                  'Enter your new email address to be updated. A verification email will be sent to your new email address.',
                  style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: RSizes.spaceBtwSections),

              // Text Field
              Form(
                key: controller.newEmailFormKey,
                child: TextFormField(
                  controller: controller.newEmail,
                  validator: (value) => RValidator.validateEmail(value),
                  decoration: const InputDecoration(
                      labelText: 'New E-Mail',
                      prefixIcon: Icon(Iconsax.direct_right)),
                ),
              ),
              const SizedBox(height: RSizes.spaceBtwSections),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => controller.updateEmail(),
                    child: const Text(RTexts.submit)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
