import 'package:flutter/material.dart';
import 'package:remindere/utils/constants/sizes.dart';

class TeamCard extends StatelessWidget {
  const TeamCard({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      InkWell(
        splashColor: Colors.grey,
        onTap: () {},
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 200,
          width: 200,
          child: Text(name, style: Theme.of(context).textTheme.headlineSmall),
        ),
      ),
      const SizedBox(width: RSizes.spaceBtwItems),
    ]);
  }
}
