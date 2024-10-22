import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:remindere/data/repositories/calendar_event_repository/task_repository.dart';
import 'package:remindere/features/task_allocation/models/task_model.dart';
import 'package:remindere/utils/popups/loaders.dart';

class TaskController extends GetxController {
  // data for taskview
  static TaskController get instance => Get.find();
  final taskRepository = Get.put(TaskRepository());
  RxBool refreshData = true.obs;
  RxBool team = false.obs; // checks if is team calendar

  // data for calendar
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

  // Fetch all user specific tasks for taskview.
  Future<List<TaskModel>> getAllUserTasks() async {
    try {
      final tasks = await taskRepository.fetchUserTaskList();
      return tasks;
    } catch (e) {
      RLoaders.errorSnackBar(title: 'Task not found', message: e.toString());
      return [];
    }
  }

  // Fetch user specific tasks with dueDate later than inputted datetime for taskview.
  Future<List<TaskModel>> getUserTasks(DateTime dateTime) async {
    try {
      final tasks = await taskRepository.fetchUserTaskList();
      return tasks.where((task) {
        return task.dueDate.compareTo(dateTime) > -1;
      }).toList();
    } catch (e) {
      RLoaders.errorSnackBar(title: 'Task not found', message: e.toString());
      return [];
    }
  }

  // Fetch all user specific tasks for taskview.
  Future<List<TaskModel>> getAllTeamTasks(String teamId) async {
    try {
      final tasks = await taskRepository.fetchTeamTaskList(teamId: teamId);
      return tasks;
    } catch (e) {
      RLoaders.errorSnackBar(title: 'Task not found', message: e.toString());
      return [];
    }
  }

  // Fetch team specific tasks with dueDate later than inputted datetime for taskview.
  Future<List<TaskModel>> getTeamTasks(DateTime dateTime) async {
    try {
      final tasks = await taskRepository.fetchTeamTaskList();
      return tasks.where((task) {
        return task.dueDate.compareTo(dateTime) > -1;
      }).toList();
    } catch (e) {
      RLoaders.errorSnackBar(title: 'Task not found', message: e.toString());
      return [];
    }
  }

  // below are methods for calendar to display info
  String showDate() {
    return '${selectedDate.day} ${listOfMonths[selectedDate.month - 1]}, ${selectedDate.year}';
  }

  String showMonth(int index) {
    return listOfMonths[DateTime.now().add(Duration(days: index)).month - 1]
        .toString();
  }

  String showDay(int index) {
    return DateTime.now().add(Duration(days: index)).day.toString();
  }

  String showWeekDay(int index) {
    return listOfDays[DateTime.now().add(Duration(days: index)).weekday - 1]
        .toString();
  }
}
