import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  var themeMode = ThemeMode.light.obs;

  void toggleTheme() {
    themeMode.value = isDarkMode ? ThemeMode.light : ThemeMode.dark;
  }

  bool get isDarkMode => themeMode.value == ThemeMode.dark;

  void setTheme(ThemeMode mode) {
    themeMode.value = mode;
  }
}
