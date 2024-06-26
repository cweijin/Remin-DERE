import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/device/device_utility.dart';

class RAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final IconData? leadingIcon;
  final VoidCallback? leadingOnPressed;
  final bool showBackArrow;

  const RAppBar({
    super.key,
    this.title,
    this.actions,
    this.leadingIcon,
    this.leadingOnPressed,
    this.showBackArrow = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(RDeviceUtils.getAppBarHeight());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: RSizes.defaultSpace),
      child: AppBar(
        automaticallyImplyLeading: false,
        leading: showBackArrow
            ? IconButton(onPressed: () {}, icon: const Icon(Iconsax.arrow_left))
            : leadingIcon == null
                ? null
                : IconButton(
                    onPressed: leadingOnPressed, icon: Icon(leadingIcon)),
        title: title,
        actions: actions,
      ),
    );
  }
}
