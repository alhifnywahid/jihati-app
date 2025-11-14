import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jihati/app/models/surah.model.dart';
import 'package:jihati/app/models/verse.model.dart';
import 'package:jihati/app/services/quran_storage_service.dart';
import 'package:jihati/utils/logger.util.dart'; 

class QuranDetailController extends GetxController {
  final storage = QuranStorageService();

  final verses = <VerseModel>[].obs;
  final isLoading = true.obs;
  final isBookmarked = false.obs;

  late SurahModel surah;

  @override
  void onInit() {
    super.onInit();
    surah = Get.arguments['surah'];
    _loadVerses();
    _checkBookmark();
    _addToHistory();
  }

  Future<void> _loadVerses() async {
    try {
      final response = await rootBundle.loadString('assets/data/alquran/ayat.json');
      final data = json.decode(response) as List;
      final allVerses = data.map((e) => VerseModel.fromJson(e)).toList();
      final filtered = allVerses.where((v) => v.surahId == surah.id).toList();
      verses.assignAll(filtered);
    } catch (e) {
      logger.e('Error loading verses: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _checkBookmark() {
    final bookmarks = storage.getBookmarks();
    isBookmarked.value = bookmarks.contains(surah.id.toString());
  }

  void toggleBookmark() {
    final bookmarks = storage.getBookmarks();
    final idStr = surah.id.toString();

    if (isBookmarked.value) {
      bookmarks.remove(idStr);
      Get.snackbar('Tersimpan', '${surah.name} dihapus dari bookmark');
    } else {
      bookmarks.add(idStr);
      Get.snackbar('Tersimpan', '${surah.name} disimpan ke bookmark');
    }

    isBookmarked.toggle();
    storage.saveBookmarks(bookmarks);
  }

  void _addToHistory() {
    final history = storage.getHistory();
    final idStr = surah.id.toString();

    history.remove(idStr);
    history.insert(0, idStr);
    if (history.length > 50) {
      history.removeRange(50, history.length);
    }

    storage.saveHistory(history);
  }
}
