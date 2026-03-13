import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jihati/app/controllers/theme/theme_controller.dart';
import 'package:jihati/app/data/local/theme_local_data_source.dart';
import 'package:jihati/app/services/local_storage_service.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);
  await GetStorage.init();

  final storageService = LocalStorageService();
  final themeDataSource = ThemeLocalDataSource(storageService);

  Get.put(themeDataSource);
  Get.put(ThemeController(localDataSource: themeDataSource));

  runApp(const MainApp());
}

/// Softer charcoal dark — easy on the eyes, not pitch black.
const _charcoalBg     = Color(0xFF181A1F);
const _charcoalSurface = Color(0xFF1E2229);
const _charcoalCard   = Color(0xFF22262E);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    // Build ForUI themes once — stable references outside Obx
    final lightForui = FThemes.green.light;
    final baseDark   = FThemes.green.dark;
    final darkForui  = baseDark.copyWith(
      colors: baseDark.colors.copyWith(
        foreground: const Color(0xFFC8CDD6),      // soft off-white text
        mutedForeground: const Color(0xFF8B9099), // subtitle/hint
        border: const Color(0xFF2C3040),          // dividers — dimmer than text
        background: _charcoalBg,
        secondary: _charcoalSurface,
        muted: _charcoalCard,
      ),
    );

    // Material themes both derived from ForUI → same TextStyle.inherit values
    final lightMaterial = lightForui.toApproximateMaterialTheme();
    final darkMaterial  = darkForui.toApproximateMaterialTheme().copyWith(
      scaffoldBackgroundColor: _charcoalBg,
      canvasColor: _charcoalBg,
      cardColor: _charcoalCard,
    );

    return Obx(() {
      final mode = themeController.themeMode.value;
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Jihati',
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
        themeMode: mode,
        theme: lightMaterial,
        darkTheme: darkMaterial,
        builder: (context, child) {
          final isDark = mode == ThemeMode.dark;
          return FTheme(
            data: isDark ? darkForui : lightForui,
            child: FToaster(child: child!),
          );
        },
      );
    });
  }
}
