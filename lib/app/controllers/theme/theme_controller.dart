import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';
import 'package:jihati/app/data/local/theme_local_data_source.dart';

class ThemeController extends GetxController {
  final ThemeLocalDataSource localDataSource;

  ThemeController({required this.localDataSource});

  final themeMode = ThemeMode.light.obs;

  @override
  void onInit() {
    super.onInit();
    final saved = localDataSource.getThemeMode();
    if (saved != null) {
      themeMode.value = saved;
    }
  }

  void changeTheme() {
    themeMode.value = isDark() ? ThemeMode.light : ThemeMode.dark;

    localDataSource.saveThemeMode(themeMode.value);
  }

  void setTheme(bool isDark) {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
    localDataSource.saveThemeMode(themeMode.value);
  }

  bool isDark() => themeMode.value == ThemeMode.dark;

  ThemeMode get currentTheme => themeMode.value;

  IconData get currentThemeIcon =>
      isDark() ? LucideIcons.moon : LucideIcons.sun;
}
