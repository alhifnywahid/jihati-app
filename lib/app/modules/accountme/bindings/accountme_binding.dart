import 'package:get/get.dart';

import '../controllers/accountme_controller.dart';

class AccountmeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountmeController>(
      () => AccountmeController(),
    );
  }
}
