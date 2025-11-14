import 'package:get/get.dart';
import 'package:jihati/app/controllers/reading_preference_controller.dart';

import '../controllers/quran_detail_controller.dart';

class QuranDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuranDetailController>(() {
      return QuranDetailController();
    });
    Get.lazyPut<ReadingPreferenceController>(() {
      return ReadingPreferenceController();
    });
  }
}
