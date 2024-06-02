import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class RChipTheme {
  RChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    disabledColor: RColors.grey.withOpacity(0.4),
    labelStyle: const TextStyle(color: RColors.black),
    selectedColor: RColors.primary,
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    checkmarkColor: RColors.white,
  );

  static ChipThemeData darkChipTheme = const ChipThemeData(
    disabledColor: RColors.darkerGrey,
    labelStyle: TextStyle(color: RColors.white),
    selectedColor: RColors.primary,
    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    checkmarkColor: RColors.white,
  );
}
