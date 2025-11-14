import 'package:get/get.dart';
import 'package:jihati/app/data/local/history_local_data_source.dart';
import 'package:jihati/app/models/jihati_item_model.dart';

class HistoryController extends GetxController {
  final HistoryLocalDataSource localDataSource;

  final recentHistory = <JihatiItem>[].obs;

  HistoryController(this.localDataSource);

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  void loadHistory() {
    final list = localDataSource.loadHistory();
    recentHistory.assignAll(list);
  }

  void addToHistory(JihatiItem item) {
    final list = localDataSource.addToHistory(item);
    recentHistory.assignAll(list);
  }

  void clearHistory() {
    localDataSource.clear();
    recentHistory.clear();
  }
}
