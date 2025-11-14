import 'package:get/get.dart';
import 'package:jihati/app/data/local/jihati_local_data_source.dart';
import 'package:jihati/app/models/jihati_item_model.dart';

class JihatiController extends GetxController {
  final contents = <JihatiItem>[].obs;
  final filteredContents = <JihatiItem>[].obs;
  final searchQuery = ''.obs;

  final JihatiLocalDataSource dataSource;

  JihatiController(this.dataSource);

  @override
  void onInit() {
    super.onInit();
    loadContents();
  }

  Future<void> loadContents() async {
    final items = await dataSource.loadDaftarIsi();
    contents.assignAll(items);
    filteredContents.assignAll(items);
  }

  void filterContents(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredContents.assignAll(contents);
    } else {
      final lower = query.toLowerCase();
      filteredContents.assignAll(
        contents.where(
          (item) =>
              item.titleLatin.toLowerCase().contains(lower) ||
              item.id.toString().contains(lower),
        ),
      );
    }
  }

  void resetSearch() {
    searchQuery.value = '';
    filteredContents.assignAll(contents);
  }

  @override
  void onClose() {
    resetSearch();
    super.onClose();
  }
}
