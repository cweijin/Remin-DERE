import 'package:flutter/material.dart';
import 'package:remindere/features/calendar/widgets/calendar.dart';
import 'package:remindere/features/calendar/widgets/task_view.dart';

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
        backgroundColor: Colors.orange,
        body: SafeArea(
          child: Column(
              children: [
                RCalendar(),
                const RTaskView()
              ]
            )
          )
        );
  }
}

