import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindere/features/authentication/screens/login/login.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: double.infinity),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                  onPressed: () {
                    auth.signOut();
                    Get.offAll(const LoginScreen());
                  },
                  child: const Text('Logout')),
            )
          ],
        ),
      ),
    );
  }
}
