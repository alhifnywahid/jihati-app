import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jihati/app/services/jihati_storage_service.dart';

class BookmarkController extends GetxController {
  final storage = JihatiStorageService();
  final bookmarks = <String>[].obs;
  // Incremented whenever Quran bookmarks change so dependents can react
  final quranBookmarkVersion = 0.obs;

  void incrementQuranVersion() => quranBookmarkVersion.value++;

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
      _showSnackbar('$title dihapus dari Tersimpan.');
    } else {
      bookmarks.add(key);
      _showSnackbar('$title ditambahkan ke Tersimpan.');
    }

    storage.saveBookmarks(bookmarks);
  }

  void _showSnackbar(String message) {
    final ctx = Get.context;
    if (ctx == null) return;
    ScaffoldMessenger.of(ctx)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }
}
