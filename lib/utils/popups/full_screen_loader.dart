import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindere/utils/constants/colors.dart';
import 'package:remindere/utils/helpers/helper_functions.dart';

class RFullScreenLoader {
  static void openLoadingDialog(String text) {
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      builder: (value) => PopScope(
        child: Container(
            color: RHelperFunctions.isDarkMode(Get.context!)
                ? RColors.dark
                : RColors.white,
            width: double.infinity,
            height: double.infinity,
            child: Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: double.infinity),
                  Text(text),
                ],
              ),
            )),
      ),
    );
  }

  static void stopLoading() {
    Navigator.of(Get.overlayContext!).pop();
  }
}
