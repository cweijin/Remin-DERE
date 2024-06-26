import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:remindere/common/styles/spacing_styles.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/constants/colors.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Calendar'),
          centerTitle: true,
        ),
        backgroundColor: Colors.orange,
        body: RCalendar());
  }
}

// actual calendar
class RCalendar extends StatefulWidget {
  @override
  _RCalendarState createState() => _RCalendarState();
}

class _RCalendarState extends State<RCalendar> {
  DateTime selectedDate = DateTime.now(); // TO tracking date

  int currentDateSelectedIndex = 0; //For Horizontal Date
  ScrollController scrollController =
      ScrollController(); //To Track Scroll of ListView

  List<String> listOfMonths = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  List<String> listOfDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      // no appBar
      body: Column(
        children: [
          //To Show Current Date
          Container(
              height: RSizes.md,
              margin: RSpacingStyle.paddingWithAppBarHeight,
              alignment: Alignment.centerLeft,
              child: Text(
                selectedDate.day.toString() +
                    ' ' +
                    listOfMonths[selectedDate.month - 1] +
                    ', ' +
                    selectedDate.year.toString(),
                style: TextStyle(
                    fontSize: RSizes.fontSizesm,
                    fontWeight: FontWeight.w800,
                    color: RColors.primary),
              )),

          const SizedBox(height: RSizes.spaceBtwSections),

          //To show Calendar Widget
          Container(
              height: 100, // need new RSizes
              child: Container(
                  child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                      width: RSizes.md); // seperation of scrollables
                },
                itemCount: 365,
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        currentDateSelectedIndex = index;
                        selectedDate =
                            DateTime.now().add(Duration(days: index));
                      });
                    },
                    child: Container(
                      height: 32,
                      width: 64, // need new Rsizes
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          // boxshadow does not work
                          boxShadow: [
                            BoxShadow(
                                color: (RColors.darkGrey),
                                offset: Offset(2, 2),
                                blurRadius: 3)
                          ],
                          color: currentDateSelectedIndex == index
                              ? RColors.buttonSecondary
                              : RColors.buttonPrimary),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // month
                          Text(
                            listOfMonths[DateTime.now()
                                        .add(Duration(days: index))
                                        .month -
                                    1]
                                .toString(),
                            style: TextStyle(
                                fontSize: RSizes.fontSizesm,
                                color: currentDateSelectedIndex == index
                                    ? Colors.white
                                    : Colors.grey),
                          ),

                          const SizedBox(height: RSizes.spaceBtwItems),

                          // day
                          Text(
                            DateTime.now()
                                .add(Duration(days: index))
                                .day
                                .toString(),
                            style: TextStyle(
                                fontSize: RSizes.fontSizesm,
                                fontWeight: FontWeight.w700,
                                color: currentDateSelectedIndex == index
                                    ? RColors.textWhite
                                    : RColors.textSecondary),
                          ),

                          const SizedBox(height: RSizes.spaceBtwItems),

                          // weekday
                          Text(
                            listOfDays[DateTime.now()
                                        .add(Duration(days: index))
                                        .weekday -
                                    1]
                                .toString(),
                            style: TextStyle(
                                fontSize: RSizes.fontSizesm,
                                color: currentDateSelectedIndex == index
                                    ? RColors.textWhite
                                    : RColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ))),

          // to show assigned tasks

          Expanded(
              child: ListView(
            padding: RSpacingStyle.paddingWithAppBarHeight,
            children: <Widget>[
              Container(
                height: 50,
                color: Colors.amber[600],
                child: const Center(child: Text('Entry A')),
              ),
              Container(
                height: 50,
                color: Colors.amber[500],
                child: const Center(child: Text('Entry B')),
              ),
              Container(
                height: 50,
                color: Colors.amber[100],
                child: const Center(child: Text('Entry C')),
              ),
              Container(
                height: 50,
                color: Colors.amber[100],
                child: const Center(child: Text('Entry C')),
              ),
              Container(
                height: 50,
                color: Colors.amber[100],
                child: const Center(child: Text('Entry C')),
              ),
              Container(
                height: 50,
                color: Colors.amber[100],
                child: const Center(child: Text('Entry C')),
              ),
              Container(
                height: 50,
                color: Colors.amber[100],
                child: const Center(child: Text('Entry C')),
              ),
              Container(
                height: 50,
                color: Colors.amber[100],
                child: const Center(child: Text('Entry C')),
              ),
              Container(
                height: 50,
                color: Colors.amber[100],
                child: const Center(child: Text('Entry C')),
              ),
              Container(
                height: 50,
                color: Colors.amber[100],
                child: const Center(child: Text('Entry C')),
              ),
              Container(
                height: 50,
                color: Colors.amber[100],
                child: const Center(child: Text('Entry C')),
              ),
            ],
          ))
        ],
      ),
    ));
  }
}
