import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:remindere/common/widgets/appbar/appbar.dart';

class RHomeAppBar extends StatelessWidget {
  const RHomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome back to Remin-DERE, ',
              style: Theme.of(context).textTheme.bodySmall),
          Text('Kaiya Morrow', style: Theme.of(context).textTheme.headlineSmall)
        ],
      ),
      actions: [
        Stack(
          children: [
            IconButton(
                icon: const Icon(Iconsax.notification), onPressed: () {}),
            Positioned(
              right: 0,
              child: Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
