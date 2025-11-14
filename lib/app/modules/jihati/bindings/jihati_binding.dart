import 'package:get/get.dart';
import 'package:jihati/app/data/local/jihati_local_data_source.dart';

import '../controllers/jihati_controller.dart';

class JihatiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JihatiLocalDataSource>(() => JihatiLocalDataSource());

    Get.lazyPut<JihatiController>(
      () => JihatiController(Get.find<JihatiLocalDataSource>()),
    );
  }
}
