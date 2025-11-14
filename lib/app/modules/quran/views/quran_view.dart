import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';
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
    searchController.text = '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Al-Qur\'an'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.history),
            color: Colors.white,
            onPressed: () => Get.toNamed(Routes.HISTORY),
          ),
          IconButton(
            icon: const Icon(LucideIcons.bookmark),
            color: Colors.white,
            onPressed: () => Get.toNamed(Routes.BOOKMARK),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return GestureDetector(
          onTap: () => searchFocusNode.unfocus(),
          child: Column(
            children: [
              CustomSearchBarWidget(
                text: 'Cari Nama Surah',
                searchController: searchController,
                focusNode: searchFocusNode,
                onChange: (query) {
                  controller.filterSurah(query);
                },
              ),
              Expanded(
                child:
                    controller.filteredSurah.isEmpty &&
                        controller.searchQuery.isNotEmpty
                    ? NoResultWidget(text: "Tidak ada hasil pencarian!")
                    : ListView.builder(
                        itemCount: controller.filteredSurah.length,
                        itemBuilder: (context, index) {
                          final surah = controller.filteredSurah[index];
                          final isLast =
                              index == controller.filteredSurah.length - 1;
                          return Column(
                            children: [
                              ListTile(
                                leading: FrameAyat(text: surah.id.toString()),
                                title: Text(
                                  surah.name,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                subtitle: Text(
                                  '${surah.translate} (${surah.verseCount} ayat)',
                                ),
                                trailing: Text(
                                  String.fromCharCode(0xE800 + (surah.id)),
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontFamily: "SurahQuranNU",
                                  ),
                                ),
                                onTap: () {
                                  searchFocusNode.unfocus();
                                  Get.toNamed(
                                    Routes.QURAN_DETAIL,
                                    arguments: {
                                      'surah': surah,
                                      'listSurah': controller.filteredSurah,
                                      'currentIndex': index,
                                    },
                                  );
                                },
                              ),
                              if (!isLast)
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Divider(height: 1),
                                ),
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
