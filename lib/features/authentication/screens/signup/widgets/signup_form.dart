import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:remindere/features/authentication/controllers/signup/signup_controller.dart';
import 'package:remindere/features/authentication/screens/signup/widgets/tnc_checkbox.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/constants/text_strings.dart';
import 'package:remindere/utils/validators/validation.dart';

class RSignUpForm extends StatelessWidget {
  const RSignUpForm({
    super.key,
    required this.isDark,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          Row(
            children: [
              // First & Last Name
              Expanded(
                child: TextFormField(
                  controller: controller.firstName,
                  validator: (value) =>
                      RValidator.validateEmptyText(RTexts.firstName, value),
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: RTexts.firstName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
              const SizedBox(width: RSizes.spaceBtwInputFields),
              Expanded(
                child: TextFormField(
                  controller: controller.lastName,
                  validator: (value) =>
                      RValidator.validateEmptyText(RTexts.lastName, value),
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: RTexts.lastName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: RSizes.spaceBtwInputFields),

          // Username
          TextFormField(
            controller: controller.username,
            validator: (value) =>
                RValidator.validateEmptyText(RTexts.username, value),
            decoration: const InputDecoration(
              labelText: RTexts.username,
              prefixIcon: Icon(Iconsax.user_edit),
            ),
          ),

          const SizedBox(height: RSizes.spaceBtwInputFields),

          // Email
          TextFormField(
            controller: controller.email,
            validator: (value) => RValidator.validateEmail(value),
            decoration: const InputDecoration(
              labelText: RTexts.email,
              prefixIcon: Icon(Iconsax.direct),
            ),
          ),

          const SizedBox(height: RSizes.spaceBtwInputFields),

          // Phone Number
          TextFormField(
            controller: controller.phoneNumber,
            validator: (value) => RValidator.validatePhoneNumber(value),
            decoration: const InputDecoration(
              labelText: RTexts.phoneNo,
              prefixIcon: Icon(Iconsax.call),
            ),
          ),

          const SizedBox(height: RSizes.spaceBtwInputFields),

          //Password
          Obx(
            () => TextFormField(
              controller: controller.password,
              validator: (value) => RValidator.validatePassword(value),
              obscureText: controller.hidePassword.value,
              decoration: InputDecoration(
                labelText: RTexts.password,
                prefixIcon: const Icon(Icons.password),
                suffixIcon: controller.hidePassword.value
                    ? IconButton(
                        icon: const Icon(Iconsax.eye_slash),
                        onPressed: () => controller.hidePassword.value =
                            !controller.hidePassword.value,
                      )
                    : IconButton(
                        icon: const Icon(Iconsax.eye),
                        onPressed: () => controller.hidePassword.value =
                            !controller.hidePassword.value,
                      ),
              ),
            ),
          ),

          const SizedBox(height: RSizes.spaceBtwInputFields),

          // Terms & Conditions Checkbox
          RTNCCheckbox(isDark: isDark),

          const SizedBox(height: RSizes.spaceBtwSections),

          //Sign Up Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.signup(),
              child: const Text(RTexts.createAccount),
            ),
          )
        ],
      ),
    );
  }
}
