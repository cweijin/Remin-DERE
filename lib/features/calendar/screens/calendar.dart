import 'package:flutter/material.dart';
import 'package:remindere/features/calendar/widgets/calendar_view.dart';
import 'package:remindere/features/calendar/widgets/calendar_task_view.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final width = RDeviceUtils.getScreenWidth(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Calendar'),
          centerTitle: true,
        ),
        // backgroundColor: Colors.white,
        body: const SafeArea(
          child: Column(
              children: [
                RCalendar(),
                RTaskView()
              ]
            )
          )
        );
  }
}

