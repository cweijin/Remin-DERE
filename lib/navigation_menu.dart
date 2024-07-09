import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:remindere/features/calendar/screens/calendar.dart';
import 'package:remindere/features/development/screens/chat/screens/chat.dart';
import 'package:remindere/features/development/screens/home/home.dart';
import 'package:remindere/features/personalization/screens/profile/profile.dart';
import 'package:remindere/features/taskallocation/screens/manual_allocation/manual_allocation.dart';
import 'package:remindere/utils/constants/colors.dart';
import 'package:remindere/utils/helpers/helper_functions.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final bool isDark = RHelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          backgroundColor: isDark ? RColors.black : RColors.white,
          indicatorColor: isDark
              ? RColors.white.withOpacity(0.1)
              : RColors.black.withOpacity(0.1),
          destinations: const [
            // Home Page
            NavigationDestination(
              icon: Icon(Iconsax.home),
              label: 'Home',
            ),

            // Calendar
            NavigationDestination(
              icon: Icon(Iconsax.calendar),
              label: 'Calendar',
            ),

            // Notification
            NavigationDestination(
              icon: Icon(Iconsax.add),
              label: 'Create',
            ),

            // Chat
            NavigationDestination(
              icon: Icon(Iconsax.message),
              label: 'Inbox',
            ),

            // Profile
            NavigationDestination(
              icon: Icon(Iconsax.user),
              label: 'Profile',
            ),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    const CalendarScreen(),
    const ManualAllocation(),
    const ChatScreen(),
    const ProfileScreen(),
  ];
}
