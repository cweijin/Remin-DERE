import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:remindere/features/calendar/screens/calendar.dart';
import 'package:remindere/features/development/screens/chat/screens/chat.dart';
import 'package:remindere/features/development/screens/home/home.dart';
import 'package:remindere/features/personalization/controllers/team_controller.dart';
import 'package:remindere/features/personalization/controllers/user_controller.dart';
import 'package:remindere/features/personalization/screens/profile/profile.dart';
import 'package:remindere/features/task_allocation/screens/manual_allocation/manual_allocation.dart';
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
          destinations: controller.isTeamOwner.value
              ? const [
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

                  // Task Allocation
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
                ]
              : const [
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
      body: Obx(() => controller.isTeamOwner.value
          ? controller.ownerScreens[controller.selectedIndex.value]
          : controller.memberScreens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  static NavigationController get instance => Get.find();
  final Rx<int> selectedIndex = 0.obs;
  final RxBool isTeamOwner = false.obs;

  final ownerScreens = [
    const HomeScreen(),
    const CalendarScreen(),
    const ManualAllocation(),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  final memberScreens = [
    const HomeScreen(),
    const CalendarScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  @override
  void onInit() {
    super.onInit();
    verifyOwnership();
  }

  void verifyOwnership() {
    final userId = UserController.instance.user.value.id;
    final teamOwnerId = TeamController.instance.team.value.owner;

    if (isTeamOwner.value && userId != teamOwnerId) {
      selectedIndex.value > 2
          ? selectedIndex.value -= 1
          : 0 /*else do nothing*/;
    } else if (!isTeamOwner.value && userId == teamOwnerId) {
      selectedIndex.value > 1
          ? selectedIndex.value += 1
          : 0 /*else do nothing*/;
    }

    isTeamOwner.value = userId == teamOwnerId;
    log(isTeamOwner.value.toString());
  }

  void navigateTo(int screenIndex) {
    selectedIndex.value = screenIndex;
  }
}
