import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:remindere/common/styles/spacing_styles.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/constants/colors.dart';
import 'package:remindere/features/calendar/controllers/calendar_task_controller.dart';

// actual calendar
class RCalendar extends StatelessWidget {
  const RCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CalendarTaskController.instance;

    return Obx(() => Column(
            // Use key to trigger refresh
            key: Key(controller.refreshData.value.toString()),
            children: [
              Row(children: [
              //To Show Current Date
              Container(
                  height: RSizes.md,
                  margin: RSpacingStyle.paddingWithAppBarHeight,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    controller.showDate(),
                    style: const TextStyle(
                        fontSize: RSizes.fontSizesm,
                        fontWeight: FontWeight.w800,
                        color: RColors.primary),
                  )),

                  const Expanded(child: SizedBox()),

                  // switch from personal calendar to team calendar
                  ElevatedButton(
                    onPressed: () {controller.team.toggle();},
                    child: controller.team.value ? const Text("View Personal Calendar") : const Text("View Team Calendar")
                  ), 

                  const SizedBox()
                ]
              ),

              const SizedBox(height: RSizes.spaceBtwSections),

              //To show Calendar Widget
              SizedBox(
                height: 100, // need new RSizes
                child: Container(
                    child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                        width: RSizes.md); // seperation of scrollables
                  },
                  itemCount: 365,
                  controller: controller.scrollController,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        controller.refreshData.toggle();
                        controller.currentDateSelectedIndex = index;
                        controller.selectedDate =
                            DateTime.now().add(Duration(days: index));
                      },
                      child: Container(
                        height: 32,
                        width: 64, // need new Rsizes
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            // boxshadow does not work
                            boxShadow: const [
                              BoxShadow(
                                  color: (RColors.darkGrey),
                                  offset: Offset(2, 2),
                                  blurRadius: 3)
                            ],
                            color: controller.currentDateSelectedIndex == index
                                ? RColors.buttonSecondary
                                : RColors.buttonPrimary),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // month
                            Text(
                              controller.showMonth(index),
                              style: TextStyle(
                                  fontSize: RSizes.fontSizesm,
                                  color: controller.currentDateSelectedIndex ==
                                          index
                                      ? Colors.white
                                      : Colors.grey),
                            ),

                            const SizedBox(height: RSizes.spaceBtwItems),

                            // day
                            Text(
                              controller.showDay(index),
                              style: TextStyle(
                                  fontSize: RSizes.fontSizesm,
                                  fontWeight: FontWeight.w700,
                                  color: controller.currentDateSelectedIndex ==
                                          index
                                      ? RColors.textWhite
                                      : RColors.textSecondary),
                            ),

                            const SizedBox(height: RSizes.spaceBtwItems),

                            // weekday
                            Text(
                              controller.showWeekDay(index),
                              style: TextStyle(
                                  fontSize: RSizes.fontSizesm,
                                  color: controller.currentDateSelectedIndex ==
                                          index
                                      ? RColors.textWhite
                                      : RColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )),
              ),
            ]
          )
        );
  }
}
