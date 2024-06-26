import 'package:flutter/material.dart';
import 'package:remindere/common/widgets/login_signup/form_divider.dart';
import 'package:remindere/common/widgets/login_signup/social_media_buttons.dart';
import 'package:remindere/features/authentication/screens/login/widgets/login_form.dart';
import 'package:remindere/features/authentication/screens/login/widgets/login_header.dart';
import 'package:remindere/utils/constants/text_strings.dart';
import 'package:remindere/utils/helpers/helper_functions.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../common/styles/spacing_styles.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = RHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: RSpacingStyle.paddingWithAppBarHeight,
            child: Column(
              children: [
                // Logo, Title & Sub-Title
                RLoginHeader(isDark: isDark),

                //Form
                const RLoginForm(),

                //Divider
                RFormDivider(
                  isDark: isDark,
                  dividerText: RTexts.orSignInWith,
                ),

                const SizedBox(height: RSizes.spaceBtwSections),

                //Footer
                const RSocialMediaButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
