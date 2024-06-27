import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskAllocationController extends GetxController {
  // Variables
  final date = TextEditingController();   // date editing controller
  DateTime? _picked;                      // for datetime

  @override
  void onInit() {
    super.onInit();
  }

  // Date Picker
  Future<void> selectDate(BuildContext context) async {
    _picked = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(),
      firstDate: DateTime(2024), 
      lastDate: DateTime(2025)
    );

    if (_picked != null){
      date.value = TextEditingValue(text: _picked.toString().split(" ")[0]);
    }
  }

  // get a date if possible
  DateTime pickedDate() {
    if (_picked == null) {
      // else return current date (replace with validation check in manual_allocation.dart in future)
      return DateTime.now();
    }
    return _picked!;
  }
}
