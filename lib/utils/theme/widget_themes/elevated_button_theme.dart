import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';

/* -- Light & Dark Elevated Button Themes -- */
class RElevatedButtonTheme {
  RElevatedButtonTheme._(); //To avoid creating instances

  /* -- Light Theme -- */
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: RColors.light,
      backgroundColor: RColors.primary,
      disabledForegroundColor: RColors.darkGrey,
      disabledBackgroundColor: RColors.buttonDisabled,
      side: const BorderSide(color: RColors.primary),
      padding: const EdgeInsets.symmetric(vertical: RSizes.buttonHeight),
      textStyle: const TextStyle(
          fontSize: 16, color: RColors.textWhite, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RSizes.buttonRadius)),
    ),
  );

  /* -- Dark Theme -- */
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: RColors.light,
      backgroundColor: RColors.primary,
      disabledForegroundColor: RColors.darkGrey,
      disabledBackgroundColor: RColors.darkerGrey,
      side: const BorderSide(color: RColors.primary),
      padding: const EdgeInsets.symmetric(vertical: RSizes.buttonHeight),
      textStyle: const TextStyle(
          fontSize: 16, color: RColors.textWhite, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RSizes.buttonRadius)),
    ),
  );
}
