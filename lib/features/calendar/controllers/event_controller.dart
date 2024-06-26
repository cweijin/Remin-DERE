// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:remindere/data/repositories/calendar_event_repository/calendar_event_repository.dart';
// import 'package:remindere/utils/helpers/network_manager.dart';
// import 'package:remindere/utils/popups/full_screen_loader.dart';
// import 'package:remindere/utils/popups/loaders.dart';

// class EventController extends GetxController {
//   // to add events for calendar

//   // Variables
//   final localStorage = GetStorage();
//   final eventName = TextEditingController();
//   final eventLocation = TextEditingController();
//   final eventTime = DatePickerDialog(firstDate: DateTime.now(), lastDate: DateTime.utc(2034, 12, 31, 23, 59, 59, 99, 99));
//   GlobalKey<FormState> eventFormKey = GlobalKey<FormState>();

//   @override
//   void onInit() {
//     // add behaviour here
//     super.onInit();
//   }

//   // Create Events offline

//   // Save Events to Database
//   Future<void> saveEvent() async {
//     try {
//       // Start Loading
//       RFullScreenLoader.openLoadingDialog('Saving Event...');

//       // Check Internet Connectivity
//       final bool hasConnection = await NetworkManager.instance.isConnected();
//       if (!hasConnection) {
//         RFullScreenLoader.stopLoading();
//         return;
//       }

//       // Form Validation
//       // not implemented

//       await CalendarEventRepository.instance
//           .addEventToCalendar(email.text.trim(), password.text.trim());

//       // Remove Loader
//       RFullScreenLoader.stopLoading();

//       // Redirect
//       CalendarEventRepository.instance.screenRedirect();
//     } catch (e) {
//       // Remove Loader
//       RFullScreenLoader.stopLoading();

//       RLoaders.errorSnackBar(
//           title: 'Some error occured :(', message: e.toString());
//     }
//   }

// }