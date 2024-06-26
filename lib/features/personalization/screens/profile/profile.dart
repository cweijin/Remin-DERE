import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindere/common/styles/spacing_styles.dart';
import 'package:remindere/features/authentication/screens/login/login.dart';
import 'package:remindere/utils/constants/image_strings.dart';
import 'package:remindere/utils/constants/sizes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              //alignment: Alignment.center,
              children: [
                const SizedBox(height: 360),
                Image.asset(
                  RImages.background1,
                  width: double.infinity,
                ),
                Positioned(
                  top: 200,
                  left: width - 180,
                  child: const CircleAvatar(
                    radius: 80,
                  ),
                ),
                Positioned(
                  top: 300,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      top: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Kaiya Morrow",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text("Software Engineer",
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: RSpacingStyle.paddingWithAppBarHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Your teams",
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: RSizes.spaceBtwItems),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        InkWell(
                          splashColor: Colors.grey,
                          onTap: () {},
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 200,
                              width: 200),
                        ),
                        const SizedBox(width: 10, height: 200),
                        InkWell(
                          splashColor: Colors.grey,
                          onTap: () {},
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 200,
                              width: 200),
                        ),
                        const SizedBox(width: 10, height: 200),
                        InkWell(
                          splashColor: Colors.grey,
                          onTap: () {},
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 200,
                              width: 200),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: RSizes.spaceBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text("Personal Details"),
                    ),
                  ),
                  const SizedBox(height: RSizes.spaceBtwItems),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text("Account Security"),
                    ),
                  ),
                  const SizedBox(height: RSizes.spaceBtwItems),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text("Settings"),
                    ),
                  ),
                  const SizedBox(height: RSizes.spaceBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          auth.signOut();
                          Get.offAll(const LoginScreen());
                        },
                        child: const Text('Logout')),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   body: SafeArea(
    //     child: Padding(
    //       padding: const EdgeInsets.all(16.0),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           const CircleAvatar(
    //             radius: 50,
    //             backgroundImage:
    //                 AssetImage(''), // Replace with your image asset
    //           ),
    //           const SizedBox(height: 16),
    //           const Text(
    //             'Kaiya Morrow',
    //             style: TextStyle(
    //               fontSize: 24,
    //               fontWeight: FontWeight.bold,
    //             ),
    //           ),
    //           const Text(
    //             'Software Engineer',
    //             style: TextStyle(
    //               fontSize: 16,
    //               color: Colors.grey,
    //             ),
    //           ),
    //           const SizedBox(height: 16),
    //           Text(
    //             'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer sem sapien, mattis a cursus vel, tristique in nulla. Ut eu sem lorem.',
    //             textAlign: TextAlign.center,
    //             style: TextStyle(
    //               fontSize: 14,
    //               color: Colors.grey[700],
    //             ),
    //           ),
    //           const SizedBox(height: 24),
    //           const Text(
    //             'Your teams',
    //             style: TextStyle(
    //               fontSize: 18,
    //               fontWeight: FontWeight.bold,
    //             ),
    //           ),
    //           const SizedBox(height: 16),
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Container(
    //                 width: 100,
    //                 height: 100,
    //                 color: Colors.grey[300],
    //               ),
    //               const SizedBox(width: 16),
    //               Container(
    //                 width: 100,
    //                 height: 100,
    //                 color: Colors.grey[300],
    //               ),
    //             ],
    //           ),
    //           const SizedBox(height: 24),
    //           ElevatedButton(
    //             onPressed: () {},
    //             style: ElevatedButton.styleFrom(
    //               side: const BorderSide(color: Colors.grey),
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(8),
    //               ),
    //             ),
    //             child: const Text('Personal Details'),
    //           ),
    //           const SizedBox(height: 8),
    //           ElevatedButton(
    //             onPressed: () {},
    //             style: ElevatedButton.styleFrom(
    //               side: const BorderSide(color: Colors.grey),
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(8),
    //               ),
    //             ),
    //             child: const Text('Account Security'),
    //           ),
    //           const SizedBox(height: 8),
    //           ElevatedButton(
    //             onPressed: () {},
    //             child: const Text('App Setting'),
    //             style: ElevatedButton.styleFrom(
    //               side: const BorderSide(color: Colors.grey),
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(8),
    //               ),
    //             ),
    //           ),
    //           const Spacer(),
    //           ElevatedButton(
    //             onPressed: () {},
    //             child: const Text('Logout'),
    //             style: ElevatedButton.styleFrom(
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(8),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
