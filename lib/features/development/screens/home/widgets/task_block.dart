import 'package:flutter/material.dart';
import 'package:remindere/utils/constants/sizes.dart';

class RTaskBlock extends StatelessWidget {
  final String? child;

  const RTaskBlock({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      InkWell(
        splashColor: Colors.grey,
        onTap: () {},
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              height: 200,
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text(child ?? '')],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(width: RSizes.spaceBtwItems),
    ]);
  }
}
