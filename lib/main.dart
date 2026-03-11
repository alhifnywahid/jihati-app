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

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    return Obx(() {
      final mode = themeController.themeMode.value;
      final lightTheme = FThemes.green.light;
      final darkTheme = FThemes.green.dark;

      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Jihati',
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
        themeMode: mode,
        theme: lightTheme.toApproximateMaterialTheme(),
        darkTheme: darkTheme.toApproximateMaterialTheme(),
        builder: (context, child) {
          // Determine active FThemeData based on resolved brightness
          final brightness = MediaQuery.platformBrightnessOf(context);
          final isDark = mode == ThemeMode.dark ||
              (mode == ThemeMode.system && brightness == Brightness.dark);
          return FTheme(
            data: isDark ? darkTheme : lightTheme,
            child: FToaster(
              child: FTooltipGroup(child: child!),
            ),
          );
        },
      );
    });
  }
}
