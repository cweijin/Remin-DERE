import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remindere/features/task_allocation/screens/manual_allocation/manual_allocation.dart';

void main() {
  testWidgets("Manual allocation test", (WidgetTester tester) async {
    // Find all widgets needed
    final datePicker = find.byElementType(TextField);
    final createTask = find.byElementType(ElevatedButton);

    // execute the actual test
    await tester.pumpWidget(const MaterialApp(home: ManualAllocation()));
    await tester.tap(datePicker);
    await tester.tap(createTask);
    tester.pump;

    // check outputs
    expect(find.text("Make Widget Testing video"), findsAtLeastNWidgets(2));
  });
}
