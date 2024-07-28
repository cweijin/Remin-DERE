import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:remindere/common/widgets/appbar/appbar.dart';
import 'package:remindere/features/personalization/controllers/account_security_controller.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/constants/text_strings.dart';
import 'package:remindere/utils/validators/validation.dart';

class ReAuthenticateScreen extends StatelessWidget {
  const ReAuthenticateScreen({super.key, required this.emailRequired});

  final bool emailRequired;

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
                'Re-Authenticate User',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: RSizes.spaceBtwItems),
              Text(
                  'Re-authentication is required before ${emailRequired ? 'proceeding to account closure' : 'changing your email'}.',
                  style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: RSizes.spaceBtwSections),

              // Text Field
              Form(
                key: controller.reAuthFormKey,
                child: Column(
                  children: [
                    emailRequired
                        ? Column(
                            children: [
                              TextFormField(
                                controller: controller.verifyEmail,
                                validator: (value) =>
                                    RValidator.validateEmail(value),
                                decoration: const InputDecoration(
                                    labelText: RTexts.email,
                                    prefixIcon: Icon(Iconsax.direct_right)),
                              ),
                              const SizedBox(height: RSizes.spaceBtwItems)
                            ],
                          )
                        : const SizedBox(),
                    Obx(
                      () => TextFormField(
                        controller: controller.verifyPassword,
                        obscureText: controller.hidePassword.value,
                        validator: (value) =>
                            RValidator.validateEmptyText('Password', value),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.password),
                          labelText: RTexts.password,
                          suffixIcon: IconButton(
                            icon: controller.hidePassword.value
                                ? const Icon(Iconsax.eye_slash)
                                : const Icon(Iconsax.eye),
                            onPressed: () => controller.hidePassword.value =
                                !controller.hidePassword.value,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: RSizes.spaceBtwSections),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: emailRequired
                    ? ElevatedButton(
                        onPressed: () async => await controller
                            .reAuthenticateUser(emailRequired: emailRequired),
                        style: const ButtonStyle(
                          side: WidgetStatePropertyAll(
                              BorderSide(color: Colors.redAccent)),
                          backgroundColor: WidgetStatePropertyAll(Colors.red),
                        ),
                        child: const Text('Confirm Account Closure'),
                      )
                    : ElevatedButton(
                        onPressed: () async => await controller
                            .reAuthenticateUser(emailRequired: emailRequired),
                        child: const Text('Authenticate')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
