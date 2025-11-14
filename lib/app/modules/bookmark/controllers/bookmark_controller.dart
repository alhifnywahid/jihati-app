import 'package:get/get.dart';
import 'package:jihati/app/modules/jihati-detail/services/jihati_storage_service.dart';

class BookmarkController extends GetxController {
  final storage = JihatiStorageService();
  final bookmarks = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadBookmarks();
  }

  void loadBookmarks() {
    final data = storage.getBookmarks();
    bookmarks.assignAll(data);
  }

  bool isBookmarked(int id) => bookmarks.contains(id.toString());

  void toggleBookmark(int id, String title) {
    final key = id.toString();
    final exists = bookmarks.contains(key);

    if (exists) {
      bookmarks.remove(key);
      Get.snackbar("Tersimpan", "$title berhasil dihapus.");
    } else {
      bookmarks.add(key);
      Get.snackbar("Tersimpan", "$title berhasil disimpan.");
    }

    storage.saveBookmarks(bookmarks);
  }
}
