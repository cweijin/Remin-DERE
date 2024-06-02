import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:remindere/features/authentication/controllers/login/login_controller.dart';
import 'package:remindere/features/authentication/screens/signup/signup.dart';
import 'package:remindere/navigation_menu.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/constants/text_strings.dart';
import 'package:remindere/utils/validators/validation.dart';

class RLoginForm extends StatelessWidget {
  const RLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Form(
      key: controller.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: RSizes.spaceBtwSections),
        child: Column(
          children: [
            //Email
            TextFormField(
              controller: controller.email,
              validator: (value) => RValidator.validateEmail(value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: RTexts.email,
              ),
            ),

            const SizedBox(height: RSizes.spaceBtwInputFields),

            //Password
            Obx(
              () => TextFormField(
                controller: controller.password,
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

            const SizedBox(height: RSizes.spaceBtwInputFields / 2),

            // Remember Me & Forget Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Remember Me
                Row(
                  children: [
                    Obx(
                      () => Checkbox(
                        value: controller.rememberMe.value,
                        onChanged: (value) => controller.rememberMe.value =
                            !controller.rememberMe.value,
                      ),
                    ),
                    const Text(RTexts.rememberMe),
                  ],
                ),

                //Forget Password
                TextButton(
                  onPressed: () {},
                  child: const Text(RTexts.forgetPassword),
                )
              ],
            ),

            const SizedBox(height: RSizes.spaceBtwSections),

            //Sign In Buttion
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.emailAndPasswordSignIn(),
                child: const Text(RTexts.signIn),
              ),
            ),

            const SizedBox(height: RSizes.spaceBtwItems),

            //Create Account Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.to(() => const SignupScreen()),
                child: const Text(RTexts.createAccount),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
