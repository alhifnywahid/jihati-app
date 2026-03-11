import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
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
    final storage = QuranStorageService();
    final idStr = surahList[index].id.toString();
    final history = storage.getHistory();
    history.remove(idStr);
    history.insert(0, idStr);
    if (history.length > 50) history.removeRange(50, history.length);
    storage.saveHistory(history);
  }

  @override
  Widget build(BuildContext context) {
    final prefs = Get.find<ReadingPreferenceController>();
    final ThemeController themeC = Get.find();
    final QuranDetailController controller = Get.find();

    return FScaffold(
      header: FHeader.nested(
        title: Text(surahList[currentIndex].name),
        prefixes: [FHeaderAction.back(onPress: () => Get.back())],
        suffixes: [
          Obx(
            () => FHeaderAction(
              icon: Icon(themeC.currentThemeIcon),
              onPress: () => themeC.cycleTheme(),
            ),
          ),
          FHeaderAction(
            icon: const Icon(FIcons.textCursorInput),
            onPress: () => ReadingPreferenceDialog.show(context),
          ),
          Obx(
            () => FHeaderAction(
              icon: Icon(
                controller.isBookmarked.value
                    ? FIcons.bookmarkCheck
                    : FIcons.bookmarkPlus,
              ),
              onPress: controller.toggleBookmark,
            ),
          ),
        ],
      ),
      child: PageView.builder(
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
              return const Center(child: Text('Tidak ada ayat yang tersedia'));
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          surah.type,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      Text(
                        '${String.fromCharCode(0xE800 + surah.id)}${String.fromCharCode(0xE800)}',
                        style: const TextStyle(
                          fontFamily: 'SurahQuranNU',
                          fontSize: 28,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${surah.verseCount} Ayat',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const FDivider(),
                Expanded(
                  child: Obx(() {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: QuranArabicVersesWidget(
                        verses: controller.verses.map((v) => v.text).toList(),
                        fontSize: prefs.arabicFontSize.value,
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
