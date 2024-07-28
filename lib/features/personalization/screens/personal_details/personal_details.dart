import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:remindere/common/styles/spacing_styles.dart';
import 'package:remindere/common/widgets/appbar/appbar.dart';
import 'package:remindere/features/personalization/controllers/personal_details_controller.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/constants/text_strings.dart';
import 'package:remindere/utils/validators/validation.dart';

class PersonalDetailsScreen extends StatelessWidget {
  const PersonalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = PersonalDetailsController.instance;

    return GestureDetector(
      onTap: FocusManager.instance.primaryFocus!.unfocus,
      child: Scaffold(
        appBar: RAppBar(
          showBackArrow: true,
          leadingOnPressed: () => Get.back(),
          title: const Text('Change Personal Details'),
        ),
        body: Padding(
          padding: RSpacingStyle.paddingWithAppBarHeight,
          child: Form(
            key: controller.detailsFormKey,
            child: Column(
              children: [
                Row(
                  children: [
                    // First & Last Name
                    Expanded(
                      child: TextFormField(
                        controller: controller.firstName,
                        validator: (value) => RValidator.validateEmptyText(
                            RTexts.firstName, value),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        validator: (value) => RValidator.validateEmptyText(
                            RTexts.lastName, value),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: RTexts.username,
                    prefixIcon: Icon(Iconsax.user_edit),
                  ),
                ),

                // const SizedBox(height: RSizes.spaceBtwInputFields),

                // Email
                // TextFormField(
                //   controller: controller.email,
                //   validator: (value) => RValidator.validateEmail(value),
                //   autovalidateMode: AutovalidateMode.onUserInteraction,
                //   decoration: const InputDecoration(
                //     labelText: RTexts.email,
                //     prefixIcon: Icon(Iconsax.direct),
                //   ),
                // ),

                const SizedBox(height: RSizes.spaceBtwInputFields),

                // Phone Number
                TextFormField(
                  controller: controller.phoneNumber,
                  validator: (value) => RValidator.validatePhoneNumber(value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: RTexts.phoneNo,
                    prefixIcon: Icon(Iconsax.call),
                  ),
                ),

                const SizedBox(height: RSizes.spaceBtwInputFields),

                //Save Details Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => {controller.updateDetails()},
                    child: const Text('Save Details'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
