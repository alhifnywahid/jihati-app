import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jihati/app/controllers/theme/theme_controller.dart';
import 'package:jihati/app/modules/main_navigation/controllers/main_navigation_controller.dart';

class ListNavigation extends GetView<MainNavigationController> {
  const ListNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          currentIndex: controller.selectedIndex.value,
          selectedItemColor: Color(0xFF009788),
          unselectedItemColor: themeController.isDark()
              ? Color(0xFFD0CECE)
              : Color(0xFF4F4F4F),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 10.5,
            color: Color(0xFF009788),
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 10.5,
            color: themeController.isDark()
                ? Color(0xFFD0CECE)
                : Color(0xFF4F4F4F),
          ),
          onTap: (index) => controller.setSelectedIndex(index),
          items: controller.menu
              .map(
                (item) => BottomNavigationBarItem( 
                  label: item["title"] as String,
                  icon: item["icon"] as Widget,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
