import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jihati/app/models/surah.model.dart';
import 'package:jihati/utils/logger.util.dart';

class QuranController extends GetxController {
  final allSurah = <SurahModel>[].obs;
  final filteredSurah = <SurahModel>[].obs;
  final isLoading = true.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadSurahData();
  }

  Future<void> loadSurahData() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/alquran/daftar_surah.json',
      );
      final List<dynamic> data = json.decode(response);
      final List<SurahModel> parsedSurah = data
          .map((json) => SurahModel.fromJson(json))
          .toList();

      allSurah.assignAll(parsedSurah);
      filteredSurah.assignAll(parsedSurah);
    } catch (e) {
      logger.e('Error loading surah data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void filterSurah(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredSurah.assignAll(allSurah);
    } else {
      final lower = query.toLowerCase();
      filteredSurah.assignAll(
        allSurah.where((surah) {
          return surah.name.toLowerCase().contains(lower) ||
              surah.translate.toLowerCase().contains(lower) ||
              surah.id.toString().contains(lower);
        }),
      );
    }
  }

  void resetSearch() {
    searchQuery.value = '';
    filteredSurah.assignAll(allSurah);
  }

  @override
  void onClose() {
    resetSearch();
    super.onClose();
  }
}
