import 'package:get/get.dart';
import 'package:jihati/app/data/local/history_local_data_source.dart';
import 'package:jihati/app/data/local/jihati_local_data_source.dart';
import 'package:jihati/app/modules/history/controllers/history_controller.dart';
import 'package:jihati/app/modules/jihati/controllers/jihati_controller.dart';
import 'package:jihati/app/modules/quran/controllers/quran_controller.dart';
import 'package:jihati/app/modules/setting/controllers/setting_controller.dart';

import '../controllers/main_navigation_controller.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavigationController>(() => MainNavigationController());
    Get.lazyPut<SettingController>(() => SettingController());
    Get.put(QuranController(), permanent: true);

    Get.lazyPut(() => JihatiLocalDataSource());
    Get.lazyPut(() => JihatiController(Get.find<JihatiLocalDataSource>()));

    Get.put(HistoryLocalDataSource(), permanent: true);
    Get.put(
      HistoryController(Get.find<HistoryLocalDataSource>()),
      permanent: true,
    );
  }
}
