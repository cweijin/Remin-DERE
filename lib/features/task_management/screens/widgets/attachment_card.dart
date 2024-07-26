import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:remindere/features/task_management/controllers/task_management_controller.dart';
import 'package:remindere/utils/constants/colors.dart';
import 'package:remindere/utils/constants/image_strings.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/utils/helpers/helper_functions.dart';

class RAttachmentCard extends StatelessWidget {
  const RAttachmentCard({super.key, required this.fileUrl, this.fileName});

  final String fileUrl;
  final String? fileName;

  @override
  Widget build(BuildContext context) {
    final controller = TaskManagementController.instance;
    return Row(
      children: [
        InkWell(
          splashColor: RColors.grey,
          radius: 50,
          borderRadius: BorderRadius.circular(10),
          onTap: () {},
          child: Card(
            clipBehavior: Clip.antiAlias,
            elevation: 6,
            color: const Color.fromARGB(255, 243, 249, 241),
            child: Column(
              children: [
                Container(
                  color: const Color.fromARGB(255, 42, 55, 64),
                  height: 200,
                  width: 250,
                  foregroundDecoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(RImages.background1),
                        fit: BoxFit.cover),
                  ),
                ),
                SizedBox(
                  width: 250,
                  child: Padding(
                    padding: const EdgeInsets.all(RSizes.md),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            fileName ??
                                RHelperFunctions.getAttachmentName(fileUrl),
                            style: Theme.of(context).textTheme.headlineSmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        fileName != null
                            ? const SizedBox()
                            : IconButton(
                                iconSize: 25,
                                icon: const Icon(Icons.download),
                                onPressed: () {
                                  controller.downloadAttachment(fileUrl);
                                },
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: RSizes.spaceBtwItems),
      ],
    );
  }
}
