import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';
import 'package:jihati/app/widgets/curved_navbar.widget.dart';

import '../controllers/main_navigation_controller.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  const MainNavigationView({super.key});

  static const _navItems = [
    CurvedNavItem(icon: LucideIcons.book_open, label: 'Jihati'),
    CurvedNavItem(icon: LucideIcons.book_open_text, label: 'Al-Quran'),
    CurvedNavItem(icon: LucideIcons.settings, label: 'Pengaturan'),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final index = controller.selectedIndex.value;

      return Scaffold(
        body: controller.getMenu()['builder'](),
        bottomNavigationBar: CurvedNavBar(
          selectedIndex: index,
          onTap: controller.setSelectedIndex,
          items: _navItems,
        ),
      );
    });
  }
}
