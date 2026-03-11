import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';

import '../controllers/accountme_controller.dart';

class AccountmeView extends GetView<AccountmeController> {
  const AccountmeView({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: const Text('Sosial Media'),
        prefixes: [FHeaderAction.back(onPress: () => Get.back())],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ikuti Kami',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Dapatkan informasi terbaru dan konten menarik dari kami',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            FTileGroup(
              children: List.generate(controller.socialMediaData.length, (index) {
                final platform = controller.socialMediaData[index];
                final iconColor = controller.getPlatformColor(platform.platform);

                return FTile(
                  prefix: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: iconColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      controller.getPlatformIcon(platform.platform),
                      color: iconColor,
                    ),
                  ),
                  title: Text(
                    platform.platform,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(platform.username),
                  suffix: const Icon(FIcons.chevronRight),
                  onPress: () => controller.launchUrlWithFeedback(
                    platform.url,
                    context,
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
