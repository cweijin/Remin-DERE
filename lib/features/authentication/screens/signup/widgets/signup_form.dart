import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:remindere/features/authentication/screens/signup/widgets/tnc_checkbox.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/constants/text_strings.dart';

class RSignUpForm extends StatelessWidget {
  const RSignUpForm({
    super.key,
    required this.isDark,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Row(
            children: [
              // First & Last Name
              Expanded(
                child: TextFormField(
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
            decoration: const InputDecoration(
              labelText: RTexts.username,
              prefixIcon: Icon(Iconsax.user_edit),
            ),
          ),

          const SizedBox(height: RSizes.spaceBtwInputFields),

          // Email
          TextFormField(
            decoration: const InputDecoration(
              labelText: RTexts.email,
              prefixIcon: Icon(Iconsax.direct),
            ),
          ),

          const SizedBox(height: RSizes.spaceBtwInputFields),

          // Phone Number
          TextFormField(
            decoration: const InputDecoration(
              labelText: RTexts.phoneNo,
              prefixIcon: Icon(Iconsax.call),
            ),
          ),

          const SizedBox(height: RSizes.spaceBtwInputFields),

          //Password
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              labelText: RTexts.password,
              prefixIcon: Icon(Icons.password),
              suffixIcon: Icon(Iconsax.eye_slash),
            ),
          ),

          const SizedBox(height: RSizes.spaceBtwInputFields),

          // Terms & Conditions Checkbox
          RTNCCheckbox(isDark: isDark),

          const SizedBox(height: RSizes.spaceBtwSections),

          //Sign Up Buttpn
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text(RTexts.createAccount),
            ),
          )
        ],
      ),
    );
  }
}
