import 'package:get/get.dart';
import '../controllers/theme/theme_controller.dart';
import '../data/local/theme_local_data_source.dart';
import '../services/local_storage_service.dart';

class ThemeBinding extends Bindings {
  @override
  void dependencies() {
    final storageService = LocalStorageService();
    final themeDataSource = ThemeLocalDataSource(storageService);

    Get.put(themeDataSource);
    Get.put(ThemeController(localDataSource: themeDataSource));
  }
}
