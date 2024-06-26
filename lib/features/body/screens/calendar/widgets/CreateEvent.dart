import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:remindere/features/body/controllers/calendar/event_controller.dart';
import 'package:remindere/features/body/screens/calendar/calendar.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/constants/text_strings.dart';


class RCreateEvent extends StatelessWidget {
    const RCreateEvent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EventController()); // must implement in Firebase first
    // TODO: implement build
    return Form(
      key: controller.key,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: RSizes.spaceBtwSections),
        child: Column(
          children: [
            // Person(s) involved not implemented yet, drop down menu

            // Event Name
            TextFormField(
              controller: controller.email,
              validator: (value) => RValidator.validateEmail(value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: RTexts.email,
              ),
            ),

            const SizedBox(height: RSizes.spaceBtwInputFields),


            // Event Start Date and Time

            // Event End Date and Time

            // Event Confirmation Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                // implement adding details to firebase
                onPressed: () => controller.emailAndPasswordSignIn(),
                child: const Text(RTexts.addEvent),
              ),
            ),

          ],
          ),
        ),
    );
  }
}