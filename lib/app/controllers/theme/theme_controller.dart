import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:jihati/app/data/local/theme_local_data_source.dart';

class ThemeController extends GetxController {
  final ThemeLocalDataSource localDataSource;

  ThemeController({required this.localDataSource});

  final themeMode = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    themeMode.value = localDataSource.getThemeMode();
  }

  /// Cycles through: system → light → dark → system
  void cycleTheme() {
    themeMode.value = switch (themeMode.value) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
    localDataSource.saveThemeMode(themeMode.value);
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

  IconData get currentThemeIcon => switch (themeMode.value) {
    ThemeMode.system => LucideIcons.monitor,
    ThemeMode.light => LucideIcons.sun,
    ThemeMode.dark => LucideIcons.moon,
  };

  String get currentThemeLabel => switch (themeMode.value) {
    ThemeMode.system => 'Sistem',
    ThemeMode.light => 'Terang',
    ThemeMode.dark => 'Gelap',
  };

  FThemeData forUiTheme(BuildContext context) {
    final dark = isDarkEffective(context);
    return dark ? FThemes.green.dark : FThemes.green.light;
  }
}
