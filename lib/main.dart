import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jihati/app/controllers/theme/material_theme.dart';
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
    final materialTheme = MaterialTheme(Typography.material2021().black);
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Jihati",
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        themeMode: themeController.themeMode.value,
        theme: materialTheme.light(),
        darkTheme: materialTheme.dark(),
      ),
    );
  }
}
