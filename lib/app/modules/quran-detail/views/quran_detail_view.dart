import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jihati/app/controllers/reading_preference_controller.dart';
import 'package:jihati/app/controllers/theme/theme_controller.dart';
import 'package:jihati/app/models/surah.model.dart';

import 'package:jihati/app/widgets/green_header.widget.dart';
import 'package:jihati/app/widgets/quran_arabic_verses.widget.dart';
import 'package:jihati/app/widgets/reading_preference_dialog.widget.dart';
import 'package:jihati/app/widgets/theme_sheet.widget.dart';

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
    setState(() => currentIndex = index);
    final QuranDetailController controller = Get.find();
    controller.loadSurah(surahList[index]);
  }

  @override
  Widget build(BuildContext context) {
    final prefs = Get.find<ReadingPreferenceController>();
    final QuranDetailController controller = Get.find();
    final themeC = Get.find<ThemeController>();

    return Scaffold(
      body: SafeArea(top: false,
        child: Column(
          children: [
            GreenHeader(
              title: surahList[currentIndex].name,
              suffixes: [
                Obx(() => GreenHeaderAction(
                  icon: Icon(themeC.currentThemeIcon, color: Colors.white, size: 20),
                  onPress: () => ThemeSheetDialog.show(context),
                )),
                GreenHeaderAction(
                  icon: const Icon(Icons.format_size, color: Colors.white, size: 20),
                  onPress: () => ReadingPreferenceDialog.show(context),
                ),
                Obx(() => GreenHeaderAction(
                  icon: Icon(
                    controller.isBookmarked.value
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPress: controller.toggleBookmark,
                )),
              ],
            ),
            Expanded(
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
                              bottom:
                                  BorderSide(width: 0.5, color: Colors.grey),
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
                                  '${String.fromCharCode(0xE800 + surah.id)}${String.fromCharCode(0xE800)}',
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
                                    '${surah.verseCount} Ayat',
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
                                verses: controller.verses
                                    .map((v) => v.text)
                                    .toList(),
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
            ),
          ],
        ),
      ),
    );
  }
}
