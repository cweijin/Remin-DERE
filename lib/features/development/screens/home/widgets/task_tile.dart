import 'package:flutter/material.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/device/device_utility.dart';

class RTaskTile extends StatelessWidget {
  final String? child;

  const RTaskTile({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final width = RDeviceUtils.getScreenWidth(context);

    return Column(children: [
      InkWell(
        splashColor: Colors.grey,
        onTap: () {},
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 100,
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(child ?? ''),
            ],
          ),
        ),
      ),
      const SizedBox(height: RSizes.spaceBtwItems),
    ]);
  }
}
