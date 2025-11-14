import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jihati/app/controllers/tab_switcher_controller.dart';
import 'package:jihati/app/modules/bookmark/controllers/bookmark_controller.dart';
import 'package:jihati/app/modules/jihati/controllers/jihati_controller.dart';
import 'package:jihati/app/modules/quran/controllers/quran_controller.dart';
import 'package:jihati/app/routes/app_pages.dart';
import 'package:jihati/app/services/quran_storage_service.dart';
import 'package:jihati/app/widgets/frame_ayat.widget.dart';
import 'package:jihati/app/widgets/jihati_list_view.widget.dart';
import 'package:jihati/app/widgets/no_result.widget.dart';
import 'package:jihati/app/widgets/tab_switcher.widget.dart';

class BookmarkView extends GetView<BookmarkController> {
  const BookmarkView({super.key});

  @override
  Widget build(BuildContext context) {
    final tabController = Get.put(
      TabSwitcherController(),
      tag: 'bookmark_tabs',
    );
    final alquranTabKey = GlobalKey<_AlquranBookmarkContentState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tersimpan'),
        centerTitle: true,
        actions: [
          Obx(() {
            final isJihatiTab = tabController.selectedIndex.value == 0;
            final bookmarkController = Get.find<BookmarkController>();
            final hasBookmark = isJihatiTab
                ? bookmarkController.bookmarks.isNotEmpty
                : QuranStorageService().getBookmarks().isNotEmpty;
            
            return hasBookmark
                ? IconButton(
                    icon: const Icon(Icons.clear_all),
                    tooltip: 'Hapus Semua',
                    onPressed: () {
                      Get.dialog(
                        AlertDialog(
                          title: const Text('Hapus Tersimpan'),
                          content: Text(
                            isJihatiTab
                                ? 'Apakah Anda yakin ingin menghapus semua bookmark Jihati?'
                                : 'Apakah Anda yakin ingin menghapus semua bookmark Al-Quran?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () {
                                if (isJihatiTab) {
                                  bookmarkController.bookmarks.clear();
                                  bookmarkController.storage.saveBookmarks([]);
                                } else {
                                  QuranStorageService().saveBookmarks([]);
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
        controllerTag: 'bookmark_tabs',
        tabItems: [
          {'label': 'Jihati', 'content': const JihatiBookmarkContent()},
          {
            'label': 'Al-Quran',
            'content': AlquranBookmarkContent(key: alquranTabKey),
          },
        ],
      ),
    );
  }
}

class JihatiBookmarkContent extends StatelessWidget {
  const JihatiBookmarkContent({super.key});

  @override
  Widget build(BuildContext context) {
    final bookmarkController = Get.find<BookmarkController>();
    final jihatiController = Get.find<JihatiController>();

    return Obx(() {
      final bookmarkIds = bookmarkController.bookmarks;

      final bookmarkedItems = jihatiController.contents
          .where((item) => bookmarkIds.contains(item.id.toString()))
          .toList();

      if (bookmarkedItems.isEmpty) {
        return const NoResultWidget(text: "Belum ada jihati yang tersimpan!");
      }

      return JihatiListViewWidget(
        items: bookmarkedItems,
        onItemTap: (item) {
          final index = bookmarkedItems.indexOf(item);
          Get.toNamed(
            Routes.JIHATI_DETAIL,
            arguments: {
              'id': item.id,
              'arabicTitle': item.titleArabic,
              'latinTitle': item.titleLatin,
              'listItems': bookmarkedItems,
              'currentIndex': index,
            },
          );
        },
      );
    });
  }
}

class AlquranBookmarkContent extends StatefulWidget {
  const AlquranBookmarkContent({super.key});
  @override
  State<AlquranBookmarkContent> createState() => _AlquranBookmarkContentState();
}

class _AlquranBookmarkContentState extends State<AlquranBookmarkContent> {
  void refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final quranController = Get.find<QuranController>();
    final storage = QuranStorageService();
    final bookmarkIds = storage.getBookmarks();
    final bookmarkedSurah = quranController.allSurah
        .where((s) => bookmarkIds.contains(s.id.toString()))
        .toList();

    if (bookmarkedSurah.isEmpty) {
      return const NoResultWidget(text: "Belum ada al-qur'an yang tersimpan!");
    }

    return ListView.separated(
      itemCount: bookmarkedSurah.length,
      separatorBuilder: (context, index) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Divider(height: 1),
      ),
      itemBuilder: (context, index) {
        final surah = bookmarkedSurah[index];
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
                'listSurah': bookmarkedSurah,
                'currentIndex': index,
              },
            );
          },
        );
      },
    );
  }
}
