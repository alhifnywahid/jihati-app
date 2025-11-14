import 'package:get/get.dart';
import 'package:jihati/app/modules/jihati/controllers/jihati_controller.dart';

import '../controllers/bookmark_controller.dart';

class BookmarkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookmarkController>(() => BookmarkController());
    Get.lazyPut<JihatiController>(() => JihatiController(Get.find()));
  }
}
