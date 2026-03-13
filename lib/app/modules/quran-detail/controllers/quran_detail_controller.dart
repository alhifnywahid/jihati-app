import 'dart:convert';
import 'package:flutter/material.dart';
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

  void loadSurah(SurahModel newSurah) {
    surah = newSurah;
    // Only show loading + clear if not yet cached for this surah
    if (!_surahVersesCache.containsKey(newSurah.id)) {
      isLoading.value = true;
      verses.clear();
    }
    _loadVerses();
    _checkBookmark();
    _addToHistory();
  }

  /// All ayat loaded once from asset.
  static List<VerseModel>? _allVersesCache;
  /// Per-surah filtered verses cache — no repeated .where() on each swipe.
  static final Map<int, List<VerseModel>> _surahVersesCache = {};

  Future<void> _loadVerses() async {
    try {
      // Check per-surah cache first — instant if already filtered
      if (_surahVersesCache.containsKey(surah.id)) {
        verses.assignAll(_surahVersesCache[surah.id]!);
        isLoading.value = false;
        return;
      }
      // Load global cache (JSON) only once
      if (_allVersesCache == null) {
        final response =
            await rootBundle.loadString('assets/data/alquran/ayat.json');
        final data = json.decode(response) as List;
        _allVersesCache =
            data.map((e) => VerseModel.fromJson(e)).toList();
      }
      final filtered =
          _allVersesCache!.where((v) => v.surahId == surah.id).toList();
      _surahVersesCache[surah.id] = filtered; // cache for next time
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
      _showSnackbar('${surah.name} dihapus dari Tersimpan');
    } else {
      bookmarks.add(idStr);
      _showSnackbar('${surah.name} ditambahkan ke Tersimpan');
    }

    isBookmarked.toggle();
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
