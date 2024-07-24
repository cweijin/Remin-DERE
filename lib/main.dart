import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:remindere/bindings/general_bindings.dart';
import 'package:remindere/data/repositories/authentication_repository/authentication_repository.dart';
import 'package:remindere/utils/constants/colors.dart';
import 'package:remindere/utils/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

Future<void> main() async {
  // Initialize Widgets Binding
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  // Initialize Local Storage
  await GetStorage.init();

  // Await splash until other items loaded
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize Firebase & Authentication Repository
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then(
    (FirebaseApp value) async {
      //for unit testing
      // if (kDebugMode) {
      //   try {
      //     await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
      //     FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      //   } catch (e) {
      //     // ignore: avoid_print
      //     print(e);
      //   }
      // }

      Get.put(AuthenticationRepository());
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Root of application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: RAppTheme.lightTheme,
      darkTheme: RAppTheme.darkTheme,
      initialBinding: GeneralBingdings(),
      title: 'Remin-DERE',
      home: const Scaffold(
        backgroundColor: RColors.primary,
        body: Center(child: CircularProgressIndicator(color: RColors.white)),
      ),
    );
  }
}
