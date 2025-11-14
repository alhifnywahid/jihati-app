import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';
import 'package:jihati/app/controllers/reading_preference_controller.dart';
import 'package:jihati/app/controllers/theme/theme_controller.dart';
import 'package:jihati/app/models/surah.model.dart';
import 'package:jihati/app/services/quran_storage_service.dart';
import 'package:jihati/app/widgets/quran_arabic_verses.widget.dart';
import 'package:jihati/app/widgets/reading_preference_dialog.widget.dart';

import '../controllers/quran_detail_controller.dart';

class QuranDetailView extends StatefulWidget {
  const QuranDetailView({super.key});

  @override
  State<QuranDetailView> createState() => _QuranDetailViewState();
}

class _QuranDetailViewState extends State<QuranDetailView> {
  late List<SurahModel> surahList;
  late int currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    surahList = (args['listSurah'] as List).cast<SurahModel>();
    currentIndex = args['currentIndex'] as int? ?? 0;
    _pageController = PageController(initialPage: currentIndex);
  }

  void _onPageChanged(int index) {
    if (index < 0 || index >= surahList.length) return;
    setState(() {
      currentIndex = index;
      final QuranDetailController controller = Get.find();
      controller.surah = surahList[index];
      controller.isLoading.value = true;
      controller.verses.clear();
      controller.onInit();
    });
    // Tambahkan ke history setiap kali swipe ke surah baru
    final storage = QuranStorageService();
    final idStr = surahList[index].id.toString();
    final history = storage.getHistory();
    history.remove(idStr);
    history.insert(0, idStr);
    if (history.length > 50) {
      history.removeRange(50, history.length);
    }
    storage.saveHistory(history);
  }

  @override
  Widget build(BuildContext context) {
    final prefs = Get.find<ReadingPreferenceController>();
    final ThemeController themeC = Get.find();
    final QuranDetailController controller = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: Text(surahList[currentIndex].name),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(themeC.currentThemeIcon, color: Colors.white),
              tooltip: 'Tema',
              onPressed: () => themeC.changeTheme(),
            ),
          ),
          IconButton(
            icon: const Icon(LucideIcons.letter_text),
            tooltip: 'Preferensi Membaca',
            onPressed: () => ReadingPreferenceDialog.show(context),
          ),
          Obx(
            () => IconButton(
              icon: Icon(
                controller.isBookmarked.value
                    ? LucideIcons.bookmark_check
                    : LucideIcons.bookmark_plus,
              ),
              tooltip: controller.isBookmarked.value
                  ? 'Hapus dari Tersimpan'
                  : 'Simpan',
              onPressed: controller.toggleBookmark,
            ),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: surahList.length,
        onPageChanged: (index) {
          if (index < 0 || index >= surahList.length) return;
          _onPageChanged(index);
        },
        itemBuilder: (context, index) {
          final surah = surahList[index];
          return Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.verses.isEmpty) {
              return const Center(
                child: Text(
                  'Tidak ada ayat yang tersedia',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 0.5, color: Colors.grey),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          surah.type,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 2,
                        ),
                        child: Text(
                          "${String.fromCharCode(0xE800 + surah.id)}${String.fromCharCode(0xE800)}",
                          style: const TextStyle(
                            fontFamily: 'SurahQuranNU',
                            fontSize: 28,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "${surah.verseCount} Ayat",
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Obx(() {
                    final double fontSize = prefs.arabicFontSize.value;
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(12),
                      child: QuranArabicVersesWidget(
                        verses: controller.verses.map((v) => v.text).toList(),
                        fontSize: fontSize,
                      ),
                    );
                  }),
                ),
              ],
            );
          });
        },
      ),
    );
  }
}
