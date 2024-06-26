import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskAllocationController extends GetxController {
  // Variables
  final date = TextEditingController();   // date editing controller

  @override
  void onInit() {
    super.onInit();
  }

  // Date Picker
  Future<void> selectDate(BuildContext context) async {
    DateTime? _picked = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(),
      firstDate: DateTime(2024), 
      lastDate: DateTime(2025)
    );

    if (_picked != null){
      date.value = TextEditingValue(text: _picked.toString().split(" ")[0]);
    }
  }
}
