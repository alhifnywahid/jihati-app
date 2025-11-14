import 'package:flutter/material.dart';
import 'package:jihati/app/services/storage_service.dart';

class ThemeLocalDataSource {
  final StorageService storage;

  ThemeLocalDataSource(this.storage);

  static const _themeKey = 'theme';

  void saveThemeMode(ThemeMode mode) {
    final value = mode == ThemeMode.dark ? 'dark' : 'light';
    storage.write(_themeKey, value);
  }

  ThemeMode? getThemeMode() {
    final value = storage.read<String>(_themeKey);
    if (value == 'dark') return ThemeMode.dark;
    if (value == 'light') return ThemeMode.light;
    return null;
  }
}
