import 'package:flutter/material.dart';
import 'package:remindere/common/widgets/login_signup/form_divider.dart';
import 'package:remindere/common/widgets/login_signup/social_media_buttons.dart';
import 'package:remindere/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/constants/text_strings.dart';
import 'package:remindere/utils/helpers/helper_functions.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = RHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(RSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Title
              Text(RTexts.signupTitle,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: RSizes.spaceBtwSections),

              //Form
              RSignUpForm(isDark: isDark),
              const SizedBox(height: RSizes.spaceBtwSections),

              // Divider
              RFormDivider(
                isDark: isDark,
                dividerText: RTexts.orSignUpWith,
              ),
              const SizedBox(height: RSizes.spaceBtwSections),

              // Social Media Buttons
              const RSocialMediaButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
