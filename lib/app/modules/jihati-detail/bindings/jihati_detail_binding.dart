import 'package:get/get.dart';
import 'package:jihati/app/controllers/reading_preference_controller.dart';
import 'package:jihati/app/modules/bookmark/controllers/bookmark_controller.dart';
import 'package:jihati/app/modules/jihati-detail/controllers/jihati_detail_controller.dart';

class JihatiDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JihatiDetailController>(() => JihatiDetailController());
    Get.lazyPut<ReadingPreferenceController>(
      () => ReadingPreferenceController(),
    );

    Get.lazyPut<BookmarkController>(() {
      return BookmarkController();
    });
  }
}
