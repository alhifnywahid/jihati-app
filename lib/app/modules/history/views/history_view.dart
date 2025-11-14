import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jihati/app/controllers/tab_switcher_controller.dart';
import 'package:jihati/app/modules/quran/controllers/quran_controller.dart';
import 'package:jihati/app/routes/app_pages.dart';
import 'package:jihati/app/services/quran_storage_service.dart';
import 'package:jihati/app/widgets/frame_ayat.widget.dart';
import 'package:jihati/app/widgets/jihati_list_view.widget.dart';
import 'package:jihati/app/widgets/no_result.widget.dart';
import 'package:jihati/app/widgets/tab_switcher.widget.dart';

import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final tabController = Get.put(TabSwitcherController(), tag: 'history_tabs');
    final alquranTabKey = GlobalKey<_AlquranHistoryContentState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat'),
        centerTitle: true,
        actions: [
          Obx(() {
            final isJihatiTab = tabController.selectedIndex.value == 0;
            final hasHistory = isJihatiTab
                ? controller.recentHistory.isNotEmpty
                : QuranStorageService().getHistory().isNotEmpty;
            return hasHistory
                ? IconButton(
                    icon: const Icon(Icons.clear_all),
                    onPressed: () {
                      Get.dialog(
                        AlertDialog(
                          title: const Text('Hapus Riwayat'),
                          content: Text(
                            isJihatiTab
                                ? 'Apakah Anda yakin ingin menghapus semua riwayat Jihati?'
                                : 'Apakah Anda yakin ingin menghapus semua riwayat Al-Quran?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () {
                                if (isJihatiTab) {
                                  controller.clearHistory();
                                } else {
                                  QuranStorageService().saveHistory([]);
                                  alquranTabKey.currentState?.refresh();
                                }
                                Get.back();
                              },
                              child: const Text('Hapus'),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
      body: TabSwitcherWidget(
        controllerTag: 'history_tabs',
        tabItems: [
          {'label': 'Jihati', 'content': const JihatiHistoryContent()},
          {
            'label': 'Al-Quran',
            'content': AlquranHistoryContent(key: alquranTabKey),
          },
        ],
      ),
    );
  }
}

class JihatiHistoryContent extends StatelessWidget {
  const JihatiHistoryContent({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HistoryController>();

    return Obx(() {
      final recentItems = controller.recentHistory;

      if (recentItems.isEmpty) {
        return const NoResultWidget(text: "Belum ada jihati yang riwayat!");
      }

      return JihatiListViewWidget(
        items: recentItems,
        onItemTap: (item) {
          final index = recentItems.indexOf(item);
          Get.toNamed(
            Routes.JIHATI_DETAIL,
            arguments: {
              'id': item.id,
              'arabicTitle': item.titleArabic,
              'latinTitle': item.titleLatin,
              'listItems': recentItems,
              'currentIndex': index,
            },
          );
        },
      );
    });
  }
}

class AlquranHistoryContent extends StatefulWidget {
  const AlquranHistoryContent({super.key});
  @override
  State<AlquranHistoryContent> createState() => _AlquranHistoryContentState();
}

class _AlquranHistoryContentState extends State<AlquranHistoryContent> {
  void refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final quranController = Get.find<QuranController>();
    final storage = QuranStorageService();
    final historyIds = storage.getHistory();
    final historySurah = quranController.allSurah
        .where((s) => historyIds.contains(s.id.toString()))
        .toList();

    if (historySurah.isEmpty) {
      return const NoResultWidget(text: "Belum ada al-qur'an riwayat!");
    }

    return ListView.separated(
      itemCount: historySurah.length,
      separatorBuilder: (context, index) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Divider(height: 1),
      ),
      itemBuilder: (context, index) {
        final surah = historySurah[index];
        return ListTile(
          leading: FrameAyat(text: surah.id.toString()),
          title: Text(surah.name, style: const TextStyle(fontSize: 16)),
          subtitle: Text('${surah.translate} (${surah.verseCount} ayat)'),
          trailing: Text(
            String.fromCharCode(0xE800 + (surah.id)),
            style: const TextStyle(fontSize: 28, fontFamily: "SurahQuranNU"),
          ),
          onTap: () {
            Get.toNamed(
              Routes.QURAN_DETAIL,
              arguments: {
                'surah': surah,
                'listSurah': historySurah,
                'currentIndex': index,
              },
            );
          },
        );
      },
    );
  }
}
