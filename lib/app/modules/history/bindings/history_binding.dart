import 'package:get/get.dart';
import 'package:jihati/app/data/local/history_local_data_source.dart';
import '../controllers/history_controller.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryLocalDataSource>(() => HistoryLocalDataSource());
    Get.lazyPut<HistoryController>(
      () => HistoryController(Get.find<HistoryLocalDataSource>()),
    );
  }
}
