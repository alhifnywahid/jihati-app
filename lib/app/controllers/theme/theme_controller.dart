import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:jihati/app/data/local/theme_local_data_source.dart';

class ThemeController extends GetxController {
  final ThemeLocalDataSource localDataSource;

  ThemeController({required this.localDataSource});

  final themeMode = ThemeMode.light.obs;

  @override
  void onInit() {
    super.onInit();
    themeMode.value = localDataSource.getThemeMode();
  }

  /// Cycles between light and dark only
  void cycleTheme() {
    themeMode.value = themeMode.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    localDataSource.saveThemeMode(themeMode.value);
  }

  /// Directly set a specific theme
  void setTheme(ThemeMode mode) {
    themeMode.value = mode;
    localDataSource.saveThemeMode(mode);
  }

  /// Legacy compat — toggles between light and dark (skips system)
  void changeTheme() => cycleTheme();

  bool isDark() => themeMode.value == ThemeMode.dark;
  bool isDarkEffective(BuildContext context) {
    if (themeMode.value == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return isDark();
  }

  ThemeMode get currentTheme => themeMode.value;

  IconData get currentThemeIcon =>
      themeMode.value == ThemeMode.dark ? LucideIcons.moon : LucideIcons.sun;

  String get currentThemeLabel =>
      themeMode.value == ThemeMode.dark ? 'Gelap' : 'Terang';

  FThemeData forUiTheme(BuildContext context) {
    final dark = themeMode.value == ThemeMode.dark;
    return dark ? FThemes.green.dark : FThemes.green.light;
  }
}
