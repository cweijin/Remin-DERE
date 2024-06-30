import 'package:flutter/material.dart';
import 'package:remindere/utils/constants/sizes.dart';
import '../../constants/colors.dart';

class RAppBarTheme {
  RAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: RColors.primary,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: RColors.black, size: RSizes.iconMd),
    actionsIconTheme: IconThemeData(color: RColors.black, size: RSizes.iconMd),
    titleTextStyle: TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.w600, color: RColors.black),
  );
  static const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: RColors.black, size: RSizes.iconMd),
    actionsIconTheme: IconThemeData(color: RColors.white, size: RSizes.iconMd),
    titleTextStyle: TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.w600, color: RColors.white),
  );
}
