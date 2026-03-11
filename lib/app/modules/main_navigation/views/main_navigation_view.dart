import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';

import '../controllers/main_navigation_controller.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final index = controller.selectedIndex.value;
      final menu = controller.menu;

      return FScaffold(
        child: controller.getMenu()['builder'](),
        footer: FBottomNavigationBar(
          index: index,
          onChange: controller.setSelectedIndex,
          children: menu
              .map(
                (item) => FBottomNavigationBarItem(
                  icon: item['icon'] as Widget,
                  label: Text(item['title'] as String),
                ),
              )
              .toList(),
        ),
      );
    });
  }
}
