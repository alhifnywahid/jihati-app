import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:jihati/app/controllers/theme/theme_controller.dart';
import 'package:jihati/app/modules/quran/controllers/quran_controller.dart';
import 'package:jihati/app/routes/app_pages.dart';
import 'package:jihati/app/widgets/custom_search_bar.widget.dart';
import 'package:jihati/app/widgets/frame_ayat.widget.dart';
import 'package:jihati/app/widgets/no_result.widget.dart';

class QuranView extends GetView<QuranController> {
  const QuranView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QuranController>();
    final searchController = TextEditingController();
    final searchFocusNode = FocusNode();
    final ThemeController themeC = Get.find();

    return FScaffold(
      header: FHeader(
        title: const Text("Al-Qur'an"),
        suffixes: [
          Obx(
            () => FHeaderAction(
              icon: Icon(themeC.currentThemeIcon),
              onPress: () => themeC.cycleTheme(),
            ),
          ),
          FHeaderAction(
            icon: const Icon(FIcons.history),
            onPress: () => Get.toNamed(Routes.history),
          ),
          FHeaderAction(
            icon: const Icon(FIcons.bookmark),
            onPress: () => Get.toNamed(Routes.bookmark),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () => searchFocusNode.unfocus(),
        child: Column(
          children: [
            CustomSearchBarWidget(
              text: 'Cari Nama Surah',
              searchController: searchController,
              focusNode: searchFocusNode,
              onChange: (query) => controller.filterSurah(query),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.filteredSurah.isEmpty &&
                    controller.searchQuery.isNotEmpty) {
                  return const NoResultWidget(text: 'Tidak ada surah yang cocok!');
                }
                return ListView.builder(
                  itemCount: controller.filteredSurah.length,
                  itemBuilder: (context, index) {
                    final surah = controller.filteredSurah[index];
                    return FTile(
                      prefix: FrameAyat(text: surah.id.toString()),
                      title: Text(surah.name, style: const TextStyle(fontSize: 16)),
                      subtitle: Text(
                        '${surah.translate} (${surah.verseCount} ayat)',
                      ),
                      suffix: Text(
                        String.fromCharCode(0xE800 + (surah.id)),
                        style: const TextStyle(
                          fontSize: 26,
                          fontFamily: 'SurahQuranNU',
                        ),
                      ),
                      onPress: () {
                        searchFocusNode.unfocus();
                        Get.toNamed(
                          Routes.quranDetail,
                          arguments: {
                            'surah': surah,
                            'listSurah': controller.filteredSurah,
                            'currentIndex': index,
                          },
                        );
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
