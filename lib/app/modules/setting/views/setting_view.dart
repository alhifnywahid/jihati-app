import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:jihati/app/controllers/theme/theme_controller.dart';
import 'package:jihati/app/modules/setting/views/setting_section.widget.dart';

import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeC = Get.find();

    return FScaffold(
      header: FHeader(
        title: const Text('Pengaturan'),
        suffixes: [
          Obx(
            () => FHeaderAction(
              icon: Icon(themeC.currentThemeIcon),
              onPress: () => themeC.cycleTheme(),
            ),
          ),
        ],
      ),
      child: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
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
