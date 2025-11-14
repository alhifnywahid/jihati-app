import 'package:get/get.dart';

import '../controllers/aboutme_controller.dart';

class AboutmeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AboutmeController>(
      () => AboutmeController(),
    );
  }
}
