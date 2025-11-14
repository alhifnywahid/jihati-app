import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jihati/app/modules/setting/views/setting_section.widget.dart';

import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(title: const Text('Pengaturan')),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.sections.length,
          itemBuilder: (context, sectionIndex) {
            final section = controller.sections[sectionIndex];
            return SettingSectionWidget(section: section);
          },
        ),
      ),
    );
  }
}
