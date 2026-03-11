import 'package:flutter/material.dart';
import 'package:jihati/app/services/storage_service.dart';

class ThemeLocalDataSource {
  final StorageService storage;

  ThemeLocalDataSource(this.storage);

  static const _themeKey = 'theme';

  void saveThemeMode(ThemeMode mode) {
    final value = switch (mode) {
      ThemeMode.dark => 'dark',
      ThemeMode.light => 'light',
      ThemeMode.system => 'system',
    };
    storage.write(_themeKey, value);
  }

  /// Returns null if never set (means use system default).
  ThemeMode getThemeMode() {
    final value = storage.read<String>(_themeKey);
    if (value == 'dark') return ThemeMode.dark;
    if (value == 'light') return ThemeMode.light;
    return ThemeMode.system;
  }
}

