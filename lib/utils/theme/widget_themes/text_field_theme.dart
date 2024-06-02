import 'package:flutter/material.dart';
import 'package:remindere/utils/constants/colors.dart';
import '../../constants/sizes.dart';

class RTextFormFieldTheme {
  RTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: RColors.darkGrey,
    suffixIconColor: RColors.darkGrey,
    // constraints: const BoxConstraints.expand(height: RSizes.inputFieldHeight),
    labelStyle: const TextStyle()
        .copyWith(fontSize: RSizes.fontSizeMd, color: RColors.black),
    hintStyle: const TextStyle()
        .copyWith(fontSize: RSizes.fontSizesm, color: RColors.black),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle:
        const TextStyle().copyWith(color: RColors.black.withOpacity(0.8)),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(RSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: RColors.grey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(RSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: RColors.grey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(RSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: RColors.dark),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(RSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: RColors.warning),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(RSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: RColors.warning),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,
    prefixIconColor: RColors.darkGrey,
    suffixIconColor: RColors.darkGrey,
    // constraints: const BoxConstraints.expand(height: RSizes.inputFieldHeight),
    labelStyle: const TextStyle()
        .copyWith(fontSize: RSizes.fontSizeMd, color: RColors.white),
    hintStyle: const TextStyle()
        .copyWith(fontSize: RSizes.fontSizesm, color: RColors.white),
    floatingLabelStyle:
        const TextStyle().copyWith(color: RColors.white.withOpacity(0.8)),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(RSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: RColors.darkGrey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(RSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: RColors.darkGrey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(RSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: RColors.white),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(RSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: RColors.warning),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(RSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: RColors.warning),
    ),
  );
}
