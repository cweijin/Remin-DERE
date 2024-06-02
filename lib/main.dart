import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindere/utils/theme/theme.dart';
import 'package:remindere/features/authentication/screens/login/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: RAppTheme.lightTheme,
      darkTheme: RAppTheme.darkTheme,
      title: 'Remin-DERE',
      home: const LoginScreen(),
    );
  }
}
