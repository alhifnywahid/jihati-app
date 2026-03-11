import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:jihati/app/modules/quran/controllers/quran_controller.dart';
import 'package:jihati/app/routes/app_pages.dart';
import 'package:jihati/app/services/quran_storage_service.dart';
import 'package:jihati/app/widgets/frame_ayat.widget.dart';
import 'package:jihati/app/widgets/jihati_list_view.widget.dart';
import 'package:jihati/app/widgets/no_result.widget.dart';

import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final alquranTabKey = GlobalKey<_AlquranHistoryContentState>();

    void showClearDialog(bool isJihatiTab) {
      showFDialog(
        context: context,
        builder: (context, _, __) => FDialog(
          title: const Text('Hapus Riwayat'),
          body: Text(
            isJihatiTab
                ? 'Hapus semua riwayat Jihati?'
                : 'Hapus semua riwayat Al-Quran?',
          ),
          actions: [
            FButton(
              onPress: () => Get.back(),
              child: const Text('Batal'),
            ),
            FButton(
              onPress: () {
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
    }

    return FScaffold(
      header: FHeader.nested(
        title: const Text('Riwayat'),
        prefixes: [FHeaderAction.back(onPress: () => Get.back())],
      ),
      child: FTabs(
        children: [
          FTabEntry(
            label: const Text('Jihati'),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Obx(() {
                    if (controller.recentHistory.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 8, right: 12),
                      child: FHeaderAction(
                        icon: const Icon(FIcons.trash2),
                        onPress: () => showClearDialog(true),
                      ),
                    );
                  }),
                ),
                const Expanded(child: _JihatiHistoryContent()),
              ],
            ),
          ),
          FTabEntry(
            label: const Text('Al-Quran'),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Builder(builder: (context) {
                    final hasHistory =
                        QuranStorageService().getHistory().isNotEmpty;
                    if (!hasHistory) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 8, right: 12),
                      child: FHeaderAction(
                        icon: const Icon(FIcons.trash2),
                        onPress: () => showClearDialog(false),
                      ),
                    );
                  }),
                ),
                Expanded(child: _AlquranHistoryContent(key: alquranTabKey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _JihatiHistoryContent extends StatelessWidget {
  const _JihatiHistoryContent();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HistoryController>();
    return Obx(() {
      final recentItems = controller.recentHistory;
      if (recentItems.isEmpty) {
        return const NoResultWidget(text: 'Belum ada jihati dalam riwayat!');
      }
      return JihatiListViewWidget(
        items: recentItems,
        onItemTap: (item) {
          final index = recentItems.indexOf(item);
          Get.toNamed(
            Routes.jihatiDetail,
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

class _AlquranHistoryContent extends StatefulWidget {
  const _AlquranHistoryContent({super.key});

  @override
  State<_AlquranHistoryContent> createState() => _AlquranHistoryContentState();
}

class _AlquranHistoryContentState extends State<_AlquranHistoryContent> {
  void refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final quranController = Get.find<QuranController>();
    final historyIds = QuranStorageService().getHistory();
    final historySurah = quranController.allSurah
        .where((s) => historyIds.contains(s.id.toString()))
        .toList();

    if (historySurah.isEmpty) {
      return const NoResultWidget(text: "Belum ada al-qur'an dalam riwayat!");
    }

    return ListView.builder(
      itemCount: historySurah.length,
      itemBuilder: (context, index) {
        final surah = historySurah[index];
        return FTile(
          prefix: FrameAyat(text: surah.id.toString()),
          title: Text(surah.name, style: const TextStyle(fontSize: 16)),
          subtitle: Text('${surah.translate} (${surah.verseCount} ayat)'),
          suffix: Text(
            String.fromCharCode(0xE800 + surah.id),
            style: const TextStyle(fontSize: 26, fontFamily: 'SurahQuranNU'),
          ),
          onPress: () {
            Get.toNamed(
              Routes.quranDetail,
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
