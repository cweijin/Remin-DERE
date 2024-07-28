import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindere/common/styles/spacing_styles.dart';
import 'package:remindere/features/authentication/screens/login/login.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;

    return Scaffold(
      body: Expanded(
        child: Padding(
          padding: RSpacingStyle.paddingWithAppBarHeight,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: double.infinity),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        auth.signOut();
                        Get.offAll(const LoginScreen());
                      },
                      child: const Text('Logout')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
